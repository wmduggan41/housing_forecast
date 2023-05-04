# Using the elbow method to find the optimal number of clusters
# NOTE: From global env "numeric_data" contains optimal column set for wcss
library(cluster)
library(factoextra)

# Copy numeric items to df
df <- numeric_data
# Make sure all na's are removed
df <- na.omit(df)
# Scale df and then check 
df <- scale(df)
head(df)
# Create plot for identifying ideal k
pfviz_nbclust(df, kmeans, method = "wss")
# ggsave("img/wcss.png" , dpi = 300) # save to img folder

set.seed(1)
km <- kmeans(df, centers = 5, nstart = 25)
km

# Add cluster assigment to original data
final_data <- cbind(df, cluster = km$cluster)

# View head of final data to reveal each cluster label
head(final_data)