# Modelling Match State and Player Performance in the Big Bash League

This project analyses historical Big Bash League ball-by-ball data to understand how match state influences scoring, wickets and player performance in T20 cricket.
The project combines feature engineering, statistical modelling and interactive visualisation. Historical BBL data was used to 
reconstruct match situations delivery by delivery, analyse scoring and wicket patterns, estimate chase difficulty, predict wicket 
probability and evaluate player performance under different match conditions.

Interactive dashboard and predictive models were developed to allow users to explore historical BBL patterns across seasons, 
teams, opponents and match situations.

---

## Team Members

- Hieu Xuan Nguyen (Mark) - 35614978
- Pranav Sajeev - 35571381
- Prem Mallapuram - 35773499

---

## Research Questions

The project investigates six research questions:

1. How do scoring rates and wicket probabilities vary across the three phases of a T20 innings — the Powerplay (overs 1–6),
middle overs (7–16), and death overs (17–20)?

2. Can we build a model that predicts the probability of a wicket falling on any given delivery using match-state and 
player-identity features?

3. Which batters perform best under high-pressure chase situations relative to their performance in low-pressure situations?

4. Which bowlers are most effective at restricting runs and taking wickets in the death overs after controlling for the 
match state they bowl in?

5. Does winning the toss and choosing to field translate into a meaningful advantage?

6. Do players naturally cluster into distinct batting or bowling archetypes based on their ball-by-ball performance profiles?

---

## Data

The data used in this project was obtained from [CricSheet](https://cricsheet.org/).

Two main datasets were used - bbl_all.csv, Ball-by-ball BBL data where each observation represents one delivery and
bbl_match_info.csv - Match-level information where each observation represents one match.

# Analysis

## 1. Scoring Rate and Wicket Patterns

The tabs in the dashboard are as follows,

### Score Progression - The Score section recreates the progression of an individual match.
### Run Rate Progression - This provides a descriptive overview of how a selected match developed.
### Over Run Rate - The Over Run Rate analysis examines each over individually rather than cumulatively.
### Wicket Analysis - By Over - Shows the historical frequency of wickets falling in each over and
                      By Bowler - Shows which bowlers have historically taken the most wickets against the selected batting team.
                                  Only dismissals credited to the bowler are included.

## 2. Batter Performance Under Pressure

The second analysis investigates how batters perform under different chase-pressure situations. Only second innings were 
used because a known target is required to measure the difficulty of a run chase. Shortened or interrupted matches were 
excluded where the standard 120-ball structure could not be used reliably.

Three variables were used to represent the chase situation before each delivery:
- Required run rate - Required Run Rate = (Runs Required / Balls Remaining) × 6
- Wickets in hand
- Balls remaining - Balls Remaining = 120 − Legal Deliveries Completed

### Win Probability Model

A logistic regression model was used because the final chase result has two possible outcomes:
- Win = 1
- Loss = 0

The model used:
- Required run rate
- Wickets in hand
- Balls remaining
to estimate the probability of the chasing team eventually winning from the match situation before each delivery.

Model performance was evaluated using:

- Classification accuracy
- Confusion matrix
- ROC-AUC

### Batsmen Pressure Analysis

The pressure classifications were applied to individual batter deliveries.For each batter, strike rate was calculated separately under Low and High Pressure situations.

The dashboard compares:
- Low Pressure strike rate
- High Pressure strike rate
- Runs scored
- Balls faced
- Chase matches
- Average required run rate
- Average wickets in hand
- Average balls remaining
- Average target

The main purpose of this comparison is to examine how the same batter's historical scoring rate differs between lower- and higher-pressure chase situations.

---

###  Predicting Delivery-Level Wicket Probability

**Research question:** Can the probability of a wicket on an individual delivery be predicted using match-state and player-related features?

An XGBoost ensemble model was developed to estimate the probability of a wicket on each delivery. The model uses match-state information, 
recent performance and player-related features. Model performance was evaluated using PR-AUC, ROC-AUC, calibration and risk-decile analysis. 
SHAP values were also used to examine the features contributing to the model's predictions.
The final model achieved a PR-AUC of 0.091 and an ROC-AUC of 0.613. It was able to identify deliveries with a higher 
likelihood of a wicket, with the highest-risk decile recording an observed wicket rate of 11.6%, compared with the overall 
rate of 5.49%. However, the model underestimated wicket frequency during the death overs.

### 2. Evaluating Death-Over Bowling Performance

**Research question:** Which bowlers are most effective at restricting runs and taking wickets during the death overs, after accounting for the match situations in which they bowl?

Mixed-effects models were developed to compare bowlers while accounting for differences in match state, batters and venues. 
A linear mixed-effects model was used to assess run restriction, while a logistic mixed-effects model examined bowler-credited
wickets. The analysis included 63 eligible bowlers who had bowled at least 120 legal deliveries during the death overs.

Bowler effects were used to compare their relative ability to restrict runs and take wickets after adjusting for the included
match conditions. The results provide a context-adjusted comparison of death-over bowling performance rather than relying 
solely on traditional bowling statistics.

# Limitations

Important limitations of the project include:


---

# Future Improvements

Future versions of the project could include:


---

# Repository Contents

The repository contains:


---

# Running the Project

Clone or download the repository and open the project in RStudio.

Install any required R packages before running the analysis.

Packages used across the project include packages from the R data-analysis, modelling and dashboard ecosystem.

Examples include:

```r
library(tidyverse)
library(shiny)
library(plotly)
library(bslib)
```

Additional modelling packages are required for the XGBoost and mixed-effects analyses.
Run the relevant feature-engineering scripts before launching the dashboard or reproducing model results.

For the dashboard follow the following steps,
1. PREM/Clean Build/Feature_engineering.qmd    (run all code)
2. PREM/Clean Build/Dashboard.R

---

# AI Acknowledgement

Generative AI tools, including ChatGPT, were used as a supporting tool during the development of this project. AI was used during the early stages to brainstorm dashboard ideas, presentation structure, possible analytical approaches and suitable modelling techniques for the research questions.

AI assistance was also used while developing and checking the technical work. This included discussing possible model parameters and tuning strategies, checking R syntax, reviewing code logic, troubleshooting errors, and evaluating whether the chosen analytical approach was appropriate for the intended research question.

In addition, AI was used to support background research and improve the presentation of the final work. This included checking grammar, improving clarity in written sections, refining presentation wording, and reviewing how the analysis and results could be communicated more clearly.

---

# License

Refer the license file in the repo