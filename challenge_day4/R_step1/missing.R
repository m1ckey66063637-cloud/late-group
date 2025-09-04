# Check if jsonlite is installed; if not, install it
if (!requireNamespace("jsonlite", quietly = TRUE)) {
  install.packages("jsonlite", repos = "http://cran.rstudio.com/")
}

# Load the required library
library(jsonlite)

# Read the JSON file into a data frame
json_data <- fromJSON("/Users/voldemarq/late-group/challenge_day4/fulldata/data1.json")

# Convert the 'people' list to a data frame
people_df <- as.data.frame(json_data$people)

# Replace NAs with column means
for(col_name in names(people_df)) {
  if(is.numeric(people_df[[col_name]])) {
    # Calculate mean, excluding NAs
    col_mean <- mean(people_df[[col_name]], na.rm = TRUE)
    
    # Replace NAs with the calculated mean
    people_df[[col_name]][is.na(people_df[[col_name]])] <- col_mean
  }
}

<<<<<<< HEAD
# Replace the 'people' list in the original data with the modified data frame
=======
>>>>>>> 4464245908a621d230741f00c56fd1f1754d1ad3
json_data$people <- people_df

# Convert the updated data back to JSON format
json_text <- toJSON(json_data, pretty = TRUE)

# Overwrite the original JSON file
<<<<<<< HEAD
write(json_text, "/Users/voldemarq/late-group/challenge_day4/testdata/data2.json")
=======
write(json_text, "data2.json")


>>>>>>> 4464245908a621d230741f00c56fd1f1754d1ad3
