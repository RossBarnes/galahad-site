#!/bin/bash

# Check for unclosed tags and basic HTML issues
for html_file in *.html; do
  [ ! -f "$html_file" ] && continue
  
  echo "=== $html_file ==="
  
  # Check doctype
  if ! head -1 "$html_file" | grep -q "<!DOCTYPE"; then
    echo "WARNING: Missing DOCTYPE"
  fi
  
  # Count opening and closing tags for common elements
  for tag in div section article nav footer header main; do
    open_count=$(grep -o "<$tag\b" "$html_file" | wc -l)
    close_count=$(grep -o "</$tag>" "$html_file" | wc -l)
    if [ "$open_count" -ne "$close_count" ]; then
      echo "ERROR: Tag <$tag> mismatch: $open_count open, $close_count close"
    fi
  done
  
  # Check for missing alt attributes on images
  img_count=$(grep -c "<img " "$html_file")
  alt_count=$(grep "<img " "$html_file" | grep -c 'alt="')
  if [ "$img_count" -gt "$alt_count" ]; then
    echo "WARNING: $((img_count - alt_count)) images missing alt attributes"
    grep "<img " "$html_file" | grep -v 'alt="' | head -3
  fi
  
  # Check for self-closing tags
  sr_count=$(grep -c "<br>" "$html_file")
  if [ "$sr_count" -gt 0 ]; then
    echo "INFO: Found $sr_count <br> tags (should be <br/>)"
  fi
  
done
