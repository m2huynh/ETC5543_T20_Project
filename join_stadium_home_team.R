library(dplyr)

bbl_match_info <- read_csv("data/bbl_match_info.csv")

bbl_match_info <- bbl_match_info |>
  left_join(stadium_lookup, by = c("venue" = "original_stadium")) |>
  relocate(clean_stadium, home_team, .after = venue)