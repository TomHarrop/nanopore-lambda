import gzip
import tempfile
import shutil
import os
from Bio import SeqIO

fq_file = 'output/read_stats/mapped_reads.fastq.gz'
sorted_fq = 'output/read_stats/mapped_reads_sorted.fastq'

# unzip the fastq
temp_file = tempfile.mkstemp(suffix='.fastq')[1]
with gzip.open(fq_file, 'rb') as f_in:
    with open(temp_file, 'wb') as f_out:
        shutil.copyfileobj(f_in, f_out)

# make a sorted list of tuples of scaffold name and sequence length
length_id_unsorted = ((len(rec), rec.id) for
                      rec in SeqIO.parse(temp_file, 'fastq'))
length_and_id = sorted(length_id_unsorted)

# get a shortest-to-longest iterator of scaffolds
reads_by_length = reversed([
    id for (length, id) in length_and_id])

# release scaffolds_file from memory
del(length_and_id)

# build an index of the fasta file
read_index = SeqIO.index(temp_file, 'fastq')

# write selected records in correct order to disk
selected_reads = (read_index[id] for id in reads_by_length)
SeqIO.write(sequences=selected_reads,
            handle=sorted_fq,
            format='fastq')

os.remove(temp_file)
