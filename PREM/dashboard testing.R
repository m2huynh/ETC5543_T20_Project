library(shiny)
library(dplyr)
library(plotly)
library(bslib)

ui <- page_sidebar(
  
  title = div(
    class = "matchcentre-title",
    span("Big-Bash-League"),
    span(
      class = "matchcentre-title-secondary",
      " Match Centre"
    )
  ),
  
  fillable = TRUE,
  
  theme = bs_theme(
    version = 5,
    bg = "#F5F7FA",
    fg = "#1F2937",
    primary = "#0F766E",
    secondary = "#64748B",
    base_font = font_google("Inter"),
    heading_font = font_google("Inter")
  ),
  
  sidebar = sidebar(
    
    title = "Score Filters",
    
    id = "match_filters",
    
    open = "closed",
    
    width = 320,
    
    div(
      class = "sidebar-section-label",
      "MATCH SELECTION"
    ),
    
    selectInput(
      inputId = "score_season",
      label = "Season",
      choices = sort(unique(db_data$season))
    ),
    
    selectInput(
      inputId = "score_match",
      label = "Match",
      choices = NULL
    )
  ),
  
  tags$head(
    tags$style(
      HTML("
        body {
          background-color: #F5F7FA;
        }

        .navbar {
          background:
            linear-gradient(
              90deg,
              #0F172A 0%,
              #123B39 65%,
              #0F766E 100%
            ) !important;

          border-bottom: 3px solid #14B8A6;

          box-shadow:
            0 4px 14px rgba(15,23,42,0.18);
        }

        .matchcentre-title {
          font-size: 22px;
          font-weight: 800;
          letter-spacing: 0.4px;
        }

        .matchcentre-title > span:first-child {
          color: #5EEAD4;
        }

        .matchcentre-title-secondary {
          color: #5EEAD4;
          font-weight: 650;
        }

        .bslib-sidebar-layout > .sidebar {
          background-color: #FFFFFF;
          border-right: 1px solid #E2E8F0;
          box-shadow: 4px 0 10px rgba(0,0,0,0.04);
        }

        .bslib-sidebar-layout .sidebar-title {
          color: #0F172A;
          font-size: 20px;
          font-weight: 750;
        }

        .sidebar-section-label {
          font-size: 11px;
          font-weight: 800;
          letter-spacing: 1.4px;
          color: #0F766E;
          margin-top: 8px;
          margin-bottom: 15px;
        }

        .control-label {
          color: #334155;
          font-weight: 650;
        }

        .form-control,
        .selectize-input {
          border: 1px solid #CBD5E1 !important;
          border-radius: 8px !important;
          background-color: #FFFFFF !important;
        }

        .selectize-input.focus {
          border-color: #14B8A6 !important;
          box-shadow:
            0 0 0 2px rgba(20,184,166,0.12) !important;
        }

        .bslib-sidebar-layout > .main {
          padding: 14px 18px 18px 18px;
        }

        .match-shell {
          background-color: #FFFFFF;
          border: 1px solid #E2E8F0;
          border-radius: 14px;
          overflow: hidden;
          box-shadow:
            0 8px 24px rgba(15,23,42,0.08);
        }

        .match-header {
          background:
            linear-gradient(
              90deg,
              #0F172A,
              #164E4A
            );

          color: white;

          padding: 15px 20px;

          display: flex;
          justify-content: space-between;
          align-items: center;

          border-bottom:
            3px solid #14B8A6;
        }

        .match-header-left {
          display: flex;
          flex-direction: column;
        }

        .match-header-label {
          font-size: 11px;
          letter-spacing: 1.3px;
          font-weight: 800;
          color: #5EEAD4;
          margin-bottom: 3px;
        }

        .match-header-title {
          font-size: 18px;
          font-weight: 750;
        }

        .match-header-badge {
          background-color:
            rgba(20,184,166,0.16);

          border:
            1px solid rgba(94,234,212,0.45);

          color: #CCFBF1;

          border-radius: 18px;

          padding: 5px 11px;

          font-size: 11px;

          font-weight: 700;

          letter-spacing: 0.8px;
        }

        .nav-tabs {
          padding-left: 14px;
          padding-right: 14px;
        }

        .nav-pills {
          padding: 8px 14px;
          gap: 5px;
        }

        .nav-pills .nav-link {
          font-size: 13px;
          font-weight: 650;
          color: #64748B;
        }

        .nav-pills .nav-link.active {
          background-color: #0F766E;
          color: white;
        }

        .analysis-filter-row {
          background-color: #F8FAFC;
          border: 1px solid #E2E8F0;
          border-radius: 10px;
          padding: 12px 16px 3px 16px;
          margin: 8px 14px 10px 14px;
        }

        .analysis-filter-title {
          font-size: 11px;
          font-weight: 800;
          letter-spacing: 1px;
          color: #0F766E;
          margin-bottom: 8px;
        }

        .match-graph,
        .rate-graph,
        .wicket-graph {
          background-color: #FFFFFF;
          padding-left: 8px;
          padding-right: 8px;
        }

        .metric-card {
          background-color: #FFFFFF;
          border: 1px solid #E2E8F0;
          border-radius: 10px;
          padding: 12px 15px;
          min-height: 82px;
        }

        .metric-card-title {
          font-size: 11px;
          color: #64748B;
          font-weight: 700;
          letter-spacing: 0.5px;
          text-transform: uppercase;
        }

        .metric-card-value {
          font-size: 21px;
          color: #0F172A;
          font-weight: 750;
          margin-top: 5px;
        }

        .metric-card-value .shiny-text-output {
          font-size: 21px;
          color: #0F172A;
          font-weight: 750;
        }

        .analysis-note {
          color: #64748B;
          font-size: 12px;
          margin: 0 16px 8px 16px;
        }

        .sidebar-toggle {
          border:
            1px solid rgba(255,255,255,0.25) !important;

          color:
            white !important;
        }
      ")
    )
  ),
  
  div(
    
    class = "match-shell",
    
    div(
      
      class = "match-header",
      
      div(
        
        class = "match-header-left",
        
        div(
          class = "match-header-label",
          "MATCH ANALYSIS"
        ),
        
        div(
          class = "match-header-title",
          "Phase Analysis"
        )
      ),
      
      div(
        class = "match-header-badge",
        "BBL"
      )
    ),
    
    navset_card_tab(
      
      id = "main_analysis_tab",
      
      nav_panel(
        
        "Phase Overview",
        
        navset_pill(
          
          id = "phase_tab",
          
          nav_panel(
            
            "Score",
            
            div(
              class = "analysis-note",
              "Use the sidebar filters to select an individual season and match."
            ),
            
            div(
              
              class = "match-graph",
              
              plotlyOutput(
                outputId = "score_plot",
                height = "calc(100vh - 285px)",
                width = "100%"
              )
            )
          ),
          
          nav_panel(
            
            "Scoring Rate",
            
            div(
              
              class = "analysis-filter-row",
              
              div(
                class = "analysis-filter-title",
                "SEASON TEAM COMPARISON"
              ),
              
              layout_columns(
                
                col_widths = c(4, 4, 4),
                
                selectInput(
                  inputId = "rate_season",
                  label = "Season",
                  choices = sort(unique(scoring_rate_comparison$season))
                ),
                
                selectInput(
                  inputId = "rate_team",
                  label = "Base Team",
                  choices = sort(unique(scoring_rate_comparison$batting_team))
                ),
                
                selectInput(
                  inputId = "rate_opponent",
                  label = "Opponent",
                  choices = NULL
                )
              )
            ),
            
            navset_pill(
              
              id = "scoring_rate_tab",
              
              nav_panel(
                
                "Run Rate Progression",
                
                div(
                  
                  class = "rate-graph",
                  
                  plotlyOutput(
                    outputId = "cumulative_rr_plot",
                    height = "430px",
                    width = "100%"
                  )
                ),
                
                layout_columns(
                  
                  col_widths = c(3, 3, 3, 3),
                  
                  div(
                    class = "metric-card",
                    div(
                      class = "metric-card-title",
                      "Powerplay Run Rate"
                    ),
                    div(
                      class = "metric-card-value",
                      textOutput("rate_powerplay")
                    )
                  ),
                  
                  div(
                    class = "metric-card",
                    div(
                      class = "metric-card-title",
                      "Mid-Game Run Rate"
                    ),
                    div(
                      class = "metric-card-value",
                      textOutput("rate_middle")
                    )
                  ),
                  
                  div(
                    class = "metric-card",
                    div(
                      class = "metric-card-title",
                      "Death Run Rate"
                    ),
                    div(
                      class = "metric-card-value",
                      textOutput("rate_death")
                    )
                  ),
                  
                  div(
                    class = "metric-card",
                    div(
                      class = "metric-card-title",
                      "Matches Compared"
                    ),
                    div(
                      class = "metric-card-value",
                      textOutput("rate_matches")
                    )
                  )
                )
              ),
              
              nav_panel(
                
                "Over Run Rate",
                
                div(
                  
                  class = "rate-graph",
                  
                  plotlyOutput(
                    outputId = "over_rr_plot",
                    height = "430px",
                    width = "100%"
                  )
                )
              )
            )
          ),
          
          nav_panel(
            
            "Wicket Analysis",
            
            div(
              
              class = "analysis-filter-row",
              
              div(
                class = "analysis-filter-title",
                "ALL-SEASON TEAM COMPARISON"
              ),
              
              layout_columns(
                
                col_widths = c(6, 6),
                
                selectInput(
                  inputId = "wicket_team",
                  label = "Base Team",
                  choices = sort(unique(wicket_all_seasons_by_over$batting_team))
                ),
                
                selectInput(
                  inputId = "wicket_opponent",
                  label = "Opponent",
                  choices = NULL
                )
              )
            ),
            
            navset_pill(
              
              id = "wicket_analysis_tab",
              
              nav_panel(
                
                "By Over",
                
                div(
                  
                  class = "wicket-graph",
                  
                  plotlyOutput(
                    outputId = "wicket_over_plot",
                    height = "400px",
                    width = "100%"
                  )
                )
              ),
              
              nav_panel(
                
                "By Phase",
                
                div(
                  
                  class = "wicket-graph",
                  
                  plotlyOutput(
                    outputId = "wicket_phase_plot",
                    height = "400px",
                    width = "100%"
                  )
                )
              ),
              
              nav_panel(
                
                "By Bowler",
                
                div(
                  
                  class = "wicket-graph",
                  
                  plotlyOutput(
                    outputId = "wicket_bowler_plot",
                    height = "400px",
                    width = "100%"
                  )
                )
              )
            ),
            
            layout_columns(
              
              col_widths = c(3, 3, 3, 3),
              
              div(
                class = "metric-card",
                div(
                  class = "metric-card-title",
                  "Total Wickets Lost"
                ),
                div(
                  class = "metric-card-value",
                  textOutput("wicket_total")
                )
              ),
              
              div(
                class = "metric-card",
                div(
                  class = "metric-card-title",
                  "Most Vulnerable Phase"
                ),
                div(
                  class = "metric-card-value",
                  textOutput("wicket_worst_phase")
                )
              ),
              
              div(
                class = "metric-card",
                div(
                  class = "metric-card-title",
                  "Most Vulnerable Over"
                ),
                div(
                  class = "metric-card-value",
                  textOutput("wicket_worst_over")
                )
              ),
              
              div(
                class = "metric-card",
                div(
                  class = "metric-card-title",
                  "Most Successful Bowler"
                ),
                div(
                  class = "metric-card-value",
                  textOutput("wicket_top_bowler")
                )
              )
            )
          )
        )
      )
    )
  )
)


# =========================================================
# SERVER
# =========================================================

server <- function(input, output, session) {
  
  
  # =======================================================
  # SCORE
  # =======================================================
  
  score_season_matches <- reactive({
    
    req(input$score_season)
    
    db_data |>
      
      filter(
        season == input$score_season
      ) |>
      
      group_by(
        match_id
      ) |>
      
      summarise(
        
        match_date =
          first(match_date),
        
        team_1 =
          first(
            batting_team[
              innings == 1
            ]
          ),
        
        team_2 =
          first(
            bowling_team[
              innings == 1
            ]
          ),
        
        teams =
          paste(
            team_1,
            team_2,
            sep = " vs "
          ),
        
        .groups =
          "drop"
      ) |>
      
      arrange(
        match_date,
        match_id
      )
  })
  
  
  observeEvent(
    
    input$score_season,
    
    {
      
      matches <-
        score_season_matches()
      
      choices <-
        setNames(
          
          as.character(
            matches$match_id
          ),
          
          paste0(
            matches$teams,
            " - ",
            matches$match_date
          )
        )
      
      updateSelectInput(
        
        session,
        
        inputId =
          "score_match",
        
        choices =
          choices,
        
        selected =
          as.character(
            matches$match_id[1]
          )
      )
    }
  )
  
  
  selected_match <- reactive({
    
    req(
      input$score_season,
      input$score_match
    )
    
    db_data |>
      
      filter(
        
        season ==
          input$score_season,
        
        as.character(match_id) ==
          input$score_match
      ) |>
      
      arrange(
        innings,
        delivery_order
      ) |>
      
      mutate(
        
        over_progress =
          cumulative_legal_balls / 6
      )
  })
  
  
  output$score_plot <- renderPlotly({
    
    data <-
      selected_match()
    
    req(
      nrow(data) > 0
    )
    
    team_1 <-
      data |>
      filter(
        innings == 1
      ) |>
      pull(
        batting_team
      ) |>
      first()
    
    team_2 <-
      data |>
      filter(
        innings == 1
      ) |>
      pull(
        bowling_team
      ) |>
      first()
    
    match_date <-
      first(
        data$match_date
      )
    
    p <-
      plot_ly()
    
    for (
      inn in sort(
        unique(
          data$innings
        )
      )
    ) {
      
      innings_data <-
        data |>
        filter(
          innings == inn
        ) |>
        arrange(
          delivery_order
        )
      
      team <-
        first(
          innings_data$batting_team
        )
      
      hover_text <-
        paste0(
          
          "<b>",
          innings_data$batting_team,
          "</b>",
          
          "<br><b>Innings:</b> ",
          innings_data$innings,
          
          "<br><b>Delivery:</b> ",
          innings_data$ball,
          
          "<br><b>Phase:</b> ",
          innings_data$Phase_over,
          
          "<br><br><b>Score:</b> ",
          innings_data$score,
          
          "<br><b>Runs this ball:</b> ",
          innings_data$runs_this_ball,
          
          "<br><b>Run rate:</b> ",
          round(
            innings_data$team_run_rate,
            2
          ),
          
          "<br><br><b>Batter:</b> ",
          innings_data$striker,
          
          "<br><b>Non-striker:</b> ",
          innings_data$non_striker,
          
          "<br><b>Bowler:</b> ",
          innings_data$bowler,
          
          "<br><br><b>Wicket:</b> ",
          ifelse(
            innings_data$wicket_this_ball == 1,
            "Yes",
            "No"
          )
        )
      
      p <-
        p |>
        add_trace(
          
          data =
            innings_data,
          
          x =
            ~over_progress,
          
          y =
            ~cumulative_runs,
          
          type =
            "scatter",
          
          mode =
            "lines+markers",
          
          name =
            team,
          
          text =
            hover_text,
          
          hoverinfo =
            "text",
          
          line =
            list(
              width = 3.2
            ),
          
          marker =
            list(
              size = 5
            )
        )
      
      wicket_points <-
        innings_data |>
        filter(
          wicket_this_ball == 1
        )
      
      if (
        nrow(wicket_points) > 0
      ) {
        
        wicket_hover <-
          paste0(
            
            "<b>WICKET</b>",
            
            "<br><b>Team:</b> ",
            wicket_points$batting_team,
            
            "<br><b>Delivery:</b> ",
            wicket_points$ball,
            
            "<br><b>Dismissed:</b> ",
            wicket_points$player_dismissed,
            
            "<br><b>Dismissal:</b> ",
            wicket_points$wicket_type,
            
            "<br><b>Bowler:</b> ",
            wicket_points$bowler,
            
            "<br><b>Score:</b> ",
            wicket_points$score
          )
        
        p <-
          p |>
          add_trace(
            
            data =
              wicket_points,
            
            x =
              ~over_progress,
            
            y =
              ~cumulative_runs,
            
            type =
              "scatter",
            
            mode =
              "markers",
            
            text =
              wicket_hover,
            
            hoverinfo =
              "text",
            
            marker =
              list(
                
                symbol =
                  "x",
                
                size =
                  14,
                
                color =
                  "#DC2626",
                
                line =
                  list(
                    width = 2
                  )
              ),
            
            showlegend =
              FALSE
          )
      }
      
      final_row <-
        innings_data |>
        slice_tail(
          n = 1
        )
      
      p <-
        p |>
        add_annotations(
          
          x =
            final_row$over_progress,
          
          y =
            final_row$cumulative_runs,
          
          text =
            paste0(
              
              "<b>",
              team,
              "</b><br>",
              
              final_row$score
            ),
          
          showarrow =
            TRUE,
          
          arrowhead =
            2,
          
          arrowcolor =
            "#64748B",
          
          ax =
            40,
          
          ay =
            -30
        )
    }
    
    p |>
      layout(
        
        paper_bgcolor =
          "#FFFFFF",
        
        plot_bgcolor =
          "#FBFCFD",
        
        font =
          list(
            color =
              "#1F2937",
            family =
              "Inter"
          ),
        
        shapes =
          list(
            
            list(
              
              type =
                "rect",
              
              x0 =
                0,
              
              x1 =
                6,
              
              y0 =
                0,
              
              y1 =
                1,
              
              xref =
                "x",
              
              yref =
                "paper",
              
              fillcolor =
                "rgba(14,165,233,0.30)",
              
              line =
                list(
                  width = 0
                ),
              
              layer =
                "below"
            ),
            
            list(
              
              type =
                "rect",
              
              x0 =
                6,
              
              x1 =
                16,
              
              y0 =
                0,
              
              y1 =
                1,
              
              xref =
                "x",
              
              yref =
                "paper",
              
              fillcolor =
                "rgba(148,163,184,0.30)",
              
              line =
                list(
                  width = 0
                ),
              
              layer =
                "below"
            ),
            
            list(
              
              type =
                "rect",
              
              x0 =
                16,
              
              x1 =
                20,
              
              y0 =
                0,
              
              y1 =
                1,
              
              xref =
                "x",
              
              yref =
                "paper",
              
              fillcolor =
                "rgba(239,68,68,0.30)",
              
              line =
                list(
                  width = 0
                ),
              
              layer =
                "below"
            ),
            
            list(
              
              type =
                "line",
              
              x0 =
                6,
              
              x1 =
                6,
              
              y0 =
                0,
              
              y1 =
                1,
              
              xref =
                "x",
              
              yref =
                "paper",
              
              line =
                list(
                  
                  color =
                    "rgba(71,85,105,0.65)",
                  
                  width =
                    2,
                  
                  dash =
                    "dash"
                )
            ),
            
            list(
              
              type =
                "line",
              
              x0 =
                16,
              
              x1 =
                16,
              
              y0 =
                0,
              
              y1 =
                1,
              
              xref =
                "x",
              
              yref =
                "paper",
              
              line =
                list(
                  
                  color =
                    "rgba(71,85,105,0.65)",
                  
                  width =
                    2,
                  
                  dash =
                    "dash"
                )
            )
          ),
        
        title =
          list(
            
            text =
              paste0(
                
                "<b>",
                team_1,
                " vs ",
                team_2,
                "</b>",
                
                "<br>",
                
                "<sup>",
                match_date,
                "</sup>"
              ),
            
            x =
              0.5,
            
            xanchor =
              "center",
            
            font =
              list(
                size = 20
              )
          ),
        
        xaxis =
          list(
            
            title =
              "Overs",
            
            range =
              c(
                0,
                20.5
              ),
            
            tickmode =
              "array",
            
            tickvals =
              seq(
                0,
                20,
                2
              ),
            
            ticktext =
              seq(
                0,
                20,
                2
              ),
            
            showgrid =
              TRUE,
            
            gridcolor =
              "rgba(100,116,139,0.18)",
            
            zeroline =
              FALSE
          ),
        
        yaxis =
          list(
            
            title =
              "Runs",
            
            rangemode =
              "tozero",
            
            showgrid =
              TRUE,
            
            gridcolor =
              "rgba(100,116,139,0.18)",
            
            zeroline =
              FALSE
          ),
        
        hovermode =
          "closest",
        
        legend =
          list(
            
            orientation =
              "h",
            
            x =
              0,
            
            y =
              1.12
          ),
        
        annotations =
          c(
            
            list(
              
              x =
                3,
              
              y =
                1.025,
              
              xref =
                "x",
              
              yref =
                "paper",
              
              text =
                "<b>POWERPLAY</b><br><span style='font-size:11px'>Overs 1–6</span>",
              
              showarrow =
                FALSE,
              
              font =
                list(
                  
                  size =
                    14,
                  
                  color =
                    "#0369A1"
                )
            ),
            
            list(
              
              x =
                11,
              
              y =
                1.025,
              
              xref =
                "x",
              
              yref =
                "paper",
              
              text =
                "<b>MIDDLE OVERS</b><br><span style='font-size:11px'>Overs 7–16</span>",
              
              showarrow =
                FALSE,
              
              font =
                list(
                  
                  size =
                    14,
                  
                  color =
                    "#475569"
                )
            ),
            
            list(
              
              x =
                18,
              
              y =
                1.025,
              
              xref =
                "x",
              
              yref =
                "paper",
              
              text =
                "<b>DEATH OVERS</b><br><span style='font-size:11px'>Overs 17–20</span>",
              
              showarrow =
                FALSE,
              
              font =
                list(
                  
                  size =
                    14,
                  
                  color =
                    "#B91C1C"
                )
            )
          ),
        
        margin =
          list(
            
            t =
              125,
            
            r =
              115,
            
            b =
              70,
            
            l =
              70
          )
      ) |>
      config(
        
        displaylogo =
          FALSE,
        
        responsive =
          TRUE,
        
        modeBarButtonsToRemove =
          c(
            "lasso2d",
            "select2d"
          )
      )
  })
  
  
  # =======================================================
  # SCORING RATE
  # =======================================================
  
  observeEvent(
    
    list(
      input$rate_season,
      input$rate_team
    ),
    
    {
      
      req(
        input$rate_season,
        input$rate_team
      )
      
      opponents <-
        scoring_rate_comparison |>
        filter(
          
          season ==
            input$rate_season,
          
          batting_team ==
            input$rate_team
        ) |>
        distinct(
          bowling_team
        ) |>
        arrange(
          bowling_team
        ) |>
        pull(
          bowling_team
        )
      
      updateSelectInput(
        
        session,
        
        inputId =
          "rate_opponent",
        
        choices =
          opponents,
        
        selected =
          if (
            length(opponents) > 0
          ) {
            opponents[1]
          } else {
            character(0)
          }
      )
    }
  )
  
  
  selected_rate_data <- reactive({
    
    req(
      input$rate_season,
      input$rate_team,
      input$rate_opponent
    )
    
    scoring_rate_season_over |>
      filter(
        
        season ==
          input$rate_season,
        
        batting_team ==
          input$rate_team,
        
        bowling_team ==
          input$rate_opponent
      ) |>
      arrange(
        over
      )
  })
  
  
  selected_rate_phase <- reactive({
    
    req(
      input$rate_season,
      input$rate_team,
      input$rate_opponent
    )
    
    scoring_rate_season_phase |>
      filter(
        
        season ==
          input$rate_season,
        
        batting_team ==
          input$rate_team,
        
        bowling_team ==
          input$rate_opponent
      )
  })
  
  
  output$cumulative_rr_plot <- renderPlotly({
    
    data <-
      selected_rate_data()
    
    req(
      nrow(data) > 0
    )
    
    data <-
      data |>
      arrange(
        over
      ) |>
      mutate(
        
        cumulative_total_runs =
          cumsum(total_runs),
        
        cumulative_total_legal_balls =
          cumsum(total_legal_balls),
        
        cumulative_run_rate =
          case_when(
            
            cumulative_total_legal_balls > 0 ~
              (
                cumulative_total_runs /
                  cumulative_total_legal_balls
              ) * 6,
            
            TRUE ~
              NA_real_
          ),
        
        hover_text =
          paste0(
            
            "<b>",
            batting_team,
            " vs ",
            bowling_team,
            "</b>",
            
            "<br><b>Season:</b> ",
            season,
            
            "<br><b>Over:</b> ",
            over,
            
            "<br><b>Phase:</b> ",
            Phase_over,
            
            "<br><b>Matches represented:</b> ",
            matches_played,
            
            "<br><br><b>Season Cumulative Run Rate:</b> ",
            round(
              cumulative_run_rate,
              2
            ),
            
            "<br><b>Cumulative Runs:</b> ",
            cumulative_total_runs,
            
            "<br><b>Cumulative Legal Balls:</b> ",
            cumulative_total_legal_balls,
            
            "<br><br><b>Runs in this Over:</b> ",
            total_runs,
            
            "<br><b>Extras in this Over:</b> ",
            total_extras,
            
            "<br><b>Wickets in this Over:</b> ",
            total_wickets
          )
      )
    
    plot_ly(
      
      data =
        data,
      
      x =
        ~over,
      
      y =
        ~cumulative_run_rate,
      
      type =
        "scatter",
      
      mode =
        "lines+markers",
      
      text =
        ~hover_text,
      
      hoverinfo =
        "text",
      
      line =
        list(
          width = 3
        ),
      
      marker =
        list(
          size = 6
        )
    ) |>
      layout(
        
        title =
          list(
            
            text =
              paste0(
                
                "<b>",
                input$rate_team,
                " season scoring-rate progression</b>",
                
                "<br>",
                
                "<sup>vs ",
                input$rate_opponent,
                " | Season ",
                input$rate_season,
                " | Aggregated across all matches</sup>"
              ),
            
            x =
              0.5,
            
            xanchor =
              "center"
          ),
        
        paper_bgcolor =
          "#FFFFFF",
        
        plot_bgcolor =
          "#FBFCFD",
        
        shapes =
          list(
            
            list(
              
              type =
                "rect",
              
              x0 =
                0,
              
              x1 =
                6,
              
              y0 =
                0,
              
              y1 =
                1,
              
              xref =
                "x",
              
              yref =
                "paper",
              
              fillcolor =
                "rgba(14,165,233,0.20)",
              
              line =
                list(
                  width = 0
                ),
              
              layer =
                "below"
            ),
            
            list(
              
              type =
                "rect",
              
              x0 =
                6,
              
              x1 =
                16,
              
              y0 =
                0,
              
              y1 =
                1,
              
              xref =
                "x",
              
              yref =
                "paper",
              
              fillcolor =
                "rgba(148,163,184,0.20)",
              
              line =
                list(
                  width = 0
                ),
              
              layer =
                "below"
            ),
            
            list(
              
              type =
                "rect",
              
              x0 =
                16,
              
              x1 =
                20,
              
              y0 =
                0,
              
              y1 =
                1,
              
              xref =
                "x",
              
              yref =
                "paper",
              
              fillcolor =
                "rgba(239,68,68,0.20)",
              
              line =
                list(
                  width = 0
                ),
              
              layer =
                "below"
            ),
            
            list(
              
              type =
                "line",
              
              x0 =
                6,
              
              x1 =
                6,
              
              y0 =
                0,
              
              y1 =
                1,
              
              xref =
                "x",
              
              yref =
                "paper",
              
              line =
                list(
                  
                  color =
                    "rgba(71,85,105,0.65)",
                  
                  width =
                    2,
                  
                  dash =
                    "dash"
                )
            ),
            
            list(
              
              type =
                "line",
              
              x0 =
                16,
              
              x1 =
                16,
              
              y0 =
                0,
              
              y1 =
                1,
              
              xref =
                "x",
              
              yref =
                "paper",
              
              line =
                list(
                  
                  color =
                    "rgba(71,85,105,0.65)",
                  
                  width =
                    2,
                  
                  dash =
                    "dash"
                )
            )
          ),
        
        xaxis =
          list(
            
            title =
              "Over",
            
            range =
              c(
                0,
                20.5
              ),
            
            dtick =
              1,
            
            showgrid =
              TRUE,
            
            gridcolor =
              "rgba(100,116,139,0.18)"
          ),
        
        yaxis =
          list(
            
            title =
              "Season Cumulative Run Rate",
            
            rangemode =
              "tozero",
            
            showgrid =
              TRUE,
            
            gridcolor =
              "rgba(100,116,139,0.18)"
          ),
        
        hovermode =
          "closest",
        
        showlegend =
          FALSE,
        
        margin =
          list(
            
            t =
              105,
            
            r =
              40,
            
            b =
              60,
            
            l =
              70
          )
      ) |>
      
      config(
        
        displaylogo =
          FALSE,
        
        responsive =
          TRUE,
        
        modeBarButtonsToRemove =
          c(
            "lasso2d",
            "select2d"
          )
      )
  })
  
  
  output$over_rr_plot <- renderPlotly({
    
    data <-
      selected_rate_data()
    
    req(
      nrow(data) > 0
    )
    
    data <-
      data |>
      arrange(
        over
      ) |>
      mutate(
        
        hover_text =
          paste0(
            
            "<b>",
            batting_team,
            " vs ",
            bowling_team,
            "</b>",
            
            "<br><b>Season:</b> ",
            season,
            
            "<br><b>Over:</b> ",
            over,
            
            "<br><b>Phase:</b> ",
            Phase_over,
            
            "<br><b>Matches represented:</b> ",
            matches_played,
            
            "<br><br><b>Season Over Run Rate:</b> ",
            round(
              over_run_rate,
              2
            ),
            
            "<br><b>Total Runs in Over:</b> ",
            total_runs,
            
            "<br><b>Total Legal Balls:</b> ",
            total_legal_balls,
            
            "<br><b>Total Extras:</b> ",
            total_extras,
            
            "<br><b>Total Wickets:</b> ",
            total_wickets
          )
      )
    
    plot_ly(
      
      data =
        data,
      
      x =
        ~over,
      
      y =
        ~over_run_rate,
      
      type =
        "scatter",
      
      mode =
        "lines+markers",
      
      text =
        ~hover_text,
      
      hoverinfo =
        "text",
      
      line =
        list(
          width = 3
        ),
      
      marker =
        list(
          size = 6
        )
    ) |>
      layout(
        
        title =
          list(
            
            text =
              paste0(
                
                "<b>",
                input$rate_team,
                " season over-by-over run rate</b>",
                
                "<br>",
                
                "<sup>vs ",
                input$rate_opponent,
                " | Season ",
                input$rate_season,
                " | Aggregated across all matches</sup>"
              ),
            
            x =
              0.5,
            
            xanchor =
              "center"
          ),
        
        paper_bgcolor =
          "#FFFFFF",
        
        plot_bgcolor =
          "#FBFCFD",
        
        shapes =
          list(
            
            list(
              
              type =
                "rect",
              
              x0 =
                0,
              
              x1 =
                6,
              
              y0 =
                0,
              
              y1 =
                1,
              
              xref =
                "x",
              
              yref =
                "paper",
              
              fillcolor =
                "rgba(14,165,233,0.20)",
              
              line =
                list(
                  width = 0
                ),
              
              layer =
                "below"
            ),
            
            list(
              
              type =
                "rect",
              
              x0 =
                6,
              
              x1 =
                16,
              
              y0 =
                0,
              
              y1 =
                1,
              
              xref =
                "x",
              
              yref =
                "paper",
              
              fillcolor =
                "rgba(148,163,184,0.20)",
              
              line =
                list(
                  width = 0
                ),
              
              layer =
                "below"
            ),
            
            list(
              
              type =
                "rect",
              
              x0 =
                16,
              
              x1 =
                20,
              
              y0 =
                0,
              
              y1 =
                1,
              
              xref =
                "x",
              
              yref =
                "paper",
              
              fillcolor =
                "rgba(239,68,68,0.20)",
              
              line =
                list(
                  width = 0
                ),
              
              layer =
                "below"
            ),
            
            list(
              
              type =
                "line",
              
              x0 =
                6,
              
              x1 =
                6,
              
              y0 =
                0,
              
              y1 =
                1,
              
              xref =
                "x",
              
              yref =
                "paper",
              
              line =
                list(
                  
                  color =
                    "rgba(71,85,105,0.65)",
                  
                  width =
                    2,
                  
                  dash =
                    "dash"
                )
            ),
            
            list(
              
              type =
                "line",
              
              x0 =
                16,
              
              x1 =
                16,
              
              y0 =
                0,
              
              y1 =
                1,
              
              xref =
                "x",
              
              yref =
                "paper",
              
              line =
                list(
                  
                  color =
                    "rgba(71,85,105,0.65)",
                  
                  width =
                    2,
                  
                  dash =
                    "dash"
                )
            )
          ),
        
        xaxis =
          list(
            
            title =
              "Over",
            
            range =
              c(
                0,
                20.5
              ),
            
            dtick =
              1,
            
            showgrid =
              TRUE,
            
            gridcolor =
              "rgba(100,116,139,0.18)"
          ),
        
        yaxis =
          list(
            
            title =
              "Season Run Rate in Over",
            
            rangemode =
              "tozero",
            
            showgrid =
              TRUE,
            
            gridcolor =
              "rgba(100,116,139,0.18)"
          ),
        
        hovermode =
          "closest",
        
        showlegend =
          FALSE,
        
        margin =
          list(
            
            t =
              105,
            
            r =
              40,
            
            b =
              60,
            
            l =
              70
          )
      ) |>
      
      config(
        
        displaylogo =
          FALSE,
        
        responsive =
          TRUE,
        
        modeBarButtonsToRemove =
          c(
            "lasso2d",
            "select2d"
          )
      )
  })
  
  
  output$rate_powerplay <- renderText({
    
    data <-
      selected_rate_phase() |>
      filter(
        Phase_over ==
          "Powerplay"
      )
    
    if (
      nrow(data) == 0
    ) {
      return("—")
    }
    
    sprintf(
      "%.2f",
      data$phase_run_rate[1]
    )
  })
  
  
  output$rate_middle <- renderText({
    
    data <-
      selected_rate_phase() |>
      filter(
        Phase_over ==
          "Mid-Game"
      )
    
    if (
      nrow(data) == 0
    ) {
      return("—")
    }
    
    sprintf(
      "%.2f",
      data$phase_run_rate[1]
    )
  })
  
  
  output$rate_death <- renderText({
    
    data <-
      selected_rate_phase() |>
      filter(
        Phase_over ==
          "Death"
      )
    
    if (
      nrow(data) == 0
    ) {
      return("—")
    }
    
    sprintf(
      "%.2f",
      data$phase_run_rate[1]
    )
  })
  
  
  output$rate_matches <- renderText({
    
    data <-
      selected_rate_data()
    
    if (
      nrow(data) == 0
    ) {
      return("0")
    }
    
    max(
      data$matches_played,
      na.rm = TRUE
    )
  })
  
  
  # =======================================================
  # WICKET ANALYSIS
  # =======================================================
  
  observeEvent(
    
    input$wicket_team,
    
    {
      
      req(
        input$wicket_team
      )
      
      opponents <-
        wicket_all_seasons_by_over |>
        filter(
          batting_team ==
            input$wicket_team
        ) |>
        distinct(
          bowling_team
        ) |>
        arrange(
          bowling_team
        ) |>
        pull(
          bowling_team
        )
      
      updateSelectInput(
        
        session,
        
        inputId =
          "wicket_opponent",
        
        choices =
          opponents,
        
        selected =
          if (
            length(opponents) > 0
          ) {
            opponents[1]
          } else {
            character(0)
          }
      )
    }
  )
  
  
  selected_wicket_over <- reactive({
    
    req(
      input$wicket_team,
      input$wicket_opponent
    )
    
    wicket_all_seasons_by_over |>
      filter(
        
        batting_team ==
          input$wicket_team,
        
        bowling_team ==
          input$wicket_opponent
      ) |>
      arrange(
        over
      )
  })
  
  
  selected_wicket_phase <- reactive({
    
    req(
      input$wicket_team,
      input$wicket_opponent
    )
    
    wicket_all_seasons_by_phase |>
      filter(
        
        batting_team ==
          input$wicket_team,
        
        bowling_team ==
          input$wicket_opponent
      )
  })
  
  
  selected_wicket_bowler <- reactive({
    
    req(
      input$wicket_team,
      input$wicket_opponent
    )
    
    wicket_all_seasons_by_bowler |>
      filter(
        
        batting_team ==
          input$wicket_team,
        
        bowling_team ==
          input$wicket_opponent
      ) |>
      arrange(
        desc(
          wickets_taken
        )
      )
  })
  
  
  output$wicket_over_plot <- renderPlotly({
    
    data <-
      selected_wicket_over()
    
    req(
      nrow(data) > 0
    )
    
    data <-
      data |>
      mutate(
        
        hover_text =
          paste0(
            
            "<b>Over:</b> ",
            over,
            
            "<br><b>Phase:</b> ",
            Phase_over,
            
            "<br><b>Total Wickets Lost:</b> ",
            wickets_lost,
            
            "<br><b>Matches Played:</b> ",
            matches_played,
            
            "<br><b>Wickets per Match:</b> ",
            round(
              wickets_per_match,
              2
            )
          )
      )
    
    plot_ly(
      
      data =
        data,
      
      x =
        ~over,
      
      y =
        ~wickets_lost,
      
      type =
        "bar",
      
      text =
        ~hover_text,
      
      hoverinfo =
        "text",
      
      marker =
        list(
          color = "#0F766E"
        )
    ) |>
      layout(
        
        title =
          list(
            
            text =
              paste0(
                
                "<b>Where ",
                input$wicket_team,
                " lose wickets</b>",
                
                "<br>",
                
                "<sup>vs ",
                input$wicket_opponent,
                " | All seasons</sup>"
              ),
            
            x =
              0.5,
            
            xanchor =
              "center"
          ),
        
        paper_bgcolor =
          "#FFFFFF",
        
        plot_bgcolor =
          "#FBFCFD",
        
        xaxis =
          list(
            
            title =
              "Over",
            
            dtick =
              1
          ),
        
        yaxis =
          list(
            
            title =
              "Total Wickets Lost",
            
            rangemode =
              "tozero",
            
            dtick =
              1
          ),
        
        margin =
          list(
            
            t =
              95,
            
            r =
              40,
            
            b =
              55,
            
            l =
              70
          )
      ) |>
      config(
        
        displaylogo =
          FALSE,
        
        responsive =
          TRUE
      )
  })
  
  
  output$wicket_phase_plot <- renderPlotly({
    
    data <-
      selected_wicket_phase()
    
    req(
      nrow(data) > 0
    )
    
    data <-
      data |>
      mutate(
        
        Phase_over =
          factor(
            
            Phase_over,
            
            levels =
              c(
                "Powerplay",
                "Mid-Game",
                "Death"
              )
          ),
        
        hover_text =
          paste0(
            
            "<b>Phase:</b> ",
            Phase_over,
            
            "<br><b>Total Wickets Lost:</b> ",
            wickets_lost,
            
            "<br><b>Matches Played:</b> ",
            matches_played,
            
            "<br><b>Wickets per Match:</b> ",
            round(
              wickets_per_match,
              2
            )
          )
      ) |>
      arrange(
        Phase_over
      )
    
    plot_ly(
      
      data =
        data,
      
      x =
        ~Phase_over,
      
      y =
        ~wickets_lost,
      
      type =
        "bar",
      
      text =
        ~hover_text,
      
      hoverinfo =
        "text",
      
      marker =
        list(
          color =
            c(
              "#38BDF8",
              "#94A3B8",
              "#EF4444"
            )
        )
    ) |>
      layout(
        
        title =
          list(
            
            text =
              paste0(
                
                "<b>Wickets lost by phase</b>",
                
                "<br>",
                
                "<sup>",
                input$wicket_team,
                " vs ",
                input$wicket_opponent,
                " | All seasons</sup>"
              ),
            
            x =
              0.5,
            
            xanchor =
              "center"
          ),
        
        paper_bgcolor =
          "#FFFFFF",
        
        plot_bgcolor =
          "#FBFCFD",
        
        xaxis =
          list(
            title = "Phase"
          ),
        
        yaxis =
          list(
            
            title =
              "Total Wickets Lost",
            
            rangemode =
              "tozero",
            
            dtick =
              1
          ),
        
        margin =
          list(
            
            t =
              95,
            
            r =
              40,
            
            b =
              55,
            
            l =
              70
          )
      ) |>
      config(
        
        displaylogo =
          FALSE,
        
        responsive =
          TRUE
      )
  })
  
  
  output$wicket_bowler_plot <- renderPlotly({
    
    data <-
      selected_wicket_bowler()
    
    req(
      nrow(data) > 0
    )
    
    data <-
      data |>
      mutate(
        
        hover_text =
          paste0(
            
            "<b>",
            bowler,
            "</b>",
            
            "<br><b>Total Wickets:</b> ",
            wickets_taken,
            
            "<br><b>Matches:</b> ",
            matches_played,
            
            "<br><b>Wickets per Match:</b> ",
            round(
              wickets_per_match,
              2
            ),
            
            "<br><br><b>Powerplay:</b> ",
            powerplay_wickets,
            
            "<br><b>Mid-Game:</b> ",
            middle_wickets,
            
            "<br><b>Death:</b> ",
            death_wickets
          )
      )
    
    plot_ly(
      
      data =
        data,
      
      x =
        ~wickets_taken,
      
      y =
        ~reorder(
          bowler,
          wickets_taken
        ),
      
      type =
        "bar",
      
      orientation =
        "h",
      
      text =
        ~hover_text,
      
      hoverinfo =
        "text",
      
      marker =
        list(
          color = "#0F766E"
        )
    ) |>
      layout(
        
        title =
          list(
            
            text =
              paste0(
                
                "<b>Most successful bowlers against ",
                input$wicket_team,
                "</b>",
                
                "<br>",
                
                "<sup>",
                input$wicket_opponent,
                " | All seasons</sup>"
              ),
            
            x =
              0.5,
            
            xanchor =
              "center"
          ),
        
        paper_bgcolor =
          "#FFFFFF",
        
        plot_bgcolor =
          "#FBFCFD",
        
        xaxis =
          list(
            
            title =
              "Wickets Taken",
            
            dtick =
              1
          ),
        
        yaxis =
          list(
            title = ""
          ),
        
        margin =
          list(
            
            t =
              95,
            
            r =
              40,
            
            b =
              55,
            
            l =
              165
          )
      ) |>
      config(
        
        displaylogo =
          FALSE,
        
        responsive =
          TRUE
      )
  })
  
  
  output$wicket_total <- renderText({
    
    data <-
      selected_wicket_over()
    
    sum(
      data$wickets_lost,
      na.rm = TRUE
    )
  })
  
  
  output$wicket_worst_phase <- renderText({
    
    data <-
      selected_wicket_phase()
    
    req(
      nrow(data) > 0
    )
    
    highest <-
      data |>
      arrange(
        desc(
          wickets_lost
        )
      ) |>
      slice(
        1
      )
    
    paste0(
      
      highest$Phase_over,
      
      " (",
      
      highest$wickets_lost,
      
      ")"
    )
  })
  
  
  output$wicket_worst_over <- renderText({
    
    data <-
      selected_wicket_over()
    
    req(
      nrow(data) > 0
    )
    
    highest <-
      data |>
      arrange(
        desc(
          wickets_lost
        ),
        over
      ) |>
      slice(
        1
      )
    
    paste0(
      
      "Over ",
      
      highest$over,
      
      " (",
      
      highest$wickets_lost,
      
      ")"
    )
  })
  
  
  output$wicket_top_bowler <- renderText({
    
    data <-
      selected_wicket_bowler()
    
    if (
      nrow(data) == 0
    ) {
      return("—")
    }
    
    highest <-
      data |>
      arrange(
        desc(
          wickets_taken
        )
      ) |>
      slice(
        1
      )
    
    paste0(
      
      highest$bowler,
      
      " (",
      
      highest$wickets_taken,
      
      ")"
    )
  })
}


# =========================================================
# RUN
# =========================================================

shinyApp(
  ui = ui,
  server = server
)
