library(ggplot2)
library(ggfortify)
library(dplyr)
library(tidyr)

# Convert kmeans object to data.frame
kmeans_df <- as.data.frame(kmeans_model$centers)
rownames(kmeans_df) <- paste0("Cluster ", 1:nrow(kmeans_df))

# Combine the PCs with the cluster information
new_kmeans_df <- data.frame(SalePrice  = training_data$SalePrice, 
                            price_sqft = training_data$price_sqft, 
                            .cluster   = kmeans_model$cluster)

new_kmeans_df <- new_kmeans_df %>% 
  mutate(.cluster = factor(.cluster, levels = 1:length(kmeans_model$centers)))

# Fortify the data for use in ggplot2
processed_kmeans_df <- fortify(new_kmeans_df)

# Plot the data
p2 <- ggplot(processed_kmeans_df, aes(x = SalePrice, y = price_sqft, color = .cluster)) + 
      geom_point() + 
      labs(title = "K-means Clustering (k=5)", 
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

ggsave("img/kmeans_chosen.png", dpi = 300)
