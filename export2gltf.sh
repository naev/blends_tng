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
   for var in "$@"
   do
      blender "$var" -b -P export2gltf.py -- "$var" || exit 1
   done
fi

./postprocess.sh
