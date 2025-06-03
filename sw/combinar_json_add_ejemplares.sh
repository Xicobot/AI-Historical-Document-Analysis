#!/bin/bash
# Clean up any previous combined.json and temp directory
rm -f combined.json
rm -f temp.json
rm -rf temp_json

# Get the current directory name (year)
YEAR=$(basename "$(pwd)")

# Create directory for processed files
mkdir -p temp_json

# Create the initial JSON structure
echo '{
    "Año": '"$YEAR"',
    "ejemplares": [' > combined.json

# Process each JSON file
process_json() {
    local file="$1"
    local is_first="$2"
    local base_name="${file%.json}.pdf" # Replace the .json extension to .pdf
    local temp_file="temp_json/$(basename "$file")"
    
    # Extract content from file but preserve the structure
    cat "$file" > "$temp_file"
    
    # Use jq to add the PDF field if jq is installed
    if command -v jq &> /dev/null; then
        # Add PDF field to the JSON structure
        jq --arg pdf "$base_name" '. + {"PDF": $pdf}' "$temp_file" > "${temp_file}.tmp" && mv "${temp_file}.tmp" "$temp_file"
    else
        # Manual insertion if jq is not available
        # This is a simplified approach and might not work for complex JSON structures
        sed -i '1s/{/{\"PDF\": \"'"$base_name"'\", /' "$temp_file"
    fi
    
    # Add comma if it's not the first file
    if [ "$is_first" != "true" ]; then
        echo "," >> combined.json
    fi
    
    # Append the processed content
    cat "$temp_file" >> combined.json
}

# Process all JSON files in the current directory
first_file=true
for file in *.json; do
    # Skip the combined.json file
    if [ "$file" != "combined.json" ] && [ "$file" != "temp.json" ]; then
        process_json "$file" "$first_file"
        first_file=false
    fi
done

# Close the JSON array and object
echo '
    ]
}' >> combined.json

# Clean up temporary files
rm -rf temp_json

# Optional: Format the final JSON (if jq is installed)
if command -v jq &> /dev/null; then
    jq '.' combined.json > temp.json && mv temp.json combined.json
fi

echo "JSON files have been combined into combined.json with the new structure"
