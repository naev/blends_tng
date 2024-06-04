#!/bin/bash

if [ -z "$1" ]
then
   for i in */*.blend
   do
      if [[ "${i:0:1}" != "_" ]]; then
         $0 "$i"
      fi
   done
else
   blender "$1" -b -P export2gltf.py -- "$1" || exit 1
fi

./postprocess.sh
