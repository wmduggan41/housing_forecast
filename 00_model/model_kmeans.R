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
    p <- plot_ly(
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

