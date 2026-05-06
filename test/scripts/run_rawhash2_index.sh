#!/bin/bash
set -e

THREAD=$1
PREFIX=$2
PRESET=$3
HPC=$4

EXEC="rawhash2"

OUTDIR="index"
PARAMS="-w 0"

if [[ "$HPC" == "hpc_off" ]]; then
    PARAMS="${PARAMS} --sig-diff -1"
fi

mkdir -p "$OUTDIR"

REF="../../data/crane_datasets/CRANE_data/${PREFIX}_small/${PREFIX}_ref.fa"

PORE="../../../extern/kmer_models/uncalled_r1041_model_only_means.txt"

echo "Building RawHash2 index"
echo "Dataset: $PREFIX"
echo "HPC: $HPC"

/usr/bin/time -vpo "${OUTDIR}/${PREFIX}_${HPC}_rawhash2_index_${PRESET}.time" \
rawhash2 -x ${PRESET} -t ${THREAD} -p "${PORE}" ${PARAMS} \
-d "${OUTDIR}/${PREFIX}_${HPC}_rawhash2_index_${PRESET}.ind" \
${REF}
