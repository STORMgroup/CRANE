# CRANE Evaluation Data

Get started by downloading the CRANE evaluation datasets:

```bash
bash download_crane_data.sh
```


Then segment and correct the datasets using the preparation scripts below.

IMPORTANT:
 - Ensure that you have compiled CRANE and segmentation code in [src](../../../src)
 - Ensure you have setup your environment and downloaded dorado, minimap2, and campolina in [test](../../test)
 - Running these will require access to GPUs due to the the dorado basecalling, and campolina segmentation steps.

```bash
bash prepare_d1.sh [THREAD_COUNT]
bash prepare_d2.sh [THREAD_COUNT]
bash prepare_d3.sh [THREAD_COUNT]
```

If you wish to train your own HMM models using the provided configuration, you will need to prepare the training dataset as well:

```bash
bash prepare_training.sh
```
