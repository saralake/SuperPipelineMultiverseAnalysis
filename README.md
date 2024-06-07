# SuperPipelineMultiverseAnalysis
A modular pipeline for connectivity and network analysis of resting state EEG data

## Pipeline structure
The pipeline is structured in 5 main modules:

1. Preprocessing
2. Head Model
3. Source Estimation
4. Connectivity Analysis
5. Network Analysis

Each module is composed of different steps (developed as matlab functions), each of them is highly customizable.
The goal is to have a pipeline with default steps to run coherent analysis over different sets of data. However, this tool wants just to provide a support for the analysis, therefore it will be automatized as much as possible, but keeping a human supervision on the critical point of the analysis.

## Dependencies
The pipeline is developed with `Matlab 2022b`.

Moreover it is built over different open source packages:

| Package   | Version   | Use |
| ---       | ---       | --- |
| [EEGLAB](https://github.com/sccn/eeglab) | 2024.0 | Import data, Preprocessing |

## Code structure
The code is structured in a modular way, where each function can be used as it is, or combined with other functions to build up a complete pipeline.

The file `SuperPipeline.m` is just a template to build a pipeline.

The `functions` directory stores one subdirectory for each of the included modules. Each of the module-subdirectory contains all the functions that implement the developed steps.

All the functions have the prefix `SPMA_` in order to avoid conflicts with other Matlab packages.

### Functions - Misc
Here there are all the general functions not related to any specific module.

### Functions - 1_preprocessing
Here there are all the functions related to the preprocessing module.

### Functions - 2_head_model
Here there are all the functions related to the head modelling.

### Functions - 3_source_estimation
Here there are all the functions related to the source estimation.

### Functions - 4_connectivity
Here there are all the functions related to the connectivity analysis.

### Functions - 5_network
Here there are all the functions related to the network analysis.