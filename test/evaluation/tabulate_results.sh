#!/bin/bash

OUTPUT="summary_results.csv"
TMPFILE=$(mktemp)

echo "Dataset,HPC,Segmenter,Corrected,F1,Precision,Recall,Mean_MS_to_map" > "$OUTPUT"

find . -name "summary.txt" | sort | while read -r summary_file; do
    echo "Processing: $summary_file"

    while IFS= read -r line || [[ -n "$line" ]]; do

        if [[ "$line" =~ ^File:\ (.+) ]]; then
            filepath="${BASH_REMATCH[1]}"

            filename=$(basename "$filepath")
            filename="${filename%.*}"

            if [[ "$filename" =~ ^(d[0-9]+)_ ]]; then
                dataset="${BASH_REMATCH[1]^^}"
            else
                dataset="unknown"
            fi

            if [[ "$filename" =~ hpc_on ]]; then
                hpc="on"
            elif [[ "$filename" =~ hpc_off ]]; then
                hpc="off"
            else
                hpc="unknown"
            fi

            if [[ "$filename" =~ scrappieR10 ]]; then
                segmenter="scrappieR10"
            elif [[ "$filename" =~ scrappieR9 ]]; then
                segmenter="scrappieR9"
            elif [[ "$filename" =~ campolina ]]; then
                segmenter="campolina"
            else
                segmenter="unknown"
            fi

            if [[ "$filename" =~ corrected ]]; then
                corrected="Yes"
                corrected_sort=1
            else
                corrected="No"
                corrected_sort=2
            fi

        elif [[ "$line" =~ ^Precision:\ ([0-9.]+) ]]; then
            precision="${BASH_REMATCH[1]}"

        elif [[ "$line" =~ ^Recall:\ ([0-9.]+) ]]; then
            recall="${BASH_REMATCH[1]}"

        elif [[ "$line" =~ ^F1\ score:\ ([0-9.]+) ]]; then
            f1="${BASH_REMATCH[1]}"

        elif [[ "$line" =~ ^MS\ to\ map\ \(mean/median\):\ ([0-9.]+)\ /\ ([0-9.]+) ]]; then
            ms_mean="${BASH_REMATCH[1]}"

            # Write to temp file with sort key prefix: dataset|hpc_sort|segmenter|corrected_sort
            # hpc: on=1, off=2
            [[ "$hpc" == "on" ]] && hpc_sort=1 || hpc_sort=2

            echo "$dataset|$hpc_sort|$segmenter|$corrected_sort|$dataset,$hpc,$segmenter,$corrected,$f1,$precision,$recall,$ms_mean" >> "$TMPFILE"

            # Reset
            filepath="" dataset="" hpc="" hpc_sort="" segmenter="" corrected="" corrected_sort=""
            precision="" recall="" f1="" ms_mean=""
        fi

    done < "$summary_file"
done

# Sort by: dataset, hpc (on first), segmenter (alphabetical), corrected (Yes first)
sort -t'|' -k1,1 -k2,2n -k3,3 -k4,4n "$TMPFILE" | cut -d'|' -f5- >> "$OUTPUT"

rm "$TMPFILE"

echo ""
echo "Done! Results written to: $OUTPUT"
echo "Total rows: $(( $(wc -l < "$OUTPUT") - 1 ))"