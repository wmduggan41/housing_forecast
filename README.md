# ```Kaggle | Boston Housing Dataset```

```{r setup, include=FALSE}
library(knitr)
library(skimr)
library(dplyr)
library(extrafont)
opts_chunk$set(warning = FALSE,
               message = FALSE,
               fig.align  = "center",
               fig.width = 7.25,
               fig.height = 6)

```


```{r check_fonts}
fonts <- extrafont::fonttable()
any(grepl("Deja", fonts$FontName))
```


```{r check_locale}
sessionInfo()
```



```{r, results='asis'}
kable(skim(train_check))
```


<hr>

This project was created to explore the Kaggle dataset [House_Prices](https://www.kaggle.com/competitions/house-prices-advanced-regression-techniques) and to implement machine learning techniques using R.

| Feature | Status |
|---------|--------|
| Task 1 - Target Variables | Complete |
| Task 2 - ML implementation | In progress |
| Task 3 - Shiny Web App | Planned |

The description of the dataset contains the following information:

### <font color = "red">Clustering variables:</font>	

|  | Name | Data Type |
|---|------|-----------|
|01 | BldgType | Chr |
|02 | Neighborhood | Chr |
|03 | Lot Area | Int |
|04 | OverallQual | Int |
|05 | OverallCond | Int |
|06 | YearBuilt | Int |
|07 | YearRemodAdd | Int |
|08 | MoSold | Int |
|09 | YrSold | Int |
|10 | SalePrice | Int |

### <font color = "red">Objective: Identify abnormal differences that affect target Sale Price value.</font>

- Rows: 1461
- Categorical Variables: 2
- Numerical Variables: 9
















![](img/iam.jpg "hover text")
