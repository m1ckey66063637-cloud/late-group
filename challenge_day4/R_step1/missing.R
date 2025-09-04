# Function to safely read a file
safe_read_file <- function(filepath) {
  if (!file.exists(filepath)) {
    stop(sprintf("Input file not found: %s", filepath))
  }
  tryCatch({
    json_file <- file(filepath, "r")
    json_text <- readLines(json_file)
    close(json_file)
    return(json_text)
  }, error = function(e) {
    if (!is.null(json_file) && isOpen(json_file)) close(json_file)
    stop(sprintf("Error reading file: %s", e$message))
  })
}

# Read the JSON file as text
json_text <- safe_read_file("/Users/voldemarq/late-group/challenge_day4/fulldata/data1.json")

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
  if (name == record) {
    warning("Could not extract name from record")
    name <- "Unknown"
  }
  
  # Extract skills with validation
  extract_skill <- function(skill_name, record) {
    value <- as.numeric(gsub(sprintf('.*"%s":\\s*(\\d+).*', skill_name), "\\1", record))
    if (is.na(value)) {
      warning(sprintf("Could not extract %s from record", skill_name))
    }
    return(value)
  }
  
  skills <- c(
    "Technical Skills" = extract_skill("Technical Skills", record),
    "Soft Skills" = extract_skill("Soft Skills", record),
    "Business Skills" = extract_skill("Business Skills", record),
    "Creative Skills" = extract_skill("Creative Skills", record),
    "Academic Skills" = extract_skill("Academic Skills", record)
  )
  
  # Handle missing values
  mean_skill <- mean(skills, na.rm=TRUE)
  if (is.na(mean_skill)) {
    warning("No valid skills found, using 0 as default")
    mean_skill <- 0
  }
  skills[is.na(skills)] <- mean_skill
  
  c(list(name=name), as.list(skills))
}

# Process all records
people_data <- lapply(people_records, parse_record)

# Convert back to JSON format
make_json <- function(people) {
  if (length(people) == 0) {
    return('{"people": []}')
  }
  
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
tryCatch({
  writeLines(output_json, "/Users/voldemarq/late-group/challenge_day4/fulldata/data2.json")
}, error = function(e) {
  stop(sprintf("Error writing output file: %s", e$message))
})