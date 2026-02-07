#!/bin/bash

# Use current directory if no path is provided
TARGET_DIR="${1:-.}"

# Function to move files safely without overwriting
move_file_safely() {
    local SOURCE_FILE="$1"
    local DEST_DIR="$2"

    local BASENAME
    BASENAME=$(basename "$SOURCE_FILE")

    local NAME="${BASENAME%.*}"
    local EXT="${BASENAME##*.}"

    local DEST_FILE="$DEST_DIR/$BASENAME"
    local COUNT=1

    # Rename file if it already exists
    while [ -e "$DEST_FILE" ]; do
        DEST_FILE="$DEST_DIR/${NAME}_$COUNT.$EXT"
        COUNT=$((COUNT + 1))
    done

    mv "$SOURCE_FILE" "$DEST_FILE"
    echo "Moved $(basename "$SOURCE_FILE") → $(basename "$DEST_FILE")"
}

# Loop through all files
for FILE in "$TARGET_DIR"/*; do

    # Skip directories
    [ -d "$FILE" ] && continue

    EXT="${FILE##*.}"

    # Images
    if [[ "$EXT" == "jpg" || "$EXT" == "jpeg" || "$EXT" == "png" ]]; then
        mkdir -p "$TARGET_DIR/Images"
        move_file_safely "$FILE" "$TARGET_DIR/Images"

    # Documents
    elif [[ "$EXT" == "pdf" || "$EXT" == "txt" || "$EXT" == "docx" ]]; then
        mkdir -p "$TARGET_DIR/Documents"
        move_file_safely "$FILE" "$TARGET_DIR/Documents"

    # Videos
    elif [[ "$EXT" == "mp4" || "$EXT" == "mkv" || "$EXT" == "avi" ]]; then
        mkdir -p "$TARGET_DIR/Videos"
        move_file_safely "$FILE" "$TARGET_DIR/Videos"

    # Scripts
    elif [[ "$EXT" == "sh" || "$EXT" == "py" ]]; then
        mkdir -p "$TARGET_DIR/Scripts"
        move_file_safely "$FILE" "$TARGET_DIR/Scripts"
    fi

done

echo "File organization completed successfully without overwriting files!"
