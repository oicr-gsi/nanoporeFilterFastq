# nanoporeFilterFastq

nanoporFilterFastq, workflow that generates filtered fast.qz file from input of nanopore fastq files, a wrapper of the workflow https://github.com/mike-molnar/nanopore-SV-analysis

## Overview

## Dependencies

* [nanopore_sv_analysis 20220505](https://gitlab.oicr.on.ca/ResearchIT/modulator/-/blob/master/code/gsi/70_nanopore_sv_analysis.yaml)


## Usage

### Cromwell
```
java -jar cromwell.jar run nanoporeFilterFastq.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`sample`|String|name of sample
`normal`|String|name of the normal sample
`tumor`|String|name of the tumor sample
`samplefile`|String|sample file
`smkConfig.generateConfig_modules`|String|modules needed to run generateConfig
`filterFastq.modules`|String|Names and versions of modules


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`smkConfig.generateConfig.jobMemory`|Int|8|memory allocated for Job
`smkConfig.generateConfig.timeout`|Int|24|Timeout in hours, needed to override imposed limits
`filterFastq.jobMemory`|Int|8|memory allocated for Job
`filterFastq.timeout`|Int|24|Timeout in hours, needed to override imposed limits


### Outputs

Output | Type | Description
---|---|---
`filteredFastq`|File|output from rule filter_fastq of the original workflow

