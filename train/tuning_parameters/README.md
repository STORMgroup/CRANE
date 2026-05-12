# Parameter Search

This directory contains the code for doing an automatic parameter sweep over the CRANE parameters P(stay) and P(skip)


## Use

This is an example of how to search over parameters, where hmm_file is the .tsv file of a trained hmm, segmenter must be "scrappieR9", "scrappieR10", or "campolina", and HPC must either be "hpc_on" or 'hpc_off".

Before running this, ensure that you have installed the necessary tools in [../test/](../test/), and downloaded and prepared the training data in [../test/data](../test/data)

```bash
# bash parameter_search.sh <n_threads> <hmm_file> <segmenter> <HPC>
bash parameter_search.sh 32 ../models/hmm_16.tsv scrappieR9 hpc_off
```

## Generating Training Baselines

We also provide a script which automatically generates a baseline F1 score for the training datasets across all 3 segmenters, HPC must either be "hpc_on" or 'hpc_off":

```bash
# bash generate_training_baselines.sh <n_threads> <HPC>
bash generate_training_baselines.sh 32 hpc_off
```
