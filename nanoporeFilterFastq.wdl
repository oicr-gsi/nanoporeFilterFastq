version 1.0

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

    call generateConfig{
        input:
        sample=sample,
        normal = normal,
        tumor = tumor,
        samplefile = samplefile    
    }

    call filterFastq {
        input:
        config = generateConfig.config,
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
    filteredFastq : {
        description: "output from rule filter_fastq of the original workflow",
        vidarr_label: "filteredFastq "
    }
}
    }
}

    # ==========================================================
    #  generate the config.yaml file needed for running snakemake
    # ==========================================================
    task generateConfig {
        input {
        String sample
        String normal
        String tumor
        File samplefile      
        Int jobMemory = 8
        Int timeout = 24 
   }

        parameter_meta {
        sample: "name of all sample"
        normal: "name of the normal sample"
        tumor: "name of the tumor sample"
        samplefile: "sample file path"
        jobMemory: "memory allocated for Job"
        timeout: "Timeout in hours, needed to override imposed limits"
        }
 
        command <<<
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
        >>>  
    runtime {
    memory:  "~{jobMemory} GB"
    timeout: "~{timeout}"
    }
    output {
    File config = "config.yaml"
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
        timeout: "Timeout in hours, needed to override imposed limits"
        modules: "Names and versions of modules"
        }

        command <<<
        module load nanopore-sv-analysis
        unset LD_LIBRARY_PATH
        set -euo pipefail
        cp $NANOPORE_SV_ANALYSIS_ROOT/Snakefile .
        cp ~{config} .
        $NANOPORE_SV_ANALYSIS_ROOT/bin/snakemake  -j 8 --rerun-incomplete --keep-going --latency-wait 60  filter_fastq
        >>> 

    runtime {
    memory:  "~{jobMemory} GB"
    timeout: "~{timeout}"
    modules: "~{modules}"
    }

    output {
    File filteredFastq = "~{sample}/fastq/~{sample}.fastq.gz"
    }
    }

