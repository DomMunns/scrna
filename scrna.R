# PCA

# load packages
library(tidyverse)
library(GGally)

# read in data
file <- "data_raw/scrna_data.csv"
rna <- read_csv(file)

# Do PCA
pca <- rna %>% 
  prcomp(scale. = TRUE)

# Consider the variance in the firs ten PC
summary(pca)[["importance"]][,1:10]

# the variation in the first 10 components combined is still small (6.49%), there is 20.71% in the first 100

# plot PC1 against PC2
# put PC scores in data frame
dat1 <- data.frame(pca$x)

# plot PC1 against PC2
ggplot(dat, aes(x = PC1, y = PC2)) +
  geom_point()

# the first two components don't capture much of the variation in the cells, it's worth looking at some other pairwise comparisons.

# pipe the first 10 PCs into ggpairs
dat %>%
  select(PC1:PC10) %>%
  ggpairs()

################################

# t-SNE on scRNASeq data
# load Rtsne
library(Rtsne)

# perfrom t-SNE using Rtsne
tsne <- rna %>% 
  Rtsne(perplexity = 40,
        check_duplicates = FALSE)
# perplexity is one of the arguments than can be altered - it is a smoothing of the number of neighbours

# put the t-SNE scores into a data frame
dat2 <- data.frame(tsne$Y)

# plot the first t-SNE dimension against the second
dat2 %>% ggplot(aes(x = X1, y = X2)) +
  geom_point(size=0.5)

# A cluster analysis (a different unsupervised method) has been performed on these data and the cell types identified and verified by mapping the expression of markers on the clusters.

# import metadata
file <- "data_raw/scrna_meta.csv"
meta <- read_csv(file)

# add the cell type to the t-SNE scores dataframe
dat3 <- data.frame(dat2, type = meta$louvain)

# replot the t-SNE scores coloured by cell type
dat3 %>% ggplot(aes(x = X1, y = X2, colour = type)) +
  geom_point(size = 0.5)








