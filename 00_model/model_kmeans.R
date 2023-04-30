# Define server logic for k-means clustering
server_kmeans <- function(input, output) {
  # Create reactive data for k-means clustering
  kmeans_data <- reactive({
    k <- input$kmeans_k
    # Fitting K-Means to dataset
    set.seed(123)
    kmeans_obj <- kmeans(X, k, iter.max = 300, nstart = 10)
    # Add cluster assignments to original data frame
    kdata$cluster <- as.factor(kmeans_obj$cluster)
    kdata
  })
  
  # Render k-means plot
  output$kmeans_plot <- renderPlotly({
    p <- ggplotly(
      data = kmeans_data(),
      x = ~OverallQual,
      y = ~SalePrice,
      color = ~cluster,
      colors = "Set1",
      type = "scatter",
      mode = "markers",
      marker = list(size = 10)
    ) %>%
      layout(
        title = "Clusters of House Quality",
        xaxis = list(title = "Quality Condition"),
        yaxis = list(title = "Quality Score")
      )
    p
  })
}

# library(tidyverse)
# library(corrplot)
# library(ggplot2)
# library(reshape2)
# library(caret)

# Selecting target variables
ktrain <- processed_key_tbl
ktrain$Id <- NULL

numeric_data <- ktrain %>%
  select_if(is.numeric)

set.seed(123) # Set the seed for reproducibility
trainIndex <- createDataPartition(ktrain$SalePrice, 
                                  p = 0.7, 
                                  list = FALSE, 
                                  times = 1)

training_data <- ktrain[trainIndex, ]
testing_data <- ktrain[-trainIndex, ]


# Fit k-means model on the training data
library(cluster)
kmeans_model <- kmeans(training_data[, c("SalePrice", "price_sqft")], 
                       centers = 5, 
                       iter.max = 300, 
                       nstart = 10)

# Visualize the clusters
library(plotly)
plot_ly(x = training_data$SalePrice, 
        y = training_data$price_sqft, 
        color = kmeans_model$cluster, 
        colors = "Set1", mode = "markers", 
        marker = list(size = 8)) %>%

  layout(xaxis = list(title = "Sale Price"), 
         yaxis = list(title = "per sqft"), 
         title = "K-Means Clustering of House Quality")

