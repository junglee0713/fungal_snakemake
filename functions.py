def get_sample(sample_fp):
   with open(sample_fp) as f:
      lines = f.read().splitlines()
   samples = []
   for line in lines:
      samples.append(line)
   return(samples)


