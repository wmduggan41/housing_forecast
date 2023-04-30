library(ggplot2)
library(plotly)
library(tidyverse)
library(tibble)
library(tidyr)
library(corrplot)



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
generate_forecast <-
  function(data, n_future = 12, seed = NULL) {
    
    train_tbl <- data %>% 
      tk_augment_timeseries_signature()
    
    future_data_tbl <- data %>%
      tk_index() %>%
      tk_make_future_timeseries(length_out = n_future, inspect_weekdays = TRUE, inspect_months = TRUE) %>%
      tk_get_timeseries_signature()
    
    time_scale <- data %>%
      tk_index() %>%
      tk_get_timeseries_summary() %>%
      pull(scale)
    
    if (time_scale == "year") {
      
      model <- linear_reg(mode = "regression") %>%
        set_engine(engine = "lm") %>%
        fit.model_spec(total_sales ~ ., data = train_tbl %>% select(total_sales, index.num))
      
    } else {
      
      seed <- seed
      set.seed(seed)
      model <- boost_tree(
        mode = "regression", 
        mtry = 20, 
        trees = 500, 
        min_n = 3, 
        tree_depth = 8,
        learn_rate = 0.01, 
        loss_reduction = 0.01) %>%
        set_engine(engine = "xgboost") %>%
        fit.model_spec(total_sales ~ ., data = train_tbl %>% select(-date, -label_text, -diff))
      
    }
    
    
    prediction_tbl <- predict(model, new_data = future_data_tbl) %>%
      bind_cols(future_data_tbl) %>%
      select(.pred, index) %>%
      rename(total_sales = .pred, 
             date        = index) %>%
      mutate(label_text = str_glue("Date: {date}
                                 Revenue: {scales::dollar(total_sales)}")) %>%
      add_column(key = "Prediction")
    
    output_tbl <- data %>%
      add_column(key = "Actual") %>%
      bind_rows(prediction_tbl) 
    
    return(output_tbl)
    
  }

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


aggregate_prediction <-
  function(output_tbl, time_unit = "year") {
    
    output_tbl <- glm_plot_tbl %>%
      mutate(label_text = str_glue("Predicted: {scales::dollar(predicted)}
                                    Actual: {scales::dollar(actual)}"))
    
    return(output_tbl)
    
  }
plot_prediction <-
  function(key_data) {
    
    g <- key_data %>%
      
      ggplot(aes(MoSold, SalePrice)) +
      
      geom_line(color = "#2c3e50") +
      geom_point(aes(text = label_text), color = "#2c3e50", size = 0.1) +
      geom_smooth(method = "loess", span = 0.2) +
      
      theme_tq() +
      expand_limits(y = 0) +
      scale_y_continuous(labels = scales::dollar_format()) +
      labs(x = "", y = "")
    
    
    ggplotly(g, tooltip = "text")
    
  }
generate_forecast <-
  function(data, n_future = 12, seed = NULL) {
    
    train_tbl <- data %>% 
      tk_augment_timeseries_signature()
    
    future_data_tbl <- data %>%
      tk_index() %>%
      tk_make_future_timeseries(length_out = n_future, inspect_weekdays = TRUE, inspect_months = TRUE) %>%
      tk_get_timeseries_signature()
    
    time_scale <- data %>%
      tk_index() %>%
      tk_get_timeseries_summary() %>%
      pull(scale)
    
    if (time_scale == "year") {
      
      model <- linear_reg(mode = "regression") %>%
        set_engine(engine = "lm") %>%
        fit.model_spec(total_sales ~ ., data = train_tbl %>% select(total_sales, index.num))
      
    } else {
      
      seed <- seed
      set.seed(seed)
      model <- boost_tree(
        mode = "regression", 
        mtry = 20, 
        trees = 500, 
        min_n = 3, 
        tree_depth = 8,
        learn_rate = 0.01, 
        loss_reduction = 0.01) %>%
        set_engine(engine = "xgboost") %>%
        fit.model_spec(total_sales ~ ., data = train_tbl %>% select(-date, -label_text, -diff))
      
    }
    
    
    prediction_tbl <- predict(model, new_data = future_data_tbl) %>%
      bind_cols(future_data_tbl) %>%
      select(.pred, index) %>%
      rename(total_sales = .pred, 
             date        = index) %>%
      mutate(label_text = str_glue("Date: {date}
                                 Revenue: {scales::dollar(total_sales)}")) %>%
      add_column(key = "Prediction")
    
    output_tbl <- data %>%
      add_column(key = "Actual") %>%
      bind_rows(prediction_tbl) 
    
    return(output_tbl)
    
  }
plot_forecast <-
  function(data) {
    
    # Yearly - LM Smoother
    time_scale <- data %>%
      tk_index() %>%
      tk_get_timeseries_summary() %>%
      pull(scale)
    
    # Only 1 prediction - adjust points
    n_predictions <- data %>%
      filter(key == "Prediction") %>%
      nrow()
    
    g <- data %>%
      ggplot(aes(date, total_sales, color = key)) +
      
      geom_line() +
      # geom_point(aes(text = label_text), size = 0.01) +
      # geom_smooth(method = "loess", span = 0.2) +
      
      theme_tq() +
      scale_color_tq() +
      scale_y_continuous(labels = scales::dollar_format()) +
      expand_limits(y = 0) +
      labs(x = "", y = "")
    
    # Yearly - LM Smoother
    if (time_scale == "year") {
      g <- g +
        geom_smooth(method = "lm")
    } else {
      g <- g + geom_smooth(method = "loess", span = 0.2)
    }
    
    # Only 1 prediction
    if (n_predictions == 1) {
      g <- g + geom_point(aes(text = label_text), size = 1)
    } else {
      g <- g + geom_point(aes(text = label_text), size = 0.01)
    }
    
    ggplotly(g, tooltip = "text")
  }
