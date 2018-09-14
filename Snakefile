###===
### Rules for fungal search 
###===

import configparser
import yaml

from functions import *

PROJECT_DIR = config["PROJECT_DIR"]
USEARCH_OUT_DIR = config["USEARCH_OUT_DIR"]
USEARCH_ID_CUT = config["USEARCH_ID_CUT"]
USEARCH_FUNGAL_DB_DIR = config["USEARCH_FUNGAL_DB_DIR"]
SAMPLE_IDS = get_sample(PROJECT_DIR + "/" + config["SAMPLE_FP"]) 

workdir: PROJECT_DIR

rule all:
   input: 
      expand(USEARCH_OUT_DIR + "/{sample}.ugout", sample = SAMPLE_IDS)

rule make_ug:
   input:
      config["JOINED_FASTA_DIR"] + "/joined.{sample}.fasta"
   output:
      USEARCH_OUT_DIR + "/{sample}.ugout"
   shell:
      """
      vsearch --usearch_global {input} --id {USEARCH_ID_CUT} --db {USEARCH_FUNGAL_DB_DIR} --blast6out {output} --top_hits_only
      """

onsuccess:
        print("Workflow finished, no error")
        shell("mail -s 'Workflow finished successfully' " + config["ADMIN_EMAIL"] + " < {log}")

onerror:
        print("An error occurred")
        shell("mail -s 'An error occurred' " + config["ADMIN_EMAIL"] + " < {log}")
                                  
