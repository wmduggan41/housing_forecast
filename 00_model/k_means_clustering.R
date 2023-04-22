# K-Means Clustering
# Importing the dataset
kdata = read.csv("00_data/wmd_house.csv")
# Selecting target variables
cluster_cols <- c("OverallQual", "OverallCond")
X <- kdata[, cluster_cols]

# Using the elbow method to find the optimal number of clusters
set.seed(6)
wcss = vector()
for (i in 1:10) wcss[i] = sum(kmeans(X, i)$withinss)
plot(x = 1:10,
     y = wcss,
     type = 'b',
     main = paste('The Elbow Method'),
     xlab = 'Number of clusters',
     ylab = 'WCSS')

# Fitting K-Means to dataset
set.seed(123)
kmeans = kmeans(X, 5, iter.max = 300, nstart = 10)

# Visualizing the clusters
library(cluster)
clusplot(x = X,
         clus = kmeans$cluster,
         lines = 0,
         shade = TRUE,
         color = TRUE,
         labels = 2,
         plotchar = TRUE,
         span = TRUE,
         main = paste('Clusters of House Quality'),
         xlab = 'Quality Condition',
         ylab = 'Quality Score')
