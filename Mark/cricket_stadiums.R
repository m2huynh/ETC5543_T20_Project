# Load required libraries
library(rvest)
library(httr)
library(dplyr)

# 1. Define the target URL
url <- "https://www.ipl.com/cricket/news/australia-cricket-stadiums-list-2026-all-major-grounds-capacity-amp-home-teams/"

# 2. Request the page with a realistic User-Agent to avoid being blocked by bots
response <- GET(
  url, 
  user_agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36")
)

# 3. Parse the HTML content
page <- read_html(response)

# 4. Extract all HTML tables on the page into a list of data frames
tables <- page %>% html_elements("table") %>% html_table(fill = TRUE)

# 5. Find the specific table containing the stadium data
# We check if "Stadium" is one of the column names
target_table <- NULL
for (tbl in tables) {
  if ("Stadium" %in% colnames(tbl)) {
    target_table <- tbl
    break
  }
}

# 6. Save the data to CSV if the table was found
if (!is.null(target_table)) {
  # Write to CSV in the current working directory
  write.csv(target_table, "data/australia_cricket_stadiums.csv", row.names = FALSE)
  
  cat("✅ Success! CSV extracted and saved as 'australia_cricket_stadiums.csv'\n\n")
  
  # Print the first few rows to the console
  print(head(target_table))
} else {
  cat("❌ Could not find the stadium table on this page.\n")
}
