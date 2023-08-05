# Load required libraries
library(data.table)
library(readr)
library(ggplot2)
library(dplyr)

# Load and read the data
file_path <- "Homo_sapiens.gene_info.gz"
gene_data <- read_delim(file = gzfile(file_path), delim = "\t")

# Convert chromosome names to uppercase
gene_data$chromosome <- toupper(gene_data$chromosome)

# Filter out rows with ambiguous chromosome values
gene_data <- gene_data %>%
  filter(!grepl("\\|", chromosome) & !grepl("-", chromosome) & !grepl("NA", chromosome))

# Group the data by chromosome and count the number of genes
gene_count <- gene_data %>%
  group_by(chromosome) %>%
  summarize(count = n())

# Define the order of the chromosomes
chrom_order <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "X", "Y", "MT", "UN")

# Reorder the chromosomes in the gene_count data frame
gene_count$chromosome <- factor(gene_count$chromosome, levels = chrom_order)

# Create the bar plot
plot<- ggplot(gene_count, aes(x = chromosome, y = count)) +
  geom_bar(stat = "identity", fill = "black") +
  labs(title = "Number of Genes in each Chromosome",
       x = "Chromosome", y = "Number of Genes") +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),   # Remove grid lines
    axis.ticks = element_line(),    # Add axis ticks
    axis.line = element_line() ,     # Add axis lines
    plot.title = element_text(hjust = 0.5)  # Center the title
  )

# Save the plot to a PDF file
ggsave("gene_count_per_chromosome.pdf",plot, width = 10, height = 6)