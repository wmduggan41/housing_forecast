aggregate_time_sqft <-
function(data, time_unit = "month") {
  
  sqft_output_tbl <- data %>%
    
    mutate(date = floor_date(date, unit = time_unit)) %>%
    
    group_by(date) %>%
    summarize(total_sqft = sum(price_sqft)) %>%
    ungroup() %>%
    
    mutate(label_text = str_glue("Date: {date}
                                 Sale Price: {scales::dollar(total_sqft)}"))
  
  return(sqft_output_tbl)
  
}
sqft_plot_time_series <-
function(data) {
  
  g <- data %>%
    
    ggplot(aes(date, total_sqft)) +
    
    geom_line(color = "#2c3e50") +
    geom_point(aes(label = label_text), color = "#2c3e50", size = 0.1) +
    geom_smooth(method = "loess", span = 0.2) +
    
    theme_tq() +
    expand_limits(y = 0) +
    scale_y_continuous(labels = scales::dollar_format()) +
    labs(x = "", y = "")
  
  ggplotly(g, tooltip = "label")
  
}
generate_forecast <-
function(data, length_out = 12, seed = NULL) {

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
      fit.model_spec(total_sqft ~ ., data = strain_tbl %>% select(-date, -label_text, -diff))
    
    
    sprediction_tbl <- predict(model, new_data = sfuture_data_tbl) %>%
      bind_cols(sfuture_data_tbl) %>%
      select(.pred, index) %>%
      rename(total_sqft = .pred,
             date       = index) %>%
      mutate(label_text = str_glue("Date: {date}
                                USD price per sqft: {scales::dollar(total_sqft)}")) %>%
      add_column(key = "Prediction")
    
    output_tbl <- data %>%
      add_column(key = "Actual") %>%
      bind_rows(sprediction_tbl)
    
    return(output_tbl)
    
  } 

}
plot_forecast <-
function(data) {

  # Yearly - LM Smoother
  time_scale <- data %>%
    tk_index() %>%
    tk_get_timeseries_summary() %>%
    pull(scale)

  # Only 1 Prediction - points
  n_predictions <- data %>%
    filter(key == "Prediction") %>%
    nrow()

  g <- data %>%
    ggplot(aes(date, total_sqft, color = key)) +

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

  # Only 1 Prediction
  if (n_predictions == 1) {
    g <- g + geom_point(aes(text = label_text), size = 1)
  } else {
    g <- g + geom_point(aes(text = label_text), size = 0.01)
  }

  ggplotly(g, tooltip = "text")
}
