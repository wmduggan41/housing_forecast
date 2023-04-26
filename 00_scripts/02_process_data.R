# Create 3 connections to 1 database using dbConnect()
# Replace "path/to/database.db" with the path and name you want to use for the database file. 

# 1.0 Read train dataset from "00_data" directory ----
train_data <- read.csv("00_data/train.csv")
# Make sure the database file extension is ".db"
con <- dbConnect(RSQLite::SQLite(), "00_data/house_data.db")
# Write the train data frame to the database using dbWriteTable() function from DBI package:
dbWriteTable(conn = con, name = "house_train_tbl", value = train_data, overwrite = TRUE)

# 2.0 Read in test dataset from "00_data" directory ----
test_data <- read.csv("00_data/test.csv")
# Write the test data frame to the database using dbWriteTable() function from DBI package:
dbWriteTable(conn = con, name = "house_test_tbl", value = test_data, overwrite = TRUE)

# 3.0 Create new database using values of interest ----
key_data <- read.csv("00_data/wmd_house.csv")
# Write the key data frame to the database using dbWriteTable() function from DBI package:
dbWriteTable(conn = con, name = "key_tbl", value = key_data, overwrite = TRUE)

# Close the database connection using dbDisconnect() function:
dbDisconnect(con)


