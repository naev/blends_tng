#!/bin/bash

if [ -z "$1" ]
then
   for i in */*.blend
   do
      $0 "$i"
   done
else
   blender "$1" -b -P export2gltf.py -- "$1" || exit 1
fi
