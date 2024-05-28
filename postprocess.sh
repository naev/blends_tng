#!/bin/bash

# Admonisher
sed -i 's/admonisher_pirate.bin/admonisher.bin/' gltf/Admonisher/admonisher_pirate.gltf
rm -f gltf/Admonisher/admonisher_pirate.bin
sed -i 's/admonisher_empire.bin/admonisher.bin/' gltf/Admonisher/admonisher_empire.gltf
rm -f gltf/Admonisher/admonisher_empire.bin
