# GLM model
set.seed(123)

# Split data into 70/30 train and test sets
train_ind <- key_tbl %>% 
  sample_frac(0, 7) %>% 
  pull(row_number())

train_glm <- key_tbl[train_ind, ]
test_glm <- key_tbl[-train_ind, ]

# Fit GLM to train
model_glm <- 
  glm(SalePrice ~ ., 
      data = train_glm[, -1], 
      family = gaussian(link = "identity"))

# Make predictions
glm_preds <- predict(model_glm, 
                     newdata = test_glm[, -1], 
                     type = "response")

# GLM plot
library(plotly)

plot_ly(x = test_glm$SalePrice, y = glm_preds, mode = "markers") %>%
  add_trace(x = c(0, max(test_glm$SalePrice)),
            y = c(0, max(test_glm$SalePrice)),
            mode = "lines",
            line = list(color = "red"),
            showlegend = FALSE) %>%
  layout(xaxis = list(title = "Actual SalePrice"),
         yaxis = list(title = "Predicted SalePrice"))
