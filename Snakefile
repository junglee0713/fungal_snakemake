###===
### 
###

import configparser
import yaml

from functions import *

PROJECT_DIR = config["PROJECT_DIR"]

SAMPLE_IDS = get_sample(PROJECT_DIR + "/" + config["SAMPLE_FP"]) 

rule all:
   input: 
      expand(PROJECT_DIR + "/fungal_search_results/{sample}.ugout", sample = SAMPLE_IDS)

rule make_ug:
   input:
      config["JOINED_FASTA_DIR"] + "/joined.{sample}.fasta"
   output:
      PROJECT_DIR + "/fungal_search_results/{sample}.ugout"
   shell:
      """
      cp {input[0]} {output[0]}
      """

onsuccess:
        print("Workflow finished, no error")
        shell("mail -s 'Workflow finished successfully' " + config["ADMIN_EMAIL"] + " < {log}")

onerror:
        print("An error occurred")
        shell("mail -s 'An error occurred' " + config["ADMIN_EMAIL"] + " < {log}")
                                  
