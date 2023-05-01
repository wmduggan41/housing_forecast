plot_prediction <- function(processed_train_tbl) {
  
  selected_vars <- c("MoSold", "YrSold", "YearBuilt", "YearRemodAdd", "LotArea", "price_sqft", "SalePrice", "OverallCond", "OverallQual")
  
  # Compute correlation matrix
  corr_matrix <- cor(processed_train_tbl[, selected_vars], use = "complete.obs")
  
  # Plot correlation matrix
  corrplot(corr_matrix, type = "upper", method = "circle", tl.col = "black")
  
  # Plot SalePrice vs. MoSold with text labels
  g <- training_data %>%
    
    ggplot(aes(YearBuilt, price_sqft)) +
    
    geom_line(color = "#2c3e50") +
    geom_point(size = 0.05) +
    geom_smooth(method = "loess", span = 0.2) +
    
    theme_tq() +
    expand_limits(y = 0) +
    scale_y_continuous(labels = scales::dollar_format()) +
    labs(x = "Year Built", y = "USD Per SQFT")
  
  ggplotly(g, tooltip = "text")
  
}

# --- Above is working ---
# GLM model
# library(plotly)
# set.seed(123)
# 
# # Split data into 70/30 train and test sets
# train_ind <- seq_len(nrow(key_tbl)) %>% 
#   createDataPartition(p = 0.7, list = FALSE) 
# 
# train_glm <- key_tbl[train_ind, ]
# test_glm <- key_tbl[-train_ind, ]
# 
# 
# # Fit GLM to train
# model_glm <- glm(SalePrice ~ ., 
#                  data = train_glm[, -1], 
#                  family = gaussian(link = "identity"))
# 
# # Make predictions
# glm_preds <- predict(model_glm, 
#                      newdata = test_glm[, -1], 
#                      type = "response")
# 
# # Plot GLM
# glm_plot_tbl <- data.frame(actual = test_glm$SalePrice, 
#                            predicted = glm_preds)
# 
# ggplot(glm_plot_tbl, aes(x = actual, y = predicted)) +
#   
#   geom_point(alpha = 0.5) +
#   
#   geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "red") +
#   labs(title = "GLM Model Prediction",
#        x = "Actual Sale Price",
#        y = "Predicted Sale Price")


