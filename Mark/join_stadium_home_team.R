library(dplyr)

bbl_match_info <- bbl_match_info |>
  select(-city) |>
  left_join(stadium_lookup, by = c("venue" = "original_stadium")) |>
  relocate(clean_stadium, home_team, city, .after = venue)

bbl_all <- bbl_all |>
  left_join(stadium_lookup, by = c("venue" = "original_stadium")) |>
  relocate(clean_stadium, home_team, city, .after = venue)

bbl_local_time <- bbl_local_time |>
  left_join(stadium_lookup, by = c("venue" = "original_stadium")) |>
  select(date, time_local, clean_stadium, match_pair)
