#!/bin/bash

# https://github.com/xqtr/retropie-stuff
# GPL3 License

# Add it to /opt/retropie/configs/all/runcommand-menu
# Now go to the system you want and press to play a game.
# While showing the runcommand script, press a key, and
# go to User scripts. Select it and vouala... 

# The script will delete the rom file and also let you select
# if you want to delete images/covers etc.

# It will not clean the gamelist.xml. Do that with the other 
# script in this repo.

#    $1 - the system (eg: atari2600, nes, snes, megadrive, fba, etc).
#    $2 - the emulator (eg: lr-stella, lr-fceumm, lr-picodrive, pifba, etc).
#    $3 - the full path to the rom file.
#    $4 - the full command line used to launch the emulator.

function pause {
  read -n 1 -s -r -p "Press any key to continue"
}

#system="~/RetroPie/roms/$1"
system="$HOME/RetroPie/roms/$1"
boxart=$system"/boxart"
media=$system"/media"
videos=$media"/videos"
images=$media"/images"
wheel=$media"/wheel"
marquees=$media"/marquees"
covers=$media"/covers"
screenshots=$media"/screenshots"
bn="$(basename -- $3)"    # filename
fn="${bn%.*}"             # filename, no ext.


if [[ ! -f "$3" ]]; then
  dialog --title "Delete ROM - $1" --msgbox "File doesn't exist." 10 50
  exit 0
fi

#Get files in other folders too

fls=()

for file in $system/$fn.*; do
  fls+=($file)
done
for file in $videos/$fn.*; do
  fls+=($file)
done
for file in $images/$fn.*; do
  fls+=($file)
done
for file in $wheel/$fn.*; do
  fls+=($file)
done
for file in $marquees/$fn.*; do
  fls+=($file)
done
for file in $screenshots/$fn.*; do
  fls+=($file)
done
for file in $covers/$fn.*; do
  fls+=($file)
done
for file in $boxart/$fn.*; do
  fls+=($file)
done

# Create text variable for found files
printf -v joined '%s\n' "${fls[@]}"


#Delete main rom file
dialog --title "Delete ROM - $1" --yesno "Are you sure to delete '$bn' ROM?" 10 70
if [[ $? -eq 0 ]]
then
  if [[ -f "$3" ]]; then
    #If other files exist, ask confirmation to delete them.
    if [ ${#fls[@]} -gt 0 ]; then
      dialog --title "Delete ROM - $1" --yesno "Delete also these files: \n${joined%,}" 16 70
      if [[ $? -eq 0 ]]
        then 
        for each in "${fls[@]}"
        do
          rm "$each"
        done
      fi
    fi
    echo "Deleting ROM file: $3"
    rm "$3"
  fi
fi

#pause

exit 0
