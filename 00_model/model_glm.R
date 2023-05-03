generate_forecast_glmnet <- function(data = processed_data_tbl, length_out = 12, seed = NULL, 
                                     penalty = 1, mixture = 0.5) {
  
  train_tbl <- data %>% 
    tk_augment_timeseries_signature()
  
  future_data_tbl <- data %>%
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
      fit.model_spec(price_sqft ~ ., data = train_tbl %>% select(price_sqft, index.num))
    
  } else {
    model <- linear_reg(mode = "regression", penalty = penalty, mixture = mixture) %>%
      set_engine("glmnet") %>%
      fit.model_spec(price_sqft ~ ., data = train_tbl %>% select(-date, -label_text, -diff))
  }
  
  
  prediction_tbl <- predict(model, new_data = future_data_tbl) %>%
    bind_cols(future_data_tbl) %>%
    select(.pred, index) %>%
    rename(price_sqft  = .pred, 
           date        = index) %>%
    mutate(label_text  = str_glue("Date: {date}
                                  USD per sqft: {scales::dollar(price_sqft)}")) %>%
    add_column(key = "Prediction")
  
  output_tbl <- data %>%
    add_column(key = "Actual") %>%
    bind_rows(prediction_tbl) 
  
  return(output_tbl)
}


plot_prediction <- function(processed_train_tbl) {
  
  selected_vars <- c("price_sqft", "SalePrice")
  
  # Compute correlation matrix
  corr_matrix <- cor(processed_train_tbl[, selected_vars], use = "complete.obs")
  
  # Plot correlation matrix
  corrplot(corr_matrix, type = "upper", method = "circle", tl.col = "black")
  
  # Plot SalePrice vs. MoSold with text labels
  g <- train_tbl %>%
    
    ggplot(aes(date, price_sqft)) +
    
    geom_line(color = "#2c3e50") +
    geom_point(size = 0.05) +
    geom_smooth(method = "loess", span = 0.2) +
    
    theme_tq() +
    expand_limits(y = 0) +
    scale_y_continuous(labels = scales::dollar_format()) +
    labs(x = "Date", y = "USD Per SQFT")
  
  ggplotly(g, tooltip = "text")
  
}

