#!/bin/bash

# Create paired formats for all logos (PDF->PNG and PNG->PDF)
# Requires ImageMagick to be installed

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
  echo "Error: ImageMagick not installed. Please install it first."
  exit 1
fi

# Process each directory
for dir in */; do
  # Skip if not a directory
  [ -d "$dir" ] || continue
  
  echo "Processing directory: $dir"
  
  # Convert PDFs to PNGs
  find "$dir" -name "*.pdf" | while read -r pdf_file; do
    base_name="${pdf_file%.pdf}"
    png_file="${base_name}.png"
    
    if [ ! -f "$png_file" ]; then
      echo "Creating PNG from $pdf_file"
      convert -density 300 "$pdf_file" -background white -alpha remove -alpha off "$png_file"
    fi
  done
  
  # Convert PNGs to PDFs
  find "$dir" -name "*.png" | while read -r png_file; do
    base_name="${png_file%.png}"
    pdf_file="${base_name}.pdf"
    
    if [ ! -f "$pdf_file" ]; then
      echo "Creating PDF from $png_file"
      convert "$png_file" "$pdf_file"
    fi
  done
done

echo "Conversion complete! All logos now have both PDF and PNG formats."