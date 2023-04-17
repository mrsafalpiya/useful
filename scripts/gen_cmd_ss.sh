#!/bin/bash

# About this script
# -----------------
# This script will run the given command and give the screenshot of the output.

# Settings
# --------

USER="safal"
HOST="piya"

BACKGROUND="black"
FOREGROUND="white"
PROMPT_FOREGROUND="#70BFB0"

IMAGE_SIZE="676x324"

FONT="Terminus"
FONT_SIZE="10.5"

# Main script
# -----------

## Usage check

if [ $# != 3 ]; then
	cat <<EOM
Usage: $(basename $0) working_path command_to_run output_image_basename

Example:
$(basename $0) ~/Documents ls ls-documents
Will run the ls command in ~/Documents and give the image output with filename ls-documents.jpeg
EOM
	exit 0
fi

## Setup variables

CMD="$2"
WD=$(realpath $1)

### Get the proper output file name to set

OUT_NAME="$3"

OUT="$(realpath $OUT_NAME.jpeg)"
number=0

while [ -e "$OUT" ]; do
	printf -v OUT '%s-%02d.jpeg' "$(realpath $OUT_NAME)" "$(( ++number ))"
done

## Run commands

cd "$WD"
CMD_OUTPUT="$($CMD)"

WD="~${WD##$HOME}"

convert -background "$BACKGROUND" -fill "$FOREGROUND" -size "$IMAGE_SIZE" -font "$FONT" -pointsize "$FONT_SIZE" \
	pango:"<b><span foreground=\"$PROMPT_FOREGROUND\">$USER@$HOST $WD $</span></b> $CMD\n$CMD_OUTPUT" \
	"$OUT"
