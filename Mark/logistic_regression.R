# home field?
# coin toss -> choose field
# win?

library(tidyverse)
library(jsonlite)

bbl_all <- read_csv("data/bbl_all.csv") |>
  mutate(match_pair = paste(
    pmin(batting_team, bowling_team), pmax(batting_team, bowling_team), sep = " vs. "
  ))
bbl_match_pairings <- bbl_all |>
  select(match_id, match_pair) |>
  distinct()
bbl_local_time <- readxl::read_xlsx("data/big_bash_league.xlsx", skip = 1) |>
  janitor::clean_names() |>
  mutate(time_local = hms::as_hms(time_local)) |>
  rename(home_team = home_team_h, away_team = away_team_a) |>
  mutate(match_pair = paste(
    pmin(home_team, away_team), pmax(home_team, away_team), sep = " vs. "
  ))
bbl_match_info <- read_csv("data/bbl_match_info.csv") |>
  left_join(bbl_match_pairings)

source("Mark/clean_stadium_names.R")
source("Mark/join_stadium_home_team.R")

left_join(bbl_match_info, bbl_local_time) -> bbl_match_info_with_time

coin_toss_advantage <- bbl_match_info |>
  select(clean_stadium, home_team, toss_winner, toss_decision, winner) |>
  mutate(toss_winner_is_home_team = home_team == toss_winner, .after = toss_winner) |>
  mutate(winner_is_home_team = home_team == winner) |>
  mutate(winner_same_as_toss_winner = winner == toss_winner) |>
  mutate(across(where(is.character), as.factor)) |>
  mutate(
    # Lumps any stadium with fewer than 10 matches into "Other"
    clean_stadium_grouped = fct_lump_min(as.factor(clean_stadium), 
                                         min = 10, 
                                         other_level = "Other")
  )

log_reg <- glm(
  winner_same_as_toss_winner ~ clean_stadium_grouped + toss_decision + toss_winner,
  coin_toss_advantage,
  family = binomial
)

summary(log_reg)

glm(formula = winner_same_as_toss_winner ~ 1, family = binomial, data = coin_toss_advantage) -> null_log
summary(null_log)
anova(null_log, log_reg, test = "Chisq")
