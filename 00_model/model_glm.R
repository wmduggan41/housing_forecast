generate_forecast_glmnet <- function(data, length_out = 365, seed = NULL, 
                                     penalty = 1, mixture = 0.5) {
  
  strain_tbl <- data %>% 
    tk_augment_timeseries_signature()
  
  sfuture_data_tbl <- data %>%
    tk_index() %>%
    tk_make_future_timeseries(length_out = length_out) %>%
    tk_get_timeseries_signature() 
  
  time_scale <- data %>%
    tk_index() %>%
    tk_get_timeseries_summary() %>%
    pull(scale)
  
  if (time_scale == "year") {
    
    model <- linear_reg(mode = "regression") %>%
      set_engine(engine = "lm") %>%
      fit.model_spec(total_sqft ~ ., data = strain_tbl %>% select(total_sqft, index.num))
    
  } else {
    model <- linear_reg(mode = "regression", penalty = penalty, mixture = mixture) %>%
      set_engine("glmnet") %>%
      fit.model_spec(total_sqft ~ ., data = strain_tbl %>% select(-date, -label_text, -diff))
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

