#!/bin/bash
set -e

THREAD=$1
HPC=$2

DATA_DIR="../../test/data/crane_datasets/CRANE_data/d0_ecoli_training/"

PORE="../../extern/kmer_models/uncalled_r1041_model_only_means.txt"

mkdir -p "indexes"

REF="../../test/data/crane_datasets/CRANE_data/d1_ecoli_small/d1_ecoli_ref.fa"

PARAMS="-w 0"

if [[ "$HPC" == "hpc_off" ]]; then
    PARAMS="${PARAMS} --sig-diff -1"
fi

echo "Creating index..."
rawhash2 -x r10 -t ${THREAD} -p "${PORE}" ${PARAMS} \
-d "./indexes/rawhash2_training_index_baseline.ind" \
${REF}


EXEC="rawhash2"
INDEX="./indexes/rawhash2_training_index_baseline.ind"
SIGNALS="../../test/data/crane_datasets/CRANE_data/d0_ecoli_training/"
GT="../../test/data/crane_datasets/CRANE_data/d0_ecoli_training/d0_ecoli_training_true_mappings.paf"

OUTDIR="rh2_baseline"

mkdir -p "$OUTDIR"


SEGMENTER="scrappieR9"
EVENTS="${DATA_DIR}/d0_ecoli_training_${SEGMENTER}_events.tsv"
PARAMS="--r10 -w 0 --events-file ${EVENTS}"

if [[ "$HPC" == "hpc_off" ]]; then
    PARAMS="${PARAMS} --sig-diff -1"
fi

rawhash2 -x r10 -t ${THREAD} ${PARAMS} \
-o "${OUTDIR}/rawhash2_${SEGMENTER}.paf" \
"${INDEX}" \
${SIGNALS}

python ../../test/scripts/pafstats.py -r "$GT" --annotate "${OUTDIR}/rawhash2_${SEGMENTER}.paf" > "${OUTDIR}/${SEGMENTER}_annotated.paf" 2> "${OUTDIR}/${SEGMENTER}_throughput.txt"

F1=$(awk '
/^T/ { TP=$2 }
/^F/ { FP=$2; FN=$3 }

END {
    p = (TP+FP>0)?TP/(TP+FP):0
    r = (TP+FN>0)?TP/(TP+FN):0
    f1 = (p+r>0)?2*p*r/(p+r):0
    printf "%.6f", f1
}
' "${OUTDIR}/${SEGMENTER}_throughput.txt")

echo "${SEGMENTER} F1 Score: ${F1}"

SEGMENTER="scrappieR10"
EVENTS="${DATA_DIR}/d0_ecoli_training_${SEGMENTER}_events.tsv"
PARAMS="--r10 -w 0 --events-file ${EVENTS}"

if [[ "$HPC" == "hpc_off" ]]; then
    PARAMS="${PARAMS} --sig-diff -1"
fi

rawhash2 -x r10 -t ${THREAD} ${PARAMS} \
-o "${OUTDIR}/rawhash2_${SEGMENTER}.paf" \
"${INDEX}" \
${SIGNALS}

python ../../test/scripts/pafstats.py -r "$GT" --annotate "${OUTDIR}/rawhash2_${SEGMENTER}.paf" > "${OUTDIR}/${SEGMENTER}_annotated.paf" 2> "${OUTDIR}/${SEGMENTER}_throughput.txt"

F1=$(awk '
/^T/ { TP=$2 }
/^F/ { FP=$2; FN=$3 }

END {
    p = (TP+FP>0)?TP/(TP+FP):0
    r = (TP+FN>0)?TP/(TP+FN):0
    f1 = (p+r>0)?2*p*r/(p+r):0
    printf "%.6f", f1
}
' "${OUTDIR}/${SEGMENTER}_throughput.txt")

echo "${SEGMENTER} F1 Score: ${F1}"

SEGMENTER="campolina"
EVENTS="${DATA_DIR}/d0_ecoli_training_${SEGMENTER}_events.tsv"
PARAMS="--r10 -w 0 --events-file ${EVENTS}"

rawhash2 -x r10 -t ${THREAD} ${PARAMS} \
-o "${OUTDIR}/rawhash2_${SEGMENTER}.paf" \
"${INDEX}" \
${SIGNALS}

python ../../test/scripts/pafstats.py -r "$GT" --annotate "${OUTDIR}/rawhash2_${SEGMENTER}.paf" > "${OUTDIR}/${SEGMENTER}_annotated.paf" 2> "${OUTDIR}/${SEGMENTER}_throughput.txt"

F1=$(awk '
/^T/ { TP=$2 }
/^F/ { FP=$2; FN=$3 }

END {
    p = (TP+FP>0)?TP/(TP+FP):0
    r = (TP+FN>0)?TP/(TP+FN):0
    f1 = (p+r>0)?2*p*r/(p+r):0
    printf "%.6f", f1
}
' "${OUTDIR}/${SEGMENTER}_throughput.txt")

echo "${SEGMENTER} F1 Score: ${F1}"