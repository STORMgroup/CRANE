# CRANE Overview
CRANE is an HMM-based tool to correct raw nanopore signal events. To do this, it 1) Trains an HMM on synthetic and experimental nanopore event data and 2) uses the Viterbi algorithm and the learned HMM to correct novel signals.

Detailed information on the CRANE tool can be found here: https://arxiv.org/abs/2603.20420

In its current implementation, CRANE takes in event sequences from a .tsv file, and outputs the corrected events to another .tsv.


# Installation

## Prequisites

 - C++ compiler
   - GCC 11+ (`g++` 11 or later)
 - GNU Make
 - Python 3.11.13+

## Quick Start

* Clone the code from its GitHub repository, and compile CRANE:

```bash
git clone --recursive https://github.com/STORMgroup/CRANE.git
cd CRANE
make
```

* Then add it to your $PATH or bin:

```bash
# Add to bin:
cp crane /path/to/bin/
# Or add to PATH:
export PATH=$PWD/src:$PATH
```

# Usage

Correct nanopore event sequences by providing the path to the trained HMM, the .tsv containing event sequences, and the parameters p_stay and p_skip.

```
crane ./path/to/hmm_file.tsv ./path/to/event_file.tsv <p_stay> <p_skip> > corrected_events.tsv
```

We provide code for creating events from pod5/fast5 raw signal files in (src/segmentation)[src/segmentation].

Optimal p_stay and p_skip parameters to run CRANE in combination with RawHash2 can be found in the results section of our paper: https://arxiv.org/abs/2603.20420

# Training HMMs

In [train](./train/), you can train Hidden Markov Models to model nanopore dynamics. The models created here can be used to correct nanopore signals.

# Hyperparameter Searches

In [train/tuning_parameters](./train/tuning_parameters),we provide scripts which run parameter searches to find the optimal p_stay and p_skip configurations for different segmentation algorithms and downstream applications that CRANE can be used in combination with.

# Reproducing the results

Follow the steps in [test/README.md](./test/).


