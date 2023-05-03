library(ggplot2)
library(dplyr)
library(cluster)
library(RSQLite)
library(odbc)
library(tidyverse)
library(tidyquant)
library(tidyr)
library(tibble)

# con <- dbConnect(RSQLite::SQLite(), "house_data.db")
# con <- dbConnect(RSQLite::SQLite(), "00_data/house_data.db")

key_tbl <- key_data %>%
  mutate(price_sqft = ifelse(is.na(SalePrice) | is.na(LotArea), 0, SalePrice / LotArea)) %>%
  select(SalePrice, price_sqft)

scaled_data <- scale(key_tbl)

set.seed(123) # Set seed for reproducibility
kmeans_model <- kmeans(scaled_data, centers=5)

key_tbl$cluster <- factor(kmeans_model$cluster)

# Plot the data
p2 <- ggplot(key_tbl, aes(x = SalePrice, y = price_sqft, color = cluster)) + 
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

p2

ggsave("img/kmeans_chosen.png", dpi = 300)
