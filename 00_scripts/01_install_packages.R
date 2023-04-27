# SHINY APPS - LEVEL 1 ----
# R PACKAGES

r_pkgs <- c(
    # Core
    "tidyverse",
    "tidyquant",
    "skimr",
    
    # Database
    "odbc",
    "RSQLite",
    "readx1",
    "DBI",
    
    # Visualization
    "plotly",
    "ggmap",
    
    # Shiny-verse
    "flexdashboard",
    "shiny",
    "shinyWidgets",
    "shinyjs",
    
    # Modeling & Machine Learning
    "parsnip",
    "rsample",
    "cluster"
    )

install.packages(r_pkgs)
