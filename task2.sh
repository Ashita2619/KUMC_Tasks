#!/bin/bash
#Download the data
wget  https://ftp.ncbi.nlm.nih.gov/genomes/archive/old_refseq/Bacteria/Escherichia_coli_K_12_substr__MG1655_uid57779/NC_000913.faa

# Calculate the total number of amino acids (excluding headers)
total_aa=$(grep -v '^>' NC_000913.faa | tr -d '\n' | wc -m)

# Count the number of sequences (headers) in the file
num_sequences=$(grep -c '^>' NC_000913.faa)

# Calculate the average length of proteins
average_length=$(awk "BEGIN {printf \"%d\",$total_aa / $num_sequences}")

# Print the average length of proteins
echo "Average length of proteins: $average_length"
