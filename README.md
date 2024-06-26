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
`samplefile`|File|sample file path
`filterFastq.modules`|String|Names and versions of modules


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`generateConfig.jobMemory`|Int|8|memory allocated for Job
`generateConfig.timeout`|Int|24|Timeout in hours, needed to override imposed limits
`filterFastq.jobMemory`|Int|8|memory allocated for Job
`filterFastq.timeout`|Int|24|Timeout in hours, needed to override imposed limits


### Outputs

Output | Type | Description | Labels
---|---|---|---
`filteredFastq`|File|output from rule filter_fastq of the original workflow|vidarr_label: filteredFastq 


## Commands
This section lists command(s) run by nanoporefilterfastq workflow
 
* Running nanoporefilterfastq
 
### Configure
 
```
         set -euo pipefail
         cat <<EOT >> config.yaml
         workflow_dir: "/.mounts/labs/gsi/modulator/sw/Ubuntu18.04/nanopore-sv-analysis-20220505"
         conda_dir: "/.mounts/labs/gsi/modulator/sw/Ubuntu18.04/nanopore-sv-analysis-20220505/bin"
         reference_dir: "/.mounts/labs/gsi/modulator/sw/data/hg38-nanopore-sv-reference-20220505"
         samples: [~{sample}]
         normals: [~{normal}]
         tumors: [~{tumor}]
         ~{sample}: ~{samplefile}
         EOT
```
 
### Run nanopore-sv analysis as a snakemake process
 
```
         module load nanopore-sv-analysis
         unset LD_LIBRARY_PATH
         set -euo pipefail
         cp $NANOPORE_SV_ANALYSIS_ROOT/Snakefile .
         cp ~{config} .
         $NANOPORE_SV_ANALYSIS_ROOT/bin/snakemake  -j 8 --rerun-incomplete --keep-going --latency-wait 60  filter_fastq
```
## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
