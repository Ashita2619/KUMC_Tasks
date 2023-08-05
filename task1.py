#!/usr/bin/env python
# coding: utf-8

# In[1]:


import gzip
import csv
from collections import defaultdict
from Bio import Entrez

# Set your NCBI API key
Entrez.api_key = "YOUR_NCBI_API_KEY"

# Define input file paths
gene_info_file = "Homo_sapiens.gene_info.gz"
gmt_file = "h.all.v2023.1.Hs.symbols.gmt"
output_gmt_file = "output_entrez.gmt"

# Create a mapping of Symbol to GeneID from the gene_info file
symbol_to_geneid_map = defaultdict(list)

with gzip.open(gene_info_file, 'rt') as f:
    reader = csv.reader(f, delimiter='\t')
    for row in reader:
        if len(row) >= 5:
            gene_id = row[1]
            symbol = row[2]
            synonyms = row[4].split('|')

            symbol_to_geneid_map[symbol].append(gene_id)
            for synonym in synonyms:
                symbol_to_geneid_map[synonym].append(gene_id)

# Replace gene symbols in the GMT file with Entrez IDs and create the output GMT file
with open(gmt_file, 'r') as infile, open(output_gmt_file, 'w', newline='') as outfile:
    for line in infile:
        fields = line.strip().split('\t')
        pathway_name = fields[0]
        pathway_desc = fields[1]
        gene_symbols = fields[2:]

        entrez_ids = []
        for symbol in gene_symbols:
            entrez_ids.extend(symbol_to_geneid_map.get(symbol, []))

        if entrez_ids:
            writer = csv.writer(outfile, delimiter='\t')
            writer.writerow([pathway_name, pathway_desc] + entrez_ids)

print("Gene symbols replaced with Entrez IDs and saved to", output_gmt_file)

