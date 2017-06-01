#!/usr/bin/env python3

from Bio import Entrez
from Bio import SeqIO
import argparse

# require email from cli
parser = argparse.ArgumentParser()
parser.add_argument('-e',
                    help='email address',
                    metavar='email',
                    type=str,
                    required=True)
args = parser.parse_args()

# identify myself to Entrez
Entrez.email = args.e

# io files
accession = 'NC_001416.1'
output_fasta = 'data/NC_001416.fasta'
output_gb = 'data/NC_001416.gb'

# genbank search
handle = Entrez.efetch(
    db='nuccore',
    id=accession,
    idtype='acc',
    rettype='gb',
    retmode='text')
gb_record = [x for x in SeqIO.parse(handle, 'gb')]

# write results
SeqIO.write(gb_record, output_gb, 'gb')
SeqIO.write(gb_record, output_fasta, 'fasta')
