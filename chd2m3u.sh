#!/bin/bash
echo "CHD to M3U Generator"
echo "===================="

echo "Removing all old m3u files..."
rm -f *.m3u

# Statistics
single_count=0
multi_count=0
processed_games=()

# Processing all .chd files in current folder
for chd_file in *.chd; do
    [ -f "$chd_file" ] || continue

    filename="$chd_file"
    echo "Processing: $filename"

    # Check if file contains "(Disc" pattern (case-insensitive)
    if [[ "$filename" =~ \([Dd]isc[[:space:]]*[0-9A-Za-z]+\) ]]; then
        # Multi-disc file - remove everything from "(Disc" to ".chd"
        # Keep everything BEFORE the first occurrence of "(Disc"
        base_name=$(echo "$filename" | sed -E 's/[[:space:]]*\([Dd]isc[[:space:]]*[0-9A-Za-z]+\)[^.]*\.chd$//')

        # Alternative pattern if first one didn't work
        if [ -z "$base_name" ] || [[ "$base_name" == *"("* ]]; then
            base_name=$(echo "$filename" | sed -E 's/\([Dd]isc[[:space:]]*[0-9A-Za-z]+\)[^.]*\.chd$//')
        fi

        # Clean up leading/trailing spaces
        base_name=$(echo "$base_name" | sed -E 's/^[[:space:]]+|[[:space:]]+$//g')

        if [ -n "$base_name" ]; then
            # Add to .m3u file
            echo "$filename" >> "${base_name}.m3u"
            echo "  -> added to '${base_name}.m3u'"

            # Track unique game names
            if [[ ! " ${processed_games[@]} " =~ " ${base_name} " ]]; then
                processed_games+=("$base_name")
                ((multi_count++))
            fi
        else
            echo "  ! Could not determine game name"
        fi
    else
        # Single file - create .m3u with same name (without .chd)
        base_name="${filename%.chd}"
        echo "$filename" > "${base_name}.m3u"
        echo "  -> created '${base_name}.m3u' (single disc)"
        ((single_count++))
        processed_games+=("$base_name")
    fi
done

# Count created .m3u files and their contents
echo ""
echo "Results:"
echo "--------"

if [ ${#processed_games[@]} -eq 0 ]; then
    echo "No .chd files found in current folder"
    exit 0
fi

# Display information about created .m3u files
total_disks=0
for m3u_file in *.m3u; do
    [ -f "$m3u_file" ] || continue

    file_count=$(grep -c "\.chd$" "$m3u_file" 2>/dev/null || echo "0")
    total_disks=$((total_disks + file_count))

    if [ "$file_count" -eq 1 ]; then
        echo "📀 $m3u_file (1 disc)"
    elif [ "$file_count" -gt 1 ]; then
        echo "📀📀 $m3u_file ($file_count discs)"
    else
        echo "? $m3u_file (empty)"
    fi
done

echo ""
echo "Statistics:"
echo "  Total CHD files processed: $total_disks"
echo "  Total M3U files created: ${#processed_games[@]}"
echo "  - Single-disc games: $single_count"
echo "  - Multi-disc games: $multi_count"
echo ""
echo "Done! All .m3u files created in current folder."

