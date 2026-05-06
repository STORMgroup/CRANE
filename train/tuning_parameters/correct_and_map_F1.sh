#!/bin/bash
set -e

# This is a helper script which corrects and maps the training reads, then returns the F1 score

PSTAY=$1
PSKIP=$2
WINDOWSIZE=$3
THREAD=$4
MODEL=$5
SEGMENTER=$6
RUN_ID=$7  # Unique tag (e.g. modelname_segmenter) to avoid collisions between parallel runs
HPC=$8

# Correct

CRANE_PATH="../../src/crane"
DATA_DIR="../../test/data/crane_datasets/CRANE_data/d0_ecoli_training"

"$CRANE_PATH" "$MODEL" "${DATA_DIR}/d0_ecoli_training_${SEGMENTER}_events.tsv" "$PSTAY" "$PSKIP" -t $THREAD --window-size "${WINDOWSIZE}" > "${DATA_DIR}/d0_ecoli_training_${SEGMENTER}_events_corrected_${RUN_ID}.tsv"


# Map

EXEC="rawhash2"
INDEX="./indexes/rawhash2_training_index_${HPC}.ind"
SIGNALS="../../test/data/crane_datasets/CRANE_data/d0_ecoli_training/"

OUTDIR="out_rh2_${RUN_ID}"
EVENTS="${DATA_DIR}/d0_ecoli_training_${SEGMENTER}_events_corrected_${RUN_ID}.tsv"
PARAMS="--r10 -w 0 --events-file ${EVENTS}"

if [[ "$HPC" == "hpc_off" ]]; then
    PARAMS="${PARAMS} --sig-diff -1"
fi

mkdir -p "$OUTDIR"

rawhash2 -x r10 -t ${THREAD} ${PARAMS} \
-o "${OUTDIR}/corrected_rawhash2.paf" \
"${INDEX}" \
${SIGNALS}

# Get F1 score

GT="../../test/data/crane_datasets/CRANE_data/d0_ecoli_training/d0_ecoli_training_true_mappings.paf"
python ../../test/scripts/pafstats.py -r "$GT" --annotate "${OUTDIR}/corrected_rawhash2.paf" > "${OUTDIR}/annotated.paf" 2> "${OUTDIR}/throughput.txt"

F1=$(awk '
/^T/ { TP=$2 }
/^F/ { FP=$2; FN=$3 }

END {
    p = (TP+FP>0)?TP/(TP+FP):0
    r = (TP+FN>0)?TP/(TP+FN):0
    f1 = (p+r>0)?2*p*r/(p+r):0
    printf "%.6f", f1
}
' "${OUTDIR}/throughput.txt")

echo "F1 Score: ${F1}"