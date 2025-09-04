# Read the JSON file as text
json_file <- file("/Users/voldemarq/late-group/challenge_day4/fulldata/data1.json", "r")
json_text <- readLines(json_file)
close(json_file)

# Basic JSON parsing (since we know the structure)
# Remove curly braces and "people": [ from the start
json_text <- gsub("^\\{\\s*\"people\":\\s*\\[", "", paste(json_text, collapse=""))
# Remove closing brackets
json_text <- gsub("\\]\\s*\\}\\s*$", "", json_text)
# Split into individual person records
people_records <- strsplit(json_text, "\\},\\s*\\{")[[1]]
# Clean up the first and last record
people_records[1] <- gsub("^\\{", "", people_records[1])
people_records[length(people_records)] <- gsub("\\}$", "", people_records[length(people_records)])

# Parse each record into a list
parse_record <- function(record) {
  # Extract name
  name <- gsub('.*"name":\\s*"([^"]+)".*', "\\1", record)
  
  # Extract skills
  skills <- c(
    "Technical Skills" = as.numeric(gsub('.*"Technical Skills":\\s*(\\d+).*', "\\1", record)),
    "Soft Skills" = as.numeric(gsub('.*"Soft Skills":\\s*(\\d+).*', "\\1", record)),
    "Business Skills" = as.numeric(gsub('.*"Business Skills":\\s*(\\d+).*', "\\1", record)),
    "Creative Skills" = as.numeric(gsub('.*"Creative Skills":\\s*(\\d+).*', "\\1", record)),
    "Academic Skills" = as.numeric(gsub('.*"Academic Skills":\\s*(\\d+).*', "\\1", record))
  )
  
  # Handle missing values
  skills[is.na(skills)] <- mean(skills, na.rm=TRUE)
  
  c(list(name=name), as.list(skills))
}

# Process all records
people_data <- lapply(people_records, parse_record)

# Convert back to JSON format
make_json <- function(people) {
  records <- sapply(people, function(p) {
    sprintf('{
      "name": "%s",
      "Technical Skills": %.1f,
      "Soft Skills": %.1f,
      "Business Skills": %.1f,
      "Creative Skills": %.1f,
      "Academic Skills": %.1f
    }', p$name, p$`Technical Skills`, p$`Soft Skills`, p$`Business Skills`, p$`Creative Skills`, p$`Academic Skills`)
  })
  
  sprintf('{\n  "people": [\n    %s\n  ]\n}',
          paste(records, collapse=",\n    "))
}

# Generate and write the output
output_json <- make_json(people_data)
writeLines(output_json, "/Users/voldemarq/late-group/challenge_day4/fulldata/data2.json")