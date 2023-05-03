# 1.0 LIBRARIES -----
library(tidyverse)
library(tidyquant)
library(odbc)
library(RSQLite)
library(caret)
library(parsnip)
library(timetk)  
library(plotly)
library(dplyr)
library(lubridate)

# 2.0 PROCESS DATA ----
con <- dbConnect(RSQLite::SQLite(), "00_data/house_data.db")

sft_tbl <- tbl(con, "key_data") %>% collect()
dbDisconnect(con)

# Create price per square footage column and tbl
processed_sft_tbl <- sft_tbl %>%
  mutate(price_sqft = ifelse(is.na(SalePrice) | is.na(LotArea), 0, SalePrice / LotArea)) %>%
  mutate(date = make_date(YrSold, MoSold)) %>%
  select(date, price_sqft)
  

# 3.0 TIME SERIES AGGREGATION ----

# 3.1 DATA MANIPULATION ----
time_unit <- "month"

sqft_time_plot_tbl <- processed_sft_tbl %>%
  
  mutate(date = floor_date(date, unit = time_unit)) %>%
  
  group_by(date) %>%
  summarize(total_sqft = sum(price_sqft)) %>%
  ungroup() %>%
  
  mutate(label_text = str_glue("Date: {date}
                               USD price per sqft: {scales::dollar(total_sqft)}"))

sqft_time_plot_tbl


# 3.2 AGG FUNCTION ----

aggregate_time_sqft <- function(data, time_unit = "month") {
  
  output_tbl <- data %>%
    
    mutate(date = floor_date(date, unit = time_unit)) %>%
    
    group_by(date) %>%
    summarize(total_sqft = sum(price_sqft)) %>%
    ungroup() %>%
    
    mutate(label_text = str_glue("Date: {date}
                                 Sale Price: {scales::dollar(total_sqft)}"))
  
  return(output_tbl)
  
}

processed_sft_tbl %>%
  aggregate_time_sqft(time_unit = "month")

# 3.3 TIME SERIES PLOT ----

data <- processed_sft_tbl %>%
  aggregate_time_sqft("month")

g <- data %>%
  
  ggplot(aes(date, total_sqft)) +
  
  geom_line(color = "#2c3e50") +
  geom_point(aes(text = label_text), color = "#2c3e50", size = 0.01) +
  geom_smooth(method = "loess", span = 0.2) +
  
  theme_tq() +
  expand_limits(y = 0) +
  scale_y_continuous(labels = scales::dollar_format()) +
  labs(x = "", y = "")


ggplotly(g, tooltip = "text")


# 3.4 FUNCTION PLOT TIME ----

sqft_plot_time_series <- function(data) {
  
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

processed_sft_tbl %>%
  aggregate_time_sqft(time_unit = "month") %>%
  sqft_plot_time_series()


# 4.0 FORECAST -----

# 4.1 SETUP TRAINING DATA AND FUTURE DATA ----

# TODO - timetk

data <- processed_sft_tbl %>%
  aggregate_time_sqft(time_unit = "year")

data %>% tk_index() %>% tk_get_timeseries_signature()
data %>% tk_index() %>% tk_get_timeseries_summary()

# tk_get_timeseries_unit_frequency() is a helper function 
# tk_get_timeseries_variables() another helper function

data %>% tk_augment_timeseries_signature()

strain_tbl <- data %>% 
  tk_augment_timeseries_signature()

sfuture_data_tbl <- data %>%
  tk_index() %>%
  tk_make_future_timeseries(length_out = 365) %>%
  tk_get_timeseries_signature()


# 4.2 MACHINE LEARNING ----

# TODO - XGBoost

seed <- 123
set.seed(seed)
model_xgboost <- boost_tree(
  mode = "regression", 
  mtry = 20, 
  trees = 500, 
  min_n = 3, 
  tree_depth = 8,
  learn_rate = 0.01, 
  loss_reduction = 0.01) %>%
  set_engine(engine = "xgboost") %>%
  fit.model_spec(total_sqft ~ ., data = strain_tbl %>% select(-date, -label_text, -diff))


# 4.3 MAKE PREDICTION & FORMAT OUTPUT ----

sprediction_tbl <- predict(model_xgboost, new_data = sfuture_data_tbl) %>%
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

output_tbl



# 4.4 FUNCTION FORECAST ----

# TODO - generate_forecast()

length_out <- 2
seed <- 123

generate_forecast <- function(data, length_out = 12, seed = NULL) {

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


processed_sft_tbl %>%
  aggregate_time_sqft(time_unit = "year") %>%
  generate_forecast(length_out = 2, seed = 123)

# 5.0 PLOT FORECAST ----

# 5.1 PLOT ----

# TODO - plot
data <- processed_sft_tbl %>%
  aggregate_time_sqft(time_unit = "month") %>%
  generate_forecast(length_out = 12, seed = 123)

g <- data %>%
  ggplot(aes(date, total_sqft, color = key)) +

  geom_line() +
  geom_point(aes(text = label_text), size = 0.01) +
  geom_smooth(method = "loess", span = 0.2) +

  theme_tq() +
  scale_color_tq() +
  scale_y_continuous(labels = scales::dollar_format()) +
  labs(x = "", y = "")

ggplotly(g, tooltip = "text")

# 5.2 FUNCTION PLOT FORECAST ----

# TODO - plot_forecast() to allow yearly prediction

data <- processed_sft_tbl %>%
  aggregate_time_sqft(time_unit = "month") %>%
  generate_forecast(length_out = 12, seed = 123) %>%
  sqft_plot_time_series()

plot_forecast <- function(data) {

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

processed_sft_tbl %>%
  aggregate_time_sqft(time_unit = "year") %>%
  generate_forecast(length_out = 2, seed = 123) %>%
  plot_forecast()


# # 6.0 SAVE FUNCTIONS ----

dump(c("aggregate_time_sqft", "sqft_plot_time_series", "generate_forecast", "plot_forecast"),
     file = "00_scripts/04_demand_forecast.R")






