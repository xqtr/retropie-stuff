#!/bin/bash

# https://github.com/xqtr/retropie-stuff
# GPL3 License

# based on meleu's scripts:
# https://github.com/meleu/share
# https://github.com/meleu/share/blob/master/gamelist-cleaner.sh


#    $1 - the system (eg: atari2600, nes, snes, megadrive, fba, etc).
#    $2 - the emulator (eg: lr-stella, lr-fceumm, lr-picodrive, pifba, etc).
#    $3 - the full path to the rom file.
#    $4 - the full command line used to launch the emulator.

function pause {
  read -n 1 -s -r -p "Press any key to continue"
}

system="$HOME/RetroPie/roms/$1"
gamelist=$system"/gamelist.xml"
clean=$system"/gamelist-clean.xml"


#Check if gamelist exists
if [[ ! -f "$gamelist" ]]; then
  dialog --title "Clean Gamelist - $1" --msgbox "File doesn't exist." 10 50
  exit 0
fi

#make backup
cp $gamelist $system"/gamelist_$(date +%F_%H%M%S).bak"

#create clean gamelist copy
cp $gamelist $clean


#clean the gamelist
while read -r path; do
  full_path="$path"
  [[ "$path" == ./* ]] && full_path="$system/$path"
  full_path="$(echo "$full_path" | sed 's/&amp;/\&/g')"
  [[ -f "$full_path" ]] && continue

  xmlstarlet ed -L -d "/gameList/game[path=\"$path\"]" "$clean"
  echo "The game with <path> = \"$path\" has been removed from xml."
done < <(xmlstarlet sel -t -v "/gameList/game/path" "$gamelist"; echo)

rm $gamelist
mv $clean $gamelist

exit 0
