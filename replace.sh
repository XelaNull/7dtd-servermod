#!/bin/bash
#
# This file is meant to be used through lines you add/remove in the 7dtd-CONFIG.sh file
#
# This script is meant to aide in easily changing default values in a file.
# It was written as I didn't want to fall into the same caveat that many other 
# Dockerfile designers are, which is to have to supply full configuration files,
# tied to a specific application version, within the Docker project. Instead, 
# this script allows to rely on the default file that the application pushes out, 
# but only search and change the specific values we need. This allows app
# developers to add new configuration parameters in their application without 
# having to re-store a new configuraiton file into the Docker project.

# This script supports finding the line to replace with either one or two grep strings.
# This is handy for situations where you have a line_grep_string1 that matches 
# multiple lines and you need to further filter down to just a single line.

# Syntax: ./replace.sh "full_file_path" "old_string" "new_string" "line_grep_string1" "line_grep_string2"

# Formulate grep command based on whether 1 or 2 grep strings were provided
if [[ $4 != "" ]] && [[ $5 != "" ]]; then CMD="grep \"$5\" \"$1\" | grep \"$4\"";
elif [[ $4 != "" ]]; then CMD="grep $4 $1"
else 
  echo "ERROR in Syntax! Missing Variable.\nSyntax: ./replace.sh full_file_path old_string new_string line_grep_string1 line_grep_string2(optional)\n";
  exit
fi

# Run the grep command to find the line within the file we need to perform the sub_string replacement on
found_line=`$CMD`;
if [[ $found_line == "" ]]; then
  echo "ERROR: Nothing found from grep command: [$CMD]\n";
  exit
fi
if [[ `echo "$found_line" | wc -l` > 1 ]]; then
  echo "ERROR: Your grep string(s) matched more than one line: [$CMD]\n";
  exit
fi

# Craft new replacement line that contains old_string swapped out in favor of new_string
new_line=`echo "${found_line/$2/$3}"`
if [[ $new_line == "" ]]; then
  echo "ERROR: New line[$new_line] crafted from old line[$found_line] is blank. [$2] [$3]\n";
  exit
fi

# Make sure that the delimeter we are using in the grep command next is not present in any of the strings
if [[ $found_line == *"|"* ]] || [[ $new_line == *"|"* ]]; then
  echo "ERROR: The grep delimeter character | is found within the line being replaced. Change the grep_delimeter character.";
  exit
fi

# Perform string search and perform an in-line replacement of the entire line
sed -i "s|.*$found_line.*|$new_line|" $1