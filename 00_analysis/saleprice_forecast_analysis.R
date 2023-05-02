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

glm_tbl <- tbl(con, "key_data") %>% collect()
dbDisconnect(con)

# Create price per square footage column and tbl
processed_glm_tbl <- glm_tbl %>%
  mutate(price_sqft = ifelse(is.na(SalePrice) | is.na(LotArea), 0, SalePrice / LotArea)) %>%
  mutate(date = make_date(YrSold, MoSold)) %>%
  select(date, SalePrice)
  

# 3.0 TIME SERIES AGGREGATION ----

# 3.1 DATA MANIPULATION ----
time_unit <- "year"

time_plot_tbl <- processed_glm_tbl %>%
  
  mutate(date = floor_date(date, unit = time_unit)) %>%
  
  group_by(date) %>%
  summarize(total_sale = sum(SalePrice)) %>%
  ungroup() %>%
  
  mutate(label_text = str_glue("Date: {date}
                               Sale Price: {scales::dollar(total_sale)}"))

time_plot_tbl


# 3.2 AGG FUNCTION ----

aggregate_time_series <- function(data, time_unit = "month") {
  
  output_tbl <- data %>%
    
    mutate(date = floor_date(date, unit = time_unit)) %>%
    
    group_by(date) %>%
    summarize(total_sale = sum(SalePrice)) %>%
    ungroup() %>%
    
    mutate(label_text = str_glue("Date: {date}
                                 Sale Price: {scales::dollar(total_sale)}"))
  
  return(output_tbl)
  
}


# 3.3 TIME SERIES PLOT ----

glm_data <- processed_glm_tbl %>%
  aggregate_time_series("month")

g2 <- glm_data %>%
  
  ggplot(aes(date, total_sale)) +
  
  geom_line(color = "#2c3e50") +
  geom_point(aes(text = label_text), color = "#2c3e50", size = 0.1) +
  geom_smooth(method = "loess", span = 0.2) +
  
  theme_tq() +
  expand_limits(y = 0) +
  scale_y_continuous(labels = scales::dollar_format()) +
  labs(x = "", y = "")


ggplotly(g2, tooltip = "text")


# 3.4 FUNCTION TIME ----

plot_time_series <- function(glm_data) {
  
  g2 <- glm_data %>%
    
    ggplot(aes(date, total_sale)) +
    
    geom_line(color = "#2c3e50") +
    geom_point(aes(label = label_text), color = "#2c3e50", size = 0.1) +
    geom_smooth(method = "loess", span = 0.2) +
    
    theme_tq() +
    expand_limits(y = 0) +
    scale_y_continuous(labels = scales::dollar_format()) +
    labs(x = "", y = "")
  
  ggplotly(g2, tooltip = "label")
  
}

processed_glm_tbl %>%
  aggregate_time_series(time_unit = "week") %>%
  plot_time_series()


# 4.0 FORECAST -----

# 4.1 SETUP TRAINING DATA AND FUTURE DATA ----
data <- processed_glm_tbl %>%
  aggregate_time_series(time_unit = "month")

data %>% tk_index() %>% tk_get_timeseries_signature()
data %>% tk_index() %>% tk_get_timeseries_summary()

tk_get_timeseries_unit_frequency()
data %>% tk_get_timeseries_variables()

data %>% tk_augment_timeseries_signature()

train_tbl <- data %>% 
  tk_augment_timeseries_signature()

future_data_tbl <- data %>%
  tk_index() %>%
  tk_make_future_timeseries(length_out = 12, inspect_weekdays = TRUE, inspect_months = TRUE) %>%
  tk_get_timeseries_signature() 


# 4.2 MACHINE LEARNING ----

set.seed(123)
train_control <- trainControl(method = "cv", 
                              number = 10, 
                              savePredictions = "final",
                              classProbs = TRUE,
                              summaryFunction = twoClassSummary)

model_glm <- glm(SalePrice ~ ., data = processed_glm_tbl, family = gaussian)


# 4.3 MAKE PREDICTION & FORMAT OUTPUT ----

future_data_tbl <- future_data_tbl %>%
  mutate(date = seq(from = as.Date("2023-06-01"), by = "month", length.out = nrow(future_data_tbl)))


prediction_tbl <- predict(model_glm, newdata = future_data_tbl) %>%
  as_tibble() %>%
  mutate(date = as.Date(future_data_tbl$date)) %>%
  mutate(label_text = str_glue("Date: {date}
                                Total Sale: {scales::dollar(value)}")) %>%
  add_column(key = "Prediction")

output_tbl <- data %>%
  add_column(key = "Actual") %>%
  bind_rows(prediction_tbl) %>%
  select(key, date, total_sale, label_text)

output_tbl


# 4.4 FUNCTION FORECAST ----

# TODO - generate_forecast()

seed <- 123

generate_forecast <- function(data, length_out = 12, seed = NULL) {

  train_tbl <- data %>%
    tk_augment_timeseries_signature()

  future_data_tbl <- data %>%
    tk_index() %>%
    tk_make_future_timeseries(n_future = length_out, inspect_weekdays = TRUE, inspect_months = TRUE) %>%
    tk_get_timeseries_signature()

  time_scale <- data %>%
    tk_index() %>%
    tk_get_timeseries_summary() %>%
    pull(scale)

  if (time_scale == "year") {

    model <- linear_reg(mode = "regression") %>%
      set_engine(engine = "lm") %>%
      fit.model_spec(total_sale ~ ., data = train_tbl %>% select(total_sales, index.num))

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
      fit.model_spec(total_sale ~ ., data = train_tbl %>% select(-date, -label_text, -diff))
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


processed_data_tbl %>%
  aggregate_time_series(time_unit = "year") %>%
  generate_forecast(n_future = 2, seed = 123)

# 5.0 PLOT FORECAST ----

# 5.1 PLOT ----

# # TODO - plot
# data <- processed_data_tbl %>%
#   aggregate_time_series(time_unit = "month") %>%
#   generate_forecast(n_future = 12, seed = 123) 
# 
# g <- data %>%
#   ggplot(aes(date, total_sales, color = key)) +
#   
#   geom_line() +
#   geom_point(aes(text = label_text), size = 0.01) +
#   geom_smooth(method = "loess", span = 0.2) +
#   
#   theme_tq() +
#   scale_color_tq() +
#   scale_y_continuous(labels = scales::dollar_format()) +
#   labs(x = "", y = "")
# 
# ggplotly(g, tooltip = "text")
# 
# # 5.2 FUNCTION ----
# 
# # TODO - plot_forecast()
# 
# data <- processed_data_tbl %>%
#   aggregate_time_series(time_unit = "year") %>%
#   generate_forecast(n_future = 1, seed = 123)
# 
# plot_forecast <- function(data) {
#   
#   # Yearly - LM Smoother
#   time_scale <- data %>%
#     tk_index() %>%
#     tk_get_timeseries_summary() %>%
#     pull(scale)
#   
#   # Only 1 Prediction - points
#   n_predictions <- data %>%
#     filter(key == "Prediction") %>%
#     nrow()
#   
#   
#   g <- data %>%
#     ggplot(aes(date, total_sales, color = key)) +
#     
#     geom_line() +
#     # geom_point(aes(text = label_text), size = 0.01) +
#     # geom_smooth(method = "loess", span = 0.2) +
#     
#     theme_tq() +
#     scale_color_tq() +
#     scale_y_continuous(labels = scales::dollar_format()) +
#     expand_limits(y = 0) +
#     labs(x = "", y = "")
#   
#   # Yearly - LM Smoother
#   if (time_scale == "year") {
#     g <- g +
#       geom_smooth(method = "lm")
#   } else {
#     g <- g + geom_smooth(method = "loess", span = 0.2)
#   }
#   
#   # Only 1 Prediction
#   if (n_predictions == 1) {
#     g <- g + geom_point(aes(text = label_text), size = 1)
#   } else {
#     g <- g + geom_point(aes(text = label_text), size = 0.01)
#   }
#   
#   ggplotly(g, tooltip = "text")
# }
# 
# processed_data_tbl %>%
#   aggregate_time_series(time_unit = "day") %>%
#   generate_forecast(n_future = 365, seed = 123) %>%
#   plot_forecast()
# 
# 
# # 6.0 SAVE FUNCTIONS ----
# 
# dump(c("aggregate_time_series", "plot_time_series", "generate_forecast", "plot_forecast"), 
#      file = "00_scripts/04_demand_forecast.R")






