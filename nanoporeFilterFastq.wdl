version 1.0
import "imports/pull_smkConfig.wdl" as smkConfig

workflow nanoporeFilterFastq {
    input {
        String sample
        String normal
        String tumor
        File samplefile
    }
    parameter_meta {
        sample: "name of sample"
        normal: "name of the normal sample"
        tumor: "name of the tumor sample"
        samplefile: "sample file path"
    }

    call smkConfig.smkConfig{
        input:
        sample=sample,
        normal = normal,
        tumor = tumor,
        samplefile = samplefile    
    }

    call filterFastq {
        input:
        config = smkConfig.config,
        sample = sample
    }

    output {
        File filteredFastq  = filterFastq.filteredFastq
        }

    meta {
     author: "Gavin Peng"
     email: "gpeng@oicr.on.ca"
     description: "nanoporFilterFastq, workflow that generates filtered fast.qz file from input of nanopore fastq files, a wrapper of the workflow https://github.com/mike-molnar/nanopore-SV-analysis"
     dependencies: [
      {
        name: "nanopore_sv_analysis/20220505",
        url: "https://gitlab.oicr.on.ca/ResearchIT/modulator/-/blob/master/code/gsi/70_nanopore_sv_analysis.yaml"
      }
     ]
     output_meta: {
       filteredFastq : "output from rule filter_fastq of the original workflow"
     }
    }
}

    # ==========================================================
    # run the nanopore workflow to generate filtered fastq files
    # ==========================================================
    task filterFastq {
        input {
        String sample
        File config     
        String modules
        Int jobMemory = 8
        Int timeout = 24
        }

        parameter_meta {
        jobMemory: "memory allocated for Job"
        modules: "Names and versions of modules"
        timeout: "Timeout in hours, needed to override imposed limits"
        }

        command <<<
        set -euo pipefail
        unset LD_LIBRARY_PATH
        cp $NANOPORE_SV_ANALYSIS_ROOT/Snakefile .
        cp ~{config} .
        $NANOPORE_SV_ANALYSIS_ROOT/bin/snakemake  -j 8 --rerun-incomplete --keep-going --latency-wait 60  filter_fastq
        >>> 

    runtime {
    memory:  "~{jobMemory} GB"
    modules: "~{modules}"
    timeout: "~{timeout}"
    }

    output {
    File filteredFastq = "~{sample}/fastq/~{sample}.fastq.gz"
    }
    }

