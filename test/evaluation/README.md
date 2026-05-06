# Error Correction Read Mapping Evaluation

In order to evaluate CRANE, follow these steps:

1. Compile the segmenter and CRANE executable in [../../src/](../../src/)

2. Install the necessary tools by following the steps in [evaluation](../)
   
3. Download then segment and correct the datasets in [../data/cern_datasets/](../data/cern_datasets/)

4. Run RawHash2 with and without the corrected events, using the script map_all.sh in a dataset's evaluation directory
```bash
cd d1_ecoli_hpc_off # Navigate to the wanted directory
bash ./map_all.sh [THREAD_COUNT]
```

5. View the results:
```bash
cat summary.txt
```

## Summarizing results

The script tabulate_results.sh will gather all existing results stored in summary.txt files:

```bash
bash tabulate_results.sh
```

## Runtime and memory usage notes

If resources are limited, we recommend testing on the d1 dataset. Mapping d2 can take upwards of 50GB of RAM, and d3 can take above 500GB. 

For each dataset, there are 3 possible segmenters (scrappieR9, scrappieR10, campolina), each of which can be corrected or not, resulting in 6 configurations.

Using 32 threads and "hpc_off", it takes about 1 minute to map all 6 configurations of d1, between 2 and 3 hours to map all 6 configurations of d2, and between 8 and 10 hours to map all 6 configurations of d3.

Runtimes and memory usage can be decreased by mapping with hpc_on, and runtimes can be further reduced by running the 6 configurations in parallel, resources permitting.