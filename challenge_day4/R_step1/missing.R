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

# Parse JSON using base R (no external packages needed)
json_data <- tryCatch({
  # Try using base R's fromJSON if available
  if (exists("fromJSON")) {
    fromJSON(file="/Users/voldemarq/late-group/challenge_day4/fulldata/data1.json")
  } else {
    # Fallback: simple text parsing
    json_string <- paste(json_text, collapse="")
    eval(parse(text=json_string))  # This is risky but works for simple JSON
  }
}, error = function(e) {
  cat("JSON parsing failed:", e$message, "\n")
  cat("Falling back to manual parsing...\n")

  # Manual parsing as fallback
  parse_json_manual <- function(json_lines) {
    # Remove braces and "people": [
    content <- paste(json_lines, collapse="")
    content <- sub("^\\{\\s*\"people\":\\s*\\[\\s*", "", content)
    content <- sub("\\]\\s*\\}\\s*$", "", content)

    # Split by person objects
    person_strings <- strsplit(content, "\\},\\s*\\{")[[1]]
    person_strings[1] <- sub("^\\{", "", person_strings[1])
    person_strings[length(person_strings)] <- sub("\\}$", "", person_strings[length(person_strings)])

    # Parse each person
    people <- list()
    for (i in 1:length(person_strings)) {
      person_str <- person_strings[i]

      # Extract name
      name <- sub('.*"name":\\s*"([^"]+)".*', "\\1", person_str)

      # Extract each skill individually (more robust than regex)
      extract_skill <- function(skill_name, text) {
        pattern <- sprintf('"%s":\\s*(\\d+)', skill_name)
        match <- regmatches(text, regexec(pattern, text))
        if (length(match[[1]]) > 1) {
          as.numeric(match[[1]][2])
        } else {
          NA
        }
      }

      skills <- c(
        "Technical Skills" = extract_skill("Technical Skills", person_str),
        "Soft Skills" = extract_skill("Soft Skills", person_str),
        "Business Skills" = extract_skill("Business Skills", person_str),
        "Creative Skills" = extract_skill("Creative Skills", person_str),
        "Academic Skills" = extract_skill("Academic Skills", person_str)
      )

      people[[i]] <- list(
        name = name,
        skills = skills
      )
    }
    return(list(people = people))
  }

  parse_json_manual(json_text)
})

# Process the data properly
people_data <- json_data$people

# Function to handle missing values for a person
process_person <- function(person) {
  # Extract all skill values
  skills <- person$skills

  # Replace NAs with column mean
  mean_skill <- mean(skills, na.rm=TRUE)
  if (is.na(mean_skill)) {
    mean_skill <- 0  # fallback if all skills are missing
  }
  skills[is.na(skills)] <- mean_skill

  # Return processed person
  list(
    name = person$name,
    "Technical Skills" = skills["Technical Skills"],
    "Soft Skills" = skills["Soft Skills"],
    "Business Skills" = skills["Business Skills"],
    "Creative Skills" = skills["Creative Skills"],
    "Academic Skills" = skills["Academic Skills"]
  )
}

# Process all people
processed_people <- lapply(people_data, process_person)

# Convert back to JSON format
make_json <- function(people) {
  if (length(people) == 0) {
    return('{"people": []}')
  }

  records <- sapply(people, function(p) {
    sprintf('{
      "name": "%s",
      "Technical Skills": %.3f,
      "Soft Skills": %.3f,
      "Business Skills": %.3f,
      "Creative Skills": %.3f,
      "Academic Skills": %.3f
    }', p$name, p$`Technical Skills`, p$`Soft Skills`, p$`Business Skills`, p$`Creative Skills`, p$`Academic Skills`)
  })

  sprintf('{\n  "people": [\n    %s\n  ]\n}',
          paste(records, collapse=",\n    "))
}

# Generate and write the output
output_json <- make_json(processed_people)
tryCatch({
  writeLines(output_json, "/Users/voldemarq/late-group/challenge_day4/fulldata/data2.json")
  cat("Successfully processed", length(processed_people), "people\n")
}, error = function(e) {
  stop(sprintf("Error writing output file: %s", e$message))
})