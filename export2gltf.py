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
ret = subprocess.run(["gltf-transform", "optimize", "--compress", "false", "--texture-compress", "auto", "--simplify", "false", "--instance", "false", "--texture-size", "1024", blenderpath, gltfpath ])
if ret.returncode != 0:
    print("Problem optimizing mesh!")
    sys.exit(-1)

"""
os.chdir(shipdir)
with open(shipname + '.mtl') as mtlfile:
    mtltext = mtlfile.read()

for i in os.listdir():
    name, ext = os.path.splitext(i)
    if ext not in ('.obj', '.mtl', '.png'):
        oldname, ext, i = i, '.png', f'{name}.png'
        print(f'Converting {oldname} to {i}...')
        subprocess.call(['convert', oldname, i])
        os.unlink(oldname)
        mtltext = mtltext.replace(oldname, i)

with open(shipname + '.mtl', 'w') as mtlfile:
    mtlfile.write(mtltext)
"""
