import os
import subprocess
import bpy
import shutil
import tempfile
import subprocess
import sys

OUTPATH = "gltf"

argv = sys.argv
if "--" in argv:
    argv = argv[argv.index("--") + 1:]  # get all args after "--"
    filename = argv[0]
else:
    filename = bpy.data.filepath
dirname = os.path.split(os.path.dirname(filename))[-1]
shipname = os.path.splitext(os.path.basename(filename))[0]

shipdir = os.path.abspath(os.path.join(OUTPATH, dirname))
os.makedirs(shipdir, exist_ok=True)
gltfpath = os.path.join(shipdir, shipname) + '.gltf'

for mat in bpy.data.materials:
     mat.use_backface_culling = True

# We'll export the entire scene
blenderdir = tempfile.TemporaryDirectory()
blenderbase = f"{os.path.basename(filename).split('.')[0]}"
blenderpath = f"{blenderdir.name}/{blenderbase}/{blenderbase}.gltf"
os.makedirs( os.path.dirname(blenderpath), exist_ok=True )

# Export from blender
bpy.ops.export_scene.gltf( filepath=blenderpath, export_format='GLTF_SEPARATE', \
        export_lights=False, export_cameras=False, export_normals=True, \
        export_extras=True, export_apply=True, use_visible=True )

# And optimize
commands = (
    ["dedup",],
    ["instance",],
    ["palette",],
    #["flatten",], # breaks special nodes
    #["join",], # breaks special nodes
    #["weld",], # breaks special nodes
    #["simplify",], # breaks special nodes
    ["resample",],
    ["prune", "--keep-leaves", "true",],
    ["sparse",],
    ["resize", "--width", "1024", "--height", "1024",],
    ["webp", "--lossless", "true", "--effort", "100",],
    #["meshopt"], # not supported by Naev
)
#commands = (
#    ["optimize", "--compress", "false", "--texture-compress", "webp", "--simplify", "false", "--instance", "false", "--texture-size", "1024"],
#)
def run_command( c, pathin, pathout ):
    cmd = ["gltf-transform",] + c + [pathin, pathout]
    ret = subprocess.run( cmd )
    if ret.returncode != 0:
        print("Problem optimizing mesh!")
        sys.exit(-1)
    return pathout
pathin = blenderpath
for c in commands[:-1]:
    pathout = f"{blenderdir.name}/{blenderbase}/{blenderbase}_{c[0]}.gltf"
    run_command( c, pathin, pathout )
    pathin = pathout
run_command( commands[-1], pathin, gltfpath )
