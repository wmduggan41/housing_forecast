render_kmeans <- function(input_k_value, key_tbl, scaled_data) {
  
  # Perform k-means clustering with selected k value
  kmeans_model <- kmeans(scaled_data, centers=input_k_value)
  
  # Add cluster assignments to the data
  key_tbl$cluster <- factor(kmeans_model$cluster)
  
  # Create ggplot object
  p <- ggplot(key_tbl, aes(x = SalePrice, y = price_sqft, color = cluster)) + 
    geom_point() + 
    labs(title = paste("K-means Clustering (k =", input_k_value, ")"), 
         x = "Sale Price", 
         y = "Price per sqft", 
         color = "Cluster") + 
    theme_minimal() +
    annotate("text", x = c(50000, 200000, 500000, 700000), y = c(5, 15, 25, 35), label = c("Highlight 1", "Highlight 2", "Highlight 3", "Highlight 4"), color = "black") +
    geom_rect(aes(xmin = 0, xmax = 200000, ymin = 0, ymax = 20), fill = NA, color = "red", linetype = "dashed") +
    geom_rect(aes(xmin = 200000, xmax = 500000, ymin = 0, ymax = 30), fill = NA, color = "green", linetype = "dashed") +
    geom_rect(aes(xmin = 500000, xmax = Inf, ymin = 0, ymax = 40), fill = NA, color = "blue", linetype = "dashed") +
    scale_x_continuous(labels = scales::dollar_format(prefix = "$", scale = 1)) +
    scale_y_continuous(labels = scales::dollar_format(prefix = "$", scale = 1))
  
  # Convert ggplot object to plotly object for interactivity
  ggplotly(p)
}

