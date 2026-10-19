#libraries

library(shiny)
library(dplyr)
library(plotly)
library(bslib)

#ui

ui <- page_sidebar(
  
  #dashboard title
  
  title = div(
    class = "matchcentre-title",
    span(
      "Big-Bash-League"
    ),
    
    span(
      class = "matchcentre-title-secondary",
      " Match Centre"
    )
  ),
  
  fillable = TRUE,
  
  #theme
  
  theme = bs_theme(
    version = 5,
    bg = "#F5F7FA",
    fg = "#1F2937",
    primary = "#0F766E",
    secondary = "#64748B",
    base_font = font_google("Inter"),
    heading_font = font_google("Inter")
  ),
  
  #sidebar
  
  sidebar = sidebar(
    title = "Filters",
    id = "match_filters",
    open = "closed",
    width = 320,
    uiOutput(
      "dynamic_filters"
    )
  ),
  
  #css
  
  tags$head(
    tags$style(
      HTML("
      body {
        background-color: #F5F7FA;
      }

      /* Navbar */
      .navbar {
        background:
          linear-gradient(
            90deg,
            #0F172A 0%,
            #123B39 65%,
            #0F766E 100%
          ) !important;
        border-bottom:
          3px solid #14B8A6;
        box-shadow:
          0 4px 14px rgba(15,23,42,0.18);
      }

      /* Dashboard title */
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

      /* Sidebar */
      .bslib-sidebar-layout > .sidebar {
        background-color: #FFFFFF;
        border-right:
          1px solid #E2E8F0;
        box-shadow:
          4px 0 10px rgba(0,0,0,0.04);
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
        border:
          1px solid #CBD5E1 !important;
        border-radius:
          8px !important;
        background-color:
          #FFFFFF !important;
      }

      .selectize-input.focus {
        border-color:
          #14B8A6 !important;
        box-shadow:
          0 0 0 2px rgba(20,184,166,0.12) !important;
      }

      /* Main dashboard */
      .bslib-sidebar-layout > .main {
        padding:
          14px 18px 18px 18px;
      }

      .match-shell {
        background-color: #FFFFFF;
        border:
          1px solid #E2E8F0;
        border-radius: 14px;
        overflow: hidden;
        box-shadow:
          0 8px 24px rgba(15,23,42,0.08);
      }

      /* Header */
      .match-header {
        background:
          linear-gradient(
            90deg,
            #0F172A,
            #164E4A
          );
        color: white;
        padding:
          15px 20px;
        display: flex;
        justify-content:
          space-between;
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
        padding:
          5px 11px;
        font-size: 11px;
        font-weight: 700;
        letter-spacing: 0.8px;
      }

      /* Navigation */
      .nav-tabs {
        padding-left: 14px;
        padding-right: 14px;
      }

      .nav-pills {
        padding:
          8px 14px;
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

      /* Graphs */
      .match-graph,
      .rate-graph,
      .wicket-graph,
      .pressure-graph {
        background-color: #FFFFFF;
        padding-left: 8px;
        padding-right: 8px;
      }

      /* Metric cards */
      .metric-card {
        background-color: #FFFFFF;
        border:
          1px solid #E2E8F0;
        border-radius: 10px;
        padding:
          12px 15px;
        min-height: 92px;
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

      .metric-card-detail {
        color: #64748B;
        font-size: 12px;
        margin-top: 3px;
      }

      .metric-card-detail .shiny-text-output {
        color: #64748B;
        font-size: 12px;
        font-weight: 500;
      }

      .analysis-note {
        color: #64748B;
        font-size: 12px;
        margin:
          8px 16px 8px 16px;
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
  
  #main dashboard
  
  div(
    class = "match-shell",
    
    #header
    
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
          "Big Bash League Analytics"
        )
      ),
      
      div(
        class = "match-header-badge",
        "BBL"
      )
    ),
    
    #navigation
    
    navset_card_tab(
      id = "main_analysis_tab",
      
      #phase overview
      
      nav_panel(
        "Phase Overview",
        navset_pill(
          id = "phase_tab",
          
          #score
          
          nav_panel(
            "Score",
            div(
              class = "analysis-note",
              "Select a season and match from the sidebar to explore the scoring progression of both innings."
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
          
          #scoring rate
          
          nav_panel(
            "Scoring Rate",
            navset_pill(
              id = "scoring_rate_tab",
              
              #run rate progression
              
              nav_panel(
                "Run Rate Progression",
                div(
                  class = "rate-graph",
                  plotlyOutput(
                    outputId = "cumulative_rr_plot",
                    height = "470px",
                    width = "100%"
                  )
                ),
                
                layout_columns(
                  col_widths =
                    c(
                      4,
                      4,
                      4
                    ),
                  
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
                  )
                )
              ),
              
              #over run rate
              
              nav_panel(
                "Over Run Rate",
                div(
                  class = "rate-graph",
                  plotlyOutput(
                    outputId = "over_rr_plot",
                    height = "470px",
                    width = "100%"
                  )
                ),
                
                layout_columns(
                  col_widths =
                    c(
                      3,
                      3,
                      3,
                      3
                    ),
                  
                  div(
                    class = "metric-card",
                    div(
                      class = "metric-card-title",
                      "Highest Run Rate Over"
                    ),
                    
                    div(
                      class = "metric-card-value",
                      textOutput("highest_rr_over")
                    ),
                    
                    div(
                      class = "metric-card-detail",
                      textOutput("highest_rr_detail")
                    )
                  ),
                  
                  div(
                    class = "metric-card",
                    div(
                      class = "metric-card-title",
                      "Lowest Run Rate Over"
                    ),
                    
                    div(
                      class = "metric-card-value",
                      textOutput("lowest_rr_over")
                    ),
                    
                    div(
                      class = "metric-card-detail",
                      textOutput("lowest_rr_detail")
                    )
                  ),
                  
                  div(
                    class = "metric-card",
                    div(
                      class = "metric-card-title",
                      "Most Wicket-Prone Over"
                    ),
                    
                    div(
                      class = "metric-card-value",
                      textOutput("most_wicket_over")
                    ),
                    
                    div(
                      class = "metric-card-detail",
                      textOutput("most_wicket_detail")
                    )
                  ),
                  
                  div(
                    class = "metric-card",
                    div(
                      class = "metric-card-title",
                      "Least Wicket-Prone Over"
                    ),
                    
                    div(
                      class = "metric-card-value",
                      textOutput("least_wicket_over")
                    ),
                    
                    div(
                      class = "metric-card-detail",
                      textOutput("least_wicket_detail")
                    )
                  )
                )
              )
            )
          ),
          
          #wicket analysis
          
          nav_panel(
            "Wicket Analysis",
            navset_pill(
              id = "wicket_analysis_tab",
              
              #by over
              
              nav_panel(
                "By Over",
                div(
                  class = "wicket-graph",
                  plotlyOutput(
                    outputId = "wicket_over_plot",
                    height = "520px",
                    width = "100%"
                  )
                )
              ),
              
              #by bowler
              
              nav_panel(
                "By Bowler",
                div(
                  class = "wicket-graph",
                  plotlyOutput(
                    outputId = "wicket_bowler_plot",
                    height = "520px",
                    width = "100%"
                  )
                )
              )
            )
          )
        )
      ),
      
      #batsmen pressure analysis
      
      nav_panel(
        "Batsmen Pressure Analysis",
        div(
          class = "analysis-note",
          "Compare each batter's cumulative strike rate in low-pressure and high-pressure chase situations between the selected teams across all seasons."
        ),
        
        div(
          class = "pressure-graph",
          plotlyOutput(
            outputId = "pressure_batter_plot",
            height = "560px",
            width = "100%"
          )
        )
      )
    )
  )
)

#server

server <- function(input, output, session) {
  
  #dynamic sidebar
  
  output$dynamic_filters <- renderUI({
    
    #batsmen pressure analysis
    
    if (
      !is.null(input$main_analysis_tab) &&
      input$main_analysis_tab ==
      "Batsmen Pressure Analysis"
    ) {
      tagList(
        div(
          class =
            "sidebar-section-label",
          "BATSMEN PRESSURE ANALYSIS"
        ),
        
        selectInput(
          inputId =
            "pressure_team_a",
          label =
            "Team A",
          choices =
            sort(
              unique(
                c(
                  batsmen_pressure_comparison_all$batting_team,
                  batsmen_pressure_comparison_all$bowling_team
                )
              )
            )
        ),
        
        selectInput(
          inputId =
            "pressure_team_b",
          label =
            "Team B",
          choices =
            NULL
        )
      )
      
      #score filters
      
    } else if (
      is.null(input$phase_tab) ||
      input$phase_tab ==
      "Score"
    ) {
      tagList(
        div(
          class =
            "sidebar-section-label",
          "MATCH SELECTION"
        ),
        
        selectInput(
          inputId =
            "score_season",
          label =
            "Season",
          choices =
            sort(
              unique(
                db_data$season
              )
            )
        ),
        
        selectInput(
          inputId =
            "score_match",
          label =
            "Match",
          choices =
            NULL
        )
      )
      
      #scoring rate + wicket analysis
      
    } else if (
      input$phase_tab %in%
      c(
        "Scoring Rate",
        "Wicket Analysis"
      )
      
    ) {
      tagList(
        div(
          class =
            "sidebar-section-label",
          ifelse(
            input$phase_tab ==
              "Scoring Rate",
            "SCORING RATE ANALYSIS",
            "WICKET ANALYSIS"
          )
        ),
        
        selectInput(
          inputId =
            "rate_season",
          label =
            "Season",
          choices =
            c(
              "---" = "---",
              sort(
                unique(
                  scoring_rate_comparison$season
                )
              )
            ),
          
          selected =
            "---"
        ),
        
        selectInput(
          inputId =
            "rate_team",
          label =
            "Base Team",
          choices =
            sort(
              unique(
                scoring_rate_comparison$batting_team
              )
            )
        ),
        
        selectInput(
          inputId =
            "rate_opponent",
          label =
            "Opponent",
          choices =
            NULL
        )
      )
    }
  })
  
  #score
  
  score_season_matches <- reactive({
    req(
      input$score_season
    )
    
    db_data |>
      filter(
        season ==
          input$score_season
      ) |>
      
      group_by(
        match_id
      ) |>
      
      summarise(
        match_date =
          first(
            match_date
          ),
        
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
            sep =
              " vs "
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
      req(
        nrow(matches) > 0
      )
      
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
        as.character(
          match_id
        ) ==
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
          "<br><b>Run Rate:</b> ",
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
        nrow(
          wicket_points
        ) > 0
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
              type = "rect",
              x0 = 0,
              x1 = 6,
              y0 = 0,
              y1 = 1,
              xref = "x",
              yref = "paper",
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
              type = "rect",
              x0 = 6,
              x1 = 16,
              y0 = 0,
              y1 = 1,
              xref = "x",
              yref = "paper",
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
              type = "rect",
              x0 = 16,
              x1 = 20,
              y0 = 0,
              y1 = 1,
              xref = "x",
              yref = "paper",
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
              type = "line",
              x0 = 6,
              x1 = 6,
              y0 = 0,
              y1 = 1,
              xref = "x",
              yref = "paper",
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
              type = "line",
              x0 = 16,
              x1 = 16,
              y0 = 0,
              y1 = 1,
              xref = "x",
              yref = "paper",
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
                " | Ball-by-ball scoring progression",
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
              x = 3,
              y = 1.025,
              xref = "x",
              yref = "paper",
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
              x = 11,
              y = 1.025,
              xref = "x",
              yref = "paper",
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
              x = 18,
              y = 1.025,
              xref = "x",
              yref = "paper",
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
            t = 125,
            r = 115,
            b = 70,
            l = 70
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
  
  #shared scoring / wicket filters
  
  observeEvent(
    list(
      input$rate_season,
      input$rate_team,
      input$phase_tab
    ),
    
    {
      req(
        input$rate_season,
        input$rate_team
      )
      
      if (
        input$rate_season ==
        "---"
      ) {
        opponents <-
          scoring_rate_comparison |>
          filter(
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
        
      } else {
        opponents <-
          scoring_rate_comparison |>
          filter(
            as.character(
              season
            ) ==
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
      }
      
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
  
  #scoring rate data
  
  selected_rate_data <- reactive({
    req(
      input$rate_season,
      input$rate_team,
      input$rate_opponent
    )
    
    if (
      input$rate_season ==
      "---"
    ) {
      scoring_rate_all_seasons_over |>
        filter(
          batting_team ==
            input$rate_team,
          bowling_team ==
            input$rate_opponent
        ) |>
        
        mutate(
          wickets_per_match =
            case_when(
              matches_played > 0 ~
                total_wickets /
                matches_played,
              TRUE ~
                NA_real_
            )
        ) |>
        
        arrange(
          over
        )
      
    } else {
      scoring_rate_season_over |>
        filter(
          as.character(
            season
          ) ==
            input$rate_season,
          batting_team ==
            input$rate_team,
          bowling_team ==
            input$rate_opponent
        ) |>
        
        mutate(
          wickets_per_match =
            case_when(
              matches_played > 0 ~
                total_wickets /
                matches_played,
              TRUE ~
                NA_real_
            )
        ) |>
        
        arrange(
          over
        )
    }
  })
  
  selected_rate_phase <- reactive({
    req(
      input$rate_season,
      input$rate_team,
      input$rate_opponent
    )
    
    if (
      input$rate_season ==
      "---"
    ) {
      scoring_rate_all_seasons_phase |>
        filter(
          batting_team ==
            input$rate_team,
          bowling_team ==
            input$rate_opponent
        )
      
    } else {
      scoring_rate_season_phase |>
        filter(
          as.character(
            season
          ) ==
            input$rate_season,
          batting_team ==
            input$rate_team,
          bowling_team ==
            input$rate_opponent
        )
    }
  })
  
  rate_season_label <- reactive({
    req(
      input$rate_season
    )
    
    if (
      input$rate_season ==
      "---"
    ) {
      "All Seasons"
    } else {
      paste(
        "Season",
        input$rate_season
      )
    }
  })
  
  rate_match_count <- reactive({
    data <-
      selected_rate_data()
    if (
      nrow(data) == 0
    ) {
      return(0)
    }
    
    max(
      data$matches_played,
      na.rm =
        TRUE
    )
  })
  
  #run rate progression
  
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
          cumsum(
            total_runs
          ),
        
        cumulative_total_legal_balls =
          cumsum(
            total_legal_balls
          ),
        
        cumulative_run_rate =
          case_when(
            cumulative_total_legal_balls >
              0 ~
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
            "<br><b>",
            rate_season_label(),
            "</b>",
            "<br><b>Over:</b> ",
            over,
            "<br><b>Phase:</b> ",
            Phase_over,
            "<br><b>Matches Included:</b> ",
            matches_played,
            "<br><br><b>Cumulative Run Rate:</b> ",
            round(
              cumulative_run_rate,
              2
            ),
            
            "<br><b>Cumulative Runs:</b> ",
            cumulative_total_runs,
            "<br><b>Cumulative Legal Balls:</b> ",
            cumulative_total_legal_balls,
            "<br><br><b>Runs in Over:</b> ",
            total_runs,
            "<br><b>Extras in Over:</b> ",
            total_extras,
            "<br><b>Wickets in Over:</b> ",
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
                " scoring-rate progression</b>",
                "<br>",
                "<sup>vs ",
                input$rate_opponent,
                " | ",
                rate_season_label(),
                " | ",
                rate_match_count(),
                " matches included</sup>"
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
              "Cumulative Run Rate",
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
  
  #over run rate
  
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
            "<br><b>",
            rate_season_label(),
            "</b>",
            "<br><b>Over:</b> ",
            over,
            "<br><b>Phase:</b> ",
            Phase_over,
            "<br><b>Matches Included:</b> ",
            matches_played,
            "<br><br><b>Over Run Rate:</b> ",
            round(
              over_run_rate,
              2
            ),
            
            "<br><b>Total Runs:</b> ",
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
                " over-by-over run rate</b>",
                "<br>",
                "<sup>vs ",
                input$rate_opponent,
                " | ",
                rate_season_label(),
                " | ",
                rate_match_count(),
                " matches included</sup>"
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
              "Run Rate",
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
  
  #run rate cards
  
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
  
  #over summary cards
  
  highest_rr_data <- reactive({
    data <-
      selected_rate_data() |>
      filter(
        !is.na(over_run_rate)
      )
    
    req(
      nrow(data) > 0
    )
    
    data |>
      arrange(
        desc(over_run_rate),
        over
      ) |>
      
      slice(
        1
      )
  })
  
  output$highest_rr_over <- renderText({
    data <-
      highest_rr_data()
    paste0(
      "Over ",
      data$over
    )
  })
  
  output$highest_rr_detail <- renderText({
    data <-
      highest_rr_data()
    paste0(
      sprintf(
        "%.2f",
        data$over_run_rate
      ),
      
      " RR | ",
      data$total_runs,
      " runs"
    )
  })
  
  lowest_rr_data <- reactive({
    data <-
      selected_rate_data() |>
      filter(
        !is.na(over_run_rate)
      )
    
    req(
      nrow(data) > 0
    )
    
    data |>
      arrange(
        over_run_rate,
        over
      ) |>
      
      slice(
        1
      )
  })
  
  output$lowest_rr_over <- renderText({
    data <-
      lowest_rr_data()
    paste0(
      "Over ",
      data$over
    )
  })
  
  output$lowest_rr_detail <- renderText({
    data <-
      lowest_rr_data()
    paste0(
      sprintf(
        "%.2f",
        data$over_run_rate
      ),
      
      " RR | ",
      data$total_runs,
      " runs"
    )
  })
  
  most_wicket_data <- reactive({
    data <-
      selected_rate_data() |>
      filter(
        !is.na(wickets_per_match)
      )
    
    req(
      nrow(data) > 0
    )
    
    data |>
      arrange(
        desc(wickets_per_match),
        desc(total_wickets),
        over
      ) |>
      
      slice(
        1
      )
  })
  
  output$most_wicket_over <- renderText({
    data <-
      most_wicket_data()
    paste0(
      "Over ",
      data$over
    )
  })
  
  output$most_wicket_detail <- renderText({
    data <-
      most_wicket_data()
    paste0(
      data$total_wickets,
      " wickets"
    )
  })
  
  least_wicket_data <- reactive({
    data <-
      selected_rate_data() |>
      filter(
        !is.na(wickets_per_match)
      )
    
    req(
      nrow(data) > 0
    )
    
    data |>
      arrange(
        wickets_per_match,
        total_wickets,
        over
      ) |>
      
      slice(
        1
      )
  })
  
  output$least_wicket_over <- renderText({
    data <-
      least_wicket_data()
    paste0(
      "Over ",
      data$over
    )
  })
  
  output$least_wicket_detail <- renderText({
    data <-
      least_wicket_data()
    paste0(
      data$total_wickets,
      " wickets"
    )
  })
  
  #wicket analysis data
  
  selected_wicket_data <- reactive({
    req(
      input$rate_season,
      input$rate_team,
      input$rate_opponent
    )
    
    data <-
      db_data |>
      filter(
        batting_team ==
          input$rate_team,
        bowling_team ==
          input$rate_opponent
      )
    
    if (
      input$rate_season !=
      "---"
    ) {
      data <-
        data |>
        filter(
          as.character(
            season
          ) ==
            input$rate_season
        )
    }
    
    data
  })
  
  wicket_match_count <- reactive({
    data <-
      selected_wicket_data()
    if (
      nrow(data) == 0
    ) {
      return(0)
    }
    
    n_distinct(
      data$match_id
    )
  })
  
  #wickets by over
  
  wicket_over_data <- reactive({
    data <-
      selected_wicket_data()
    req(
      nrow(data) > 0
    )
    
    data |>
      group_by(
        over,
        Phase_over
      ) |>
      
      summarise(
        total_wickets =
          sum(
            wicket_this_ball,
            na.rm = TRUE
          ),
        
        matches_included =
          n_distinct(
            match_id
          ),
        
        .groups =
          "drop"
      ) |>
      
      arrange(
        over
      )
  })
  
  output$wicket_over_plot <- renderPlotly({
    data <-
      wicket_over_data()
    req(
      nrow(data) > 0
    )
    
    data <-
      data |>
      mutate(
        hover_text =
          paste0(
            "<b>Over ",
            over,
            "</b>",
            "<br><b>Phase:</b> ",
            Phase_over,
            "<br><b>Total Wickets:</b> ",
            total_wickets,
            "<br><b>Matches Included:</b> ",
            matches_included
          )
      )
    
    plot_ly(
      data =
        data,
      x =
        ~over,
      y =
        ~total_wickets,
      type =
        "bar",
      text =
        ~hover_text,
      hoverinfo =
        "text",
      textposition =
        "none",
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
                "<b>Wickets by Over</b>",
                "<br>",
                "<sup>",
                input$rate_team,
                " batting vs ",
                input$rate_opponent,
                " | ",
                rate_season_label(),
                " | ",
                wicket_match_count(),
                " matches included</sup>"
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
            # Powerplay
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
            
            # Mid-game
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
            
            # Death
            list(
              type =
                "rect",
              x0 =
                17,
              x1 =
                20.5,
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
              "Total Wickets Lost",
            rangemode =
              "tozero",
            dtick =
              1,
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
  
  #wickets by bowler
  
  wicket_bowler_data <- reactive({
    data <-
      selected_wicket_data()
    req(
      nrow(data) > 0
    )
    
    data |>
      filter(
        wicket_this_ball == 1,
        !is.na(
          bowler
        ),
        
        !wicket_type %in%
          c(
            "run out",
            "retired hurt",
            "retired out",
            "obstructing the field"
          )
      ) |>
      
      group_by(
        bowler
      ) |>
      
      summarise(
        wickets_taken =
          n(),
        matches_included =
          n_distinct(
            match_id
          ),
        
        powerplay_wickets =
          sum(
            Phase_over ==
              "Powerplay",
            na.rm =
              TRUE
          ),
        
        middle_wickets =
          sum(
            Phase_over ==
              "Mid-Game",
            na.rm =
              TRUE
          ),
        
        death_wickets =
          sum(
            Phase_over ==
              "Death",
            na.rm =
              TRUE
          ),
        
        .groups =
          "drop"
      ) |>
      
      arrange(
        desc(
          wickets_taken
        )
      )
  })
  
  output$wicket_bowler_plot <- renderPlotly({
    data <-
      wicket_bowler_data()
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
            "<br><b>Matches Included:</b> ",
            matches_included,
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
      # Do not display text inside bars
      textposition =
        "none",
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
                input$rate_team,
                "</b>",
                "<br>",
                "<sup>",
                input$rate_opponent,
                " | ",
                rate_season_label(),
                " | ",
                wicket_match_count(),
                " matches included</sup>"
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
              1,
            rangemode =
              "tozero"
          ),
        
        yaxis =
          list(
            title =
              ""
          ),
        
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
              170
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
  # =======================================================
  #
  # BATSMEN PRESSURE ANALYSIS
  #
  # CUMULATIVE ACROSS ALL SEASONS
  #
  # =======================================================
  # =======================================================
  
  #team b filter
  
  observeEvent(
    input$pressure_team_a,
    {
      req(
        input$pressure_team_a
      )
      
      opponents <-
        batsmen_pressure_comparison_all |>
        filter(
          batting_team ==
            input$pressure_team_a |
            bowling_team ==
            input$pressure_team_a
        ) |>
        
        mutate(
          opponent =
            case_when(
              batting_team ==
                input$pressure_team_a ~
                bowling_team,
              TRUE ~
                batting_team
            )
        ) |>
        
        distinct(
          opponent
        ) |>
        
        arrange(
          opponent
        ) |>
        
        pull(
          opponent
        )
      
      updateSelectInput(
        session,
        inputId =
          "pressure_team_b",
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
  
  #selected pressure comparison
  
  selected_pressure_comparison <- reactive({
    req(
      input$pressure_team_a,
      input$pressure_team_b
    )
    
    batsmen_pressure_comparison_all |>
      filter(
        (
          batting_team ==
            input$pressure_team_a &
            bowling_team ==
            input$pressure_team_b
        ) |
          (
            batting_team ==
              input$pressure_team_b &
              bowling_team ==
              input$pressure_team_a
          )
      ) |>
      
      filter(
        !is.na(
          `strike_rate_Low Pressure`
        ),
        
        !is.na(
          `strike_rate_High Pressure`
        )
      ) |>
      
      arrange(
        desc(
          strike_rate_difference
        )
      )
  })
  
  #batter comparison graph
  
  output$pressure_batter_plot <- renderPlotly({
    data <-
      selected_pressure_comparison()
    validate(
      need(
        nrow(data) > 0,
        "No batters experienced both low-pressure and high-pressure situations for this matchup."
      )
    )
    
    data <-
      data |>
      mutate(
        batter_label =
          paste0(
            striker,
            " (",
            batting_team,
            ")"
          ),
        
        hover_low =
          paste0(
            "<b>",
            striker,
            "</b>",
            "<br><b>Team:</b> ",
            batting_team,
            "<br><b>Opponent:</b> ",
            bowling_team,
            "<br><b>Period:</b> All Seasons",
            "<br><br><b>LOW PRESSURE</b>",
            "<br><b>Strike Rate:</b> ",
            round(
              `strike_rate_Low Pressure`,
              2
            ),
            
            "<br><b>Runs:</b> ",
            `runs_Low Pressure`,
            "<br><b>Balls Faced:</b> ",
            `balls_faced_Low Pressure`,
            "<br><b>Chase Matches:</b> ",
            `chase_matches_Low Pressure`,
            "<br><br><b>High - Low SR:</b> ",
            round(
              strike_rate_difference,
              2
            )
          ),
        
        hover_high =
          paste0(
            "<b>",
            striker,
            "</b>",
            "<br><b>Team:</b> ",
            batting_team,
            "<br><b>Opponent:</b> ",
            bowling_team,
            "<br><b>Period:</b> All Seasons",
            "<br><br><b>HIGH PRESSURE</b>",
            "<br><b>Strike Rate:</b> ",
            round(
              `strike_rate_High Pressure`,
              2
            ),
            
            "<br><b>Runs:</b> ",
            `runs_High Pressure`,
            "<br><b>Balls Faced:</b> ",
            `balls_faced_High Pressure`,
            "<br><b>Chase Matches:</b> ",
            `chase_matches_High Pressure`,
            "<br><b>Average RRR:</b> ",
            round(
              `average_required_run_rate_High Pressure`,
              2
            ),
            
            "<br><b>Average Wickets in Hand:</b> ",
            round(
              `average_wickets_in_hand_High Pressure`,
              2
            ),
            
            "<br><b>Average Balls Remaining:</b> ",
            round(
              `average_balls_remaining_High Pressure`,
              1
            ),
            
            "<br><b>Average Target:</b> ",
            round(
              `average_target_High Pressure`,
              1
            ),
            
            "<br><br><b>High - Low SR:</b> ",
            round(
              strike_rate_difference,
              2
            )
          )
      )
    
    batter_order <-
      data |>
      arrange(
        strike_rate_difference
      ) |>
      
      pull(
        batter_label
      )
    
    data <-
      data |>
      mutate(
        batter_label =
          factor(
            batter_label,
            levels =
              unique(
                batter_order
              )
          )
      )
    
    plot_ly() |>
      add_trace(
        data =
          data,
        x =
          ~`strike_rate_Low Pressure`,
        y =
          ~batter_label,
        type =
          "bar",
        orientation =
          "h",
        name =
          "Low Pressure",
        text =
          ~hover_low,
        hoverinfo =
          "text",
        textposition =
          "none",
        marker =
          list(
            color =
              "#94A3B8"
          )
      ) |>
      
      add_trace(
        data =
          data,
        x =
          ~`strike_rate_High Pressure`,
        y =
          ~batter_label,
        type =
          "bar",
        orientation =
          "h",
        name =
          "High Pressure",
        text =
          ~hover_high,
        hoverinfo =
          "text",
        textposition =
          "none",
        marker =
          list(
            color =
              "#0F766E"
          )
      ) |>
      
      layout(
        barmode =
          "group",
        title =
          list(
            text =
              paste0(
                "<b>Low vs High Pressure Batting</b>",
                "<br>",
                "<sup>",
                input$pressure_team_a,
                " vs ",
                input$pressure_team_b,
                " | All Seasons</sup>"
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
              "Strike Rate",
            rangemode =
              "tozero",
            showgrid =
              TRUE,
            gridcolor =
              "rgba(100,116,139,0.18)"
          ),
        
        yaxis =
          list(
            title =
              "",
            automargin =
              TRUE
          ),
        
        legend =
          list(
            orientation =
              "h",
            x =
              0,
            y =
              1.10
          ),
        
        margin =
          list(
            t =
              105,
            r =
              40,
            b =
              60,
            l =
              210
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
}

#run app

shinyApp(
  ui = ui,
  server = server
)
