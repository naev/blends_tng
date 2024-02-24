
# Temporary Naev repository for 3D ship blend files

These are in process of being converted from the myriad of old formats and updated so that they can export cleanly to the gltf format being used by Naev.


## Format

The format basically consists of two scenes:

1. The **base** scene is the standard model that should be used.
2. The **engine** scene is the model to use when doing engine glows. It will be rendered separately and interpolated with the base one.

As each scene is rendered indepently and merged, it's possible to do all sorts of global illumination effects with baking.

## Baking

When possible, it is recommended to bake ambient occlusion and emission maps for the model. To do this, use the `bake_ao` and `bake_glo` prepared in most models.

## Creating a New Model

1. Start with a template, in general, use the `gawain`
1. In the **base** scene, import the new model (if modelled separately) or create a new one, and remove the original gawain model
1. Check to see if the model has a single texture, if so, you can use the **base** material as a reference with the existing textures. If not, you have to do UV mapping with the substeps below
    1. If model is symmetric, either use `bisect` or just delete have the model and use a `mirror` symmetry modifier
    1. Create a new UV mapping, name the original **base_uv** and the new one **bake_uv**
    1. Now you have to adjust the new UV mapping. Using `smart UV` + `pack islands` is the braindead approach to getting it done
1. Bake the Ambient Occlusion (AO) using the **bake_ao** material on the model. You may have to adjust the texture size
1. Now duplicate the **base** model and add it to the **engine** scene
1. Add the glow which should be based on the ship fabricator. You can import the materials from `materials.blend` in the main directory
1. When done, it's time to bake the emission. Use the **bake_glo** material. Make sure you are not using emissions, only the emissions from the glow objects
1. Save everything. Make sure it is using relative paths and unpacked.
1. Now use gimp or whatever program you want to merge the emission texture (if applicable) into the baked glow texture. You should simplify copy the regular emission texture on top, and make sure the layer is set to `additive`. Save on top of the original texture
1. Export the model using the `export2gltf.sh` script. It'll create the files in `gltf/`
1. Finally use `utils/model-view-c/` in the main Naev repository to check to see if the model looks OK. Look at the engine glow too by pressing the `e` key
1. If all went well, you can now move tho model into the game and create the collision polygons with `utils/polygonize.py`

## Notes

* Some complicated models do not allow the above approach for baking textures because everything gets too small. In those cases, you can ignore baking (at least for now, unless you can simplify the models)
