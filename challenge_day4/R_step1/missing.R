# missing.R

cran <- "https://cran.rstudio.com/"

# Try to load jsonlite; install if missing
if (!requireNamespace("jsonlite", quietly = TRUE)) {
  # Prefer binary; if unavailable it will fall back to source below
  tryCatch(install.packages("jsonlite", repos = cran, type = "binary"),
           error = function(e) invisible(NULL))
}

if (!requireNamespace("jsonlite", quietly = TRUE)) {
  # Ensure Apple Clang uses a supported C standard
  # (this does NOT run shell; it passes configure vars correctly)
  install.packages("jsonlite", repos = cran, type = "source",
                   configure.vars = "CSTD=-std=gnu17")
}

if (!requireNamespace("jsonlite", quietly = TRUE)) {
  stop("Failed to install 'jsonlite'. Create ~/.R/Makevars with 'CSTD = -std=gnu17' and retry.")
}

library(jsonlite)

# Ensure input exists
if (!file.exists("data1.json")) {
  stop("data1.json not found in current directory: ", getwd())
}

# Read JSON
json_data <- fromJSON("data1.json")

# Validate structure
if (is.null(json_data$people)) {
  stop("'people' not found in the JSON root object.")
}

# Work with people as a data frame
people_df <- as.data.frame(json_data$people, stringsAsFactors = FALSE, optional = TRUE)

# Replace NAs in numeric columns with column means
numeric_cols <- vapply(people_df, is.numeric, logical(1))
for (nm in names(people_df)[numeric_cols]) {
  x <- people_df[[nm]]
  m <- mean(x, na.rm = TRUE)
  if (!is.nan(m)) x[is.na(x)] <- m
  people_df[[nm]] <- x
}

# Put it back (fixes earlier typo: person_df -> people_df)
json_data$people <- people_df

# Write updated JSON, keeping people as an array of objects
write_json(json_data, path = "data2.json", pretty = TRUE, dataframe = "rows", auto_unbox = TRUE)

cat("Wrote cleaned JSON to data2.json\n")
