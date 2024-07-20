#!/bin/bash

function p () {
   GLTF="$1"
   SED="$2"
   BIN="$3"
   if [ -f "${GLTF}" ]; then
      sed -i "${SED}" "${GLTF}"
      rm -f "${BIN}"
   fi
}

# Admonisher
p gltf/Admonisher/admonisher_pirate.gltf 's/admonisher_pirate.bin/admonisher.bin/' gltf/Admonisher/admonisher_pirate.bin
p gltf/Admonisher/admonisher_empire.gltf 's/admonisher_empire.bin/admonisher.bin/' gltf/Admonisher/admonisher_empire.bin

# Ancestor
p gltf/Ancestor/ancestor_pirate.gltf 's/ancestor_pirate.bin/ancestor.bin/' gltf/Ancestor/ancestor_pirate.bin
p gltf/Ancestor/ancestor_dvaered.gltf 's/ancestor_dvaered.bin/ancestor.bin/' gltf/Ancestor/ancestor_dvaered.bin

# Phalanx
p gltf/Phalanx/phalanx_pirate.gltf 's/phalanx_pirate.bin/phalanx.bin/' gltf/Phalanx/phalanx_pirate.bin
p gltf/Phalanx/phalanx_dvaered.gltf 's/phalanx_dvaered.bin/phalanx.bin/' gltf/Phalanx/phalanx_dvaered.bin

# Kestrel
p gltf/Kestrel/kestrel_pirate.gltf 's/kestrel_pirate.bin/kestrel.bin/' gltf/Kestrel/kestrel_pirate.bin

# Pacifier
p gltf/Pacifier/pacifier_empire.gltf 's/pacifier_empire.bin/pacifier.bin/' gltf/Pacifier/pacifier_empire.bin

# Hawking
p gltf/Hawking/hawking_empire.gltf 's/hawking_empire.bin/hawking.bin/' gltf/Hawking/hawking_empire.bin

# Rhino
p gltf/Rhino/rhino_pirate.gltf 's/rhino_pirate.bin/rhino.bin/' gltf/Rhino/rhino_pirate.bin

# Hyena
p gltf/Hyena/hyena_pirate.gltf 's/hyena_pirate.bin/hyena.bin/' gltf/Hyena/hyena_pirate.bin

# Goddard
p gltf/Goddard/goddard_dvaered.gltf 's/goddard_dvaered.bin/goddard.bin/' gltf/Goddard/goddard_dvaered.bin

# Vigilance
p gltf/Vigilance/vigilance_dvaered.gltf 's/vigilance_dvaered.bin/vigilance.bin/' gltf/Vigilance/vigilance_dvaered.bin

# Lancelot
p gltf/Lancelot/lancelot_empire.gltf 's/lancelot_empire.bin/lancelot.bin/' gltf/Lancelot/lancelot_empire.bin

# Shark
p gltf/Shark/shark_pirate.gltf 's/shark_pirate.bin/shark.bin/' gltf/Shark/shark_pirate.bin
p gltf/Shark/shark_empire.gltf 's/shark_empire.bin/shark.bin/' gltf/Shark/shark_empire.bin

# Vendetta
p gltf/Vendetta/vendetta_pirate.gltf 's/vendetta_pirate.bin/vendetta.bin/' gltf/Vendetta/vendetta_pirate.bin
p gltf/Vendetta/vendetta_dvaered.gltf 's/vendetta_dvaered.bin/vendetta.bin/' gltf/Vendetta/vendetta_dvaered.bin

# Shared textures
mkdir -p gltf/textures/
for TEX in textures/*.png; do
   TEX=${TEX%.png}.webp
   TEX=${TEX#textures/}
   for GLTF in gltf/*; do
      if [[ $(dirname "${GLTF}/${TEX}") != "gltf/textures" && -f "${GLTF}/${TEX}" ]]; then
         mv "${GLTF}/${TEX}" gltf/textures/
         sed -i "s@\"${TEX}\"@\"../textures/${TEX}\"@" "${GLTF}"/*.gltf
      fi
   done
done
