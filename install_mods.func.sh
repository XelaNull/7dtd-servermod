#!/bin/bash 

# Create Bash Function to handle the different downloads
function gdrive_download () {
  ((MODCOUNT++))
  mkdir $MODS_DIR/$MODCOUNT
  CONFIRM=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=$1" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')
  wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$CONFIRM&id=$1" -O $MODS_DIR/$MODCOUNT/$2
  rm -rf /tmp/cookies.txt
  echo "https://docs.google.com/uc?export=download&id=$1" > $MODS_DIR/$MODCOUNT/ModURL.txt
  [[ "$3" == "extract_file" ]] && extract_file $2
}

function git_clone () {
  ((MODCOUNT++))
  mkdir $MODS_DIR/$MODCOUNT && cd $MODS_DIR/$MODCOUNT
#  export AUTHOR=`echo $1 | sed 's|.git||g' | rev | cut -d'/' -f2 | rev | sed 's|/||g'`
  export CLONED_INTO=`echo $1 | sed 's|.git||g' | rev | cut -d'/' -f1 | rev`
  echo "GIT Cloning $AUTHOR's $CLONED_INTO.."
  # Delete the directory if it currently exists
  [[ -d $CLONED_INFO ]] && rm -rf $CLONED_INTO
  git clone $1  
#  echo "$AUTHOR" > $CLONED_INTO/ModAUTHOR.txt
  echo "$1" > $MODS_DIR/$MODCOUNT/ModURL.txt
  cd $MODS_DIR
}
function dropbox_download () {
  ((MODCOUNT++))
  mkdir $MODS_DIR/$MODCOUNT && cd $MODS_DIR/$MODCOUNT
  echo "Using CURL to download $1 and save as $2"
  curl -L "$1" > $2
  echo "$1" > $MODS_DIR/$MODCOUNT/ModURL.txt
  [[ "$3" == "extract_file" ]] && extract_file $2
  cd $MODS_DIR
}
function wget_download () {
  ((MODCOUNT++))
  mkdir $MODS_DIR/$MODCOUNT && cd $MODS_DIR/$MODCOUNT
  echo "Using WGET to download $1 and save as $2"
  wget -O $2 "$1" 
  echo "$1" > $MODS_DIR/$MODCOUNT/ModURL.txt
  [[ "$3" == "extract_file" ]] && extract_file $2
  cd $MODS_DIR 
}
function extract_file () {
  filename=$1
  extension="${filename##*.}"
  cd $MODS_DIR/$MODCOUNT
  if [[ "$extension" == "rar" ]]; then unrar x -o+ $1
  elif [[ "$extension" == "zip" ]]; then unzip -o $1
  elif [[ "$extension" == "7z" ]]; then 7z x $1
  fi
  cd $MODS_DIR
}