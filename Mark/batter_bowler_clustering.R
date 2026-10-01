library(tidyverse)

source("logistic_regression.R")

batter_stats <- bbl_all %>%
  filter(is.na(wides)) %>% # Exclude wides from balls faced
  mutate(
    phase = case_when(
      ball <= 6 ~ "Powerplay",
      ball <= 16 ~ "Middle",
      TRUE ~ "Death"
    ),
    is_dot = ifelse(runs_off_bat == 0 & extras == 0, 1, 0),
    is_boundary = ifelse(runs_off_bat %in% c(4, 6), 1, 0)
  ) %>%
  group_by(striker) %>%
  filter(n() >= 100) %>% # Minimum 100 balls faced
  summarise(
    balls_faced = n(),
    strike_rate = (sum(runs_off_bat) / balls_faced) * 100,
    dot_pct = mean(is_dot),
    boundary_pct = mean(is_boundary),
    pp_ball_pct = mean(phase == "PP"),
    death_ball_pct = mean(phase == "Death"),
    pp_sr = ifelse(sum(phase == "PP") > 15, 
                   (sum(runs_off_bat[phase == "PP"]) / sum(phase == "PP")) * 100, strike_rate),
    death_sr = ifelse(sum(phase == "Death") > 15, 
                      (sum(runs_off_bat[phase == "Death"]) / sum(phase == "Death")) * 100, strike_rate)
  )

# Select numeric features and scale
batter_matrix <- batter_stats %>% 
  select(-striker, -balls_faced) %>% 
  scale()

# Determine optimal k using total within-cluster sum of squares (Elbow Method)
wss <- sapply(1:20, function(k) kmeans(batter_matrix, centers = k, nstart = 25)$tot.withinss)
plot(1:20, wss, type = "b", xlab = "Number of Clusters (k)", ylab = "Within groups sum of squares")

# Fit final model (e.g., k = 4 archetypes)
set.seed(1)
fit_batters <- kmeans(batter_matrix, centers = 5, nstart = 25)

# Append cluster labels back to dataset
batter_clusters <- batter_stats %>% 
  mutate(cluster = as.factor(fit_batters$cluster))
