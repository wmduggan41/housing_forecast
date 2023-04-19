# Hierarchical Clustering

# 1.0 Importing the dataset ------
dataset <- read.csv("00_data/train.csv")
head(dataset)
str(dataset)
# Some variables I like are SalesPrice(int), YearBuilt(int), YearRemodAdd(int), 
# OverallQuality(int), OverallCondition(int), Neighborhood(chr), ID(int), 
# LotArea(int)
df <- dataset[, c("Id", "LotArea", "Neighborhood", "BldgType", "OverallQual", 
                  "OverallCond", "YearBuilt", "YearRemodAdd", "MoSold", 
                  "YrSold", "SalePrice")]

# 2.0 Splitting the dataset into the Training set and Test set ------
# install.packages('caTools')
# library(caTools)
# set.seed(123)
# split = sample.split(dataset$DependentVariable, SplitRatio = 0.8)
# training_set = subset(dataset, split == TRUE)
# test_set = subset(dataset, split == FALSE)

# 3.0 Feature Scaling ------
# training_set = scale(training_set)
# test_set = scale(test_set)

# 4.0 Dendrogram to find the optimal number of clusters ------
dendrogram = hclust(d = dist(dataset, method = 'euclidean'), method = 'ward.D')
plot(dendrogram,
     main = paste('Dendrogram'),
     xlab = 'Customers',
     ylab = 'Euclidean distances')

# 5.0 Fitting Hierarchical Clustering to the dataset -------
hc = hclust(d = dist(dataset, method = 'euclidean'), method = 'ward.D')
y_hc = cutree(hc, 5)

# 6.0 Visualising the clusters ------
library(cluster)
clusplot(dataset,
         y_hc,
         lines = 0,
         shade = TRUE,
         color = TRUE,
         labels= 2,
         plotchar = FALSE,
         span = TRUE,
         main = paste('Clusters of customers'),
         xlab = 'Annual Income',
         ylab = 'Spending Score')