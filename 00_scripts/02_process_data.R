# Install packages and call libraries to create DB instance
# install.packages("readxl")
# install.packages("DBI")
# install.packages("RSQLite")
# library(readxl)
# library(DBI)
# library(RSQLite)

# Read in dataset from "00_data" directory
data <- read.csv("00_data/wmd_house.csv")

# Create a connection to the SQLite database using dbConnect()
# Replace "path/to/database.sqlite" with the path and name you want to use for the database file. 
# Make sure the file extension is ".sqlite".
con <- dbConnect(RSQLite::SQLite(), "00_data/database.sqlite")
# Write the data frame to the database using dbWriteTable() function from DBI package:
dbWriteTable(conn = con, name = "house_tbl", value = data, overwrite = TRUE)
# Close the database connection using dbDisconnect() function:
dbDisconnect(con)



