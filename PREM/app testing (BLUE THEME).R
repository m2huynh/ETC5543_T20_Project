library(shiny)
library(dplyr)
library(plotly)
library(bslib)

### BLUE THEME


# =========================================================
# UI
# =========================================================

ui <- page_sidebar(
  
  title = div(
    class = "matchcentre-title",
    span("BBL"),
    span(class = "matchcentre-title-secondary", " Match Centre")
  ),
  
  fillable = TRUE,
  
  theme = bs_theme(
    version = 5,
    bg = "#0C141F",
    fg = "#D9E2EC",
    primary = "#D8AE45",
    secondary = "#55C99A",
    base_font = font_google("Inter"),
    heading_font = font_google("Inter")
  ),
  
  
  # =======================================================
  # SIDEBAR
  # =======================================================
  
  sidebar = sidebar(
    
    title = "Match Filters",
    
    id = "match_filters",
    
    open = "closed",
    
    width = 320,
    
    div(
      class = "sidebar-section-label",
      "MATCH SELECTION"
    ),
    
    selectInput(
      inputId = "season",
      label = "Season",
      choices = sort(unique(db_data$season))
    ),
    
    selectInput(
      inputId = "match",
      label = "Match",
      choices = NULL
    )
    
  ),
  
  
  # =======================================================
  # CSS
  # =======================================================
  
  tags$head(
    
    tags$style(
      
      HTML("

        body {
          background-color: #0C141F;
        }


        .navbar {
          background:
            linear-gradient(
              90deg,
              #0C141F 0%,
              #122131 50%,
              #173246 100%
            ) !important;

          border-bottom: 2px solid #D8AE45;

          box-shadow:
            0 4px 14px rgba(0,0,0,0.35);
        }


        .matchcentre-title {
          font-size: 22px;
          font-weight: 800;
          letter-spacing: 0.4px;
        }


        .matchcentre-title > span:first-child {
          color: #D8AE45;
        }


        .matchcentre-title-secondary {
          color: #F3F6FA;
          font-weight: 650;
        }


        .bslib-sidebar-layout > .sidebar {
          background-color: #101B28;
          border-right: 1px solid #26384B;
          box-shadow: 4px 0 12px rgba(0,0,0,0.25);
        }


        .bslib-sidebar-layout .sidebar-title {
          color: #F3F6FA;
          font-size: 20px;
          font-weight: 750;
        }


        .sidebar-section-label {
          font-size: 11px;
          font-weight: 800;
          letter-spacing: 1.4px;
          color: #D8AE45;
          margin-top: 8px;
          margin-bottom: 15px;
        }


        .control-label {
          color: #B9C6D4;
          font-weight: 650;
        }


        .form-control,
        .selectize-input {
          background-color: #162536 !important;
          color: #F3F6FA !important;
          border: 1px solid #34465A !important;
          border-radius: 8px !important;
        }


        .selectize-input.focus {
          border-color: #D8AE45 !important;
          box-shadow:
            0 0 0 2px rgba(216,174,69,0.13) !important;
        }


        .selectize-dropdown {
          background-color: #162536;
          color: #F3F6FA;
          border: 1px solid #34465A;
        }


        .selectize-dropdown .active {
          background-color: #22384E;
          color: #FFFFFF;
        }


        .bslib-sidebar-layout > .main {
          padding: 14px 18px 18px 18px;
        }


        .match-shell {
          background:
            linear-gradient(
              180deg,
              #101B28 0%,
              #0C141F 100%
            );

          border: 1px solid #26384B;

          border-radius: 14px;

          overflow: hidden;

          box-shadow:
            0 10px 30px rgba(0,0,0,0.32);
        }


        .match-header {
          background:
            linear-gradient(
              90deg,
              #122131,
              #173246
            );

          color: white;

          padding: 14px 20px;

          display: flex;

          justify-content: space-between;

          align-items: center;

          border-bottom: 2px solid #D8AE45;
        }


        .match-header-left {
          display: flex;
          flex-direction: column;
        }


        .match-header-label {
          font-size: 11px;
          letter-spacing: 1.3px;
          font-weight: 800;
          color: #D8AE45;
          margin-bottom: 3px;
        }


        .match-header-title {
          font-size: 18px;
          font-weight: 750;
          color: #F3F6FA;
        }


        .match-header-badge {
          background-color: rgba(85,201,154,0.10);
          border: 1px solid rgba(85,201,154,0.40);
          color: #86E0BB;
          border-radius: 18px;
          padding: 5px 11px;
          font-size: 11px;
          font-weight: 700;
          letter-spacing: 0.8px;
        }


        .match-tabs {
          display: flex;
          align-items: center;

          background-color: #111D2A;

          border-bottom: 1px solid #26384B;

          padding: 0 14px;
        }


        .match-tab {
          padding: 11px 16px;

          font-size: 13px;

          font-weight: 700;

          color: #8FA1B5;

          border-bottom: 3px solid transparent;
        }


        .match-tab-active {
          color: #F3F6FA;

          border-bottom: 3px solid #D8AE45;
        }


        .match-graph {
          background-color: #0C141F;
        }


        .sidebar-toggle {
          border:
            1px solid rgba(255,255,255,0.20) !important;

          color:
            white !important;
        }

      ")
      
    )
    
  ),
  
  
  # =======================================================
  # MATCH CENTRE
  # =======================================================
  
  div(
    
    class = "match-shell",
    
    
    # -----------------------------------------------------
    # HEADER
    # -----------------------------------------------------
    
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
          "Scoring Comparison"
        )
        
      ),
      
      div(
        class = "match-header-badge",
        "BBL"
      )
      
    ),
    
    
    # -----------------------------------------------------
    # TABS
    # -----------------------------------------------------
    
    div(
      
      class = "match-tabs",
      
      div(
        class = "match-tab match-tab-active",
        "Score"
      ),
      
      div(
        class = "match-tab",
        "Scoring Rate"
      ),
      
      div(
        class = "match-tab",
        "Wicket Probability"
      )
      
    ),
    
    
    # -----------------------------------------------------
    # GRAPH
    # -----------------------------------------------------
    
    div(
      
      class = "match-graph",
      
      plotlyOutput(
        outputId = "score_plot",
        height = "calc(100vh - 215px)",
        width = "100%"
      )
      
    )
    
  )
  
)



# =========================================================
# SERVER
# =========================================================

server <- function(input, output, session) {
  
  
  # =======================================================
  # MATCHES FOR SELECTED SEASON
  # =======================================================
  
  season_matches <- reactive({
    
    req(input$season)
    
    
    db_data |>
      
      filter(
        season == input$season
      ) |>
      
      group_by(match_id) |>
      
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
        
        .groups = "drop"
        
      ) |>
      
      arrange(
        match_date,
        match_id
      )
    
  })
  
  
  
  # =======================================================
  # UPDATE MATCH DROPDOWN
  # =======================================================
  
  observeEvent(input$season, {
    
    matches <- season_matches()
    
    
    choices <- setNames(
      
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
      
      inputId = "match",
      
      choices = choices,
      
      selected =
        as.character(
          matches$match_id[1]
        )
      
    )
    
  })
  
  
  
  # =======================================================
  # SELECTED MATCH
  # =======================================================
  
  selected_match <- reactive({
    
    req(
      input$season,
      input$match
    )
    
    
    db_data |>
      
      filter(
        
        season == input$season,
        
        as.character(match_id) ==
          input$match
        
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
  
  
  
  # =======================================================
  # SCORE PROGRESSION GRAPH
  # =======================================================
  
  output$score_plot <- renderPlotly({
    
    data <- selected_match()
    
    
    req(
      nrow(data) > 0
    )
    
    
    
    # -----------------------------------------------------
    # MATCH INFORMATION
    # -----------------------------------------------------
    
    team_1 <- data |>
      
      filter(
        innings == 1
      ) |>
      
      pull(
        batting_team
      ) |>
      
      first()
    
    
    
    team_2 <- data |>
      
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
    
    
    
    # -----------------------------------------------------
    # START PLOT
    # -----------------------------------------------------
    
    p <- plot_ly()
    
    
    
    # -----------------------------------------------------
    # INNINGS VALUES
    # -----------------------------------------------------
    
    innings_values <-
      sort(
        unique(
          data$innings
        )
      )
    
    
    
    # -----------------------------------------------------
    # INNINGS COLOURS
    # -----------------------------------------------------
    
    line_colors <- c(
      "#4DA3FF",
      "#F4C95D"
    )
    
    
    
    # -----------------------------------------------------
    # FINAL SCORE ANNOTATIONS
    # -----------------------------------------------------
    
    final_score_annotations <- list()
    
    
    
    # =====================================================
    # PHASE BACKGROUNDS + DIVIDERS
    # =====================================================
    
    phase_shapes <- list(
      
      
      # ---------------------------------------------------
      # POWERPLAY
      # ---------------------------------------------------
      
      list(
        
        type = "rect",
        
        x0 = 0,
        x1 = 6,
        
        y0 = 0,
        y1 = 1,
        
        xref = "x",
        yref = "paper",
        
        fillcolor =
          "rgba(216,174,69,0.055)",
        
        line = list(
          width = 0
        ),
        
        layer = "below"
        
      ),
      
      
      # ---------------------------------------------------
      # MIDDLE OVERS
      # ---------------------------------------------------
      
      list(
        
        type = "rect",
        
        x0 = 6,
        x1 = 16,
        
        y0 = 0,
        y1 = 1,
        
        xref = "x",
        yref = "paper",
        
        fillcolor =
          "rgba(169,183,199,0.025)",
        
        line = list(
          width = 0
        ),
        
        layer = "below"
        
      ),
      
      
      # ---------------------------------------------------
      # DEATH OVERS
      # ---------------------------------------------------
      
      list(
        
        type = "rect",
        
        x0 = 16,
        x1 = 20,
        
        y0 = 0,
        y1 = 1,
        
        xref = "x",
        yref = "paper",
        
        fillcolor =
          "rgba(85,201,154,0.045)",
        
        line = list(
          width = 0
        ),
        
        layer = "below"
        
      ),
      
      
      # ---------------------------------------------------
      # POWERPLAY / MIDDLE DIVIDER
      # ---------------------------------------------------
      
      list(
        
        type = "line",
        
        x0 = 6,
        x1 = 6,
        
        y0 = 0,
        y1 = 1,
        
        xref = "x",
        yref = "paper",
        
        line = list(
          
          color =
            "rgba(216,174,69,0.35)",
          
          width = 1,
          
          dash = "dot"
          
        )
        
      ),
      
      
      # ---------------------------------------------------
      # MIDDLE / DEATH DIVIDER
      # ---------------------------------------------------
      
      list(
        
        type = "line",
        
        x0 = 16,
        x1 = 16,
        
        y0 = 0,
        y1 = 1,
        
        xref = "x",
        yref = "paper",
        
        line = list(
          
          color =
            "rgba(85,201,154,0.35)",
          
          width = 1,
          
          dash = "dot"
          
        )
        
      )
      
    )
    
    
    
    # =====================================================
    # ADD EACH INNINGS
    # =====================================================
    
    for (
      idx in seq_along(
        innings_values
      )
    ) {
      
      
      inn <-
        innings_values[idx]
      
      
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
      
      
      
      # ---------------------------------------------------
      # LINE COLOUR
      # ---------------------------------------------------
      
      line_color <-
        
        line_colors[
          ((idx - 1) %% length(line_colors)) + 1
        ]
      
      
      
      # ---------------------------------------------------
      # NORMAL BALL HOVER
      # ---------------------------------------------------
      
      hover_text <- paste0(
        
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
      
      
      
      # ---------------------------------------------------
      # SCORE PROGRESSION LINE
      # ---------------------------------------------------
      
      p <- p |>
        
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
              
              width = 3,
              
              color =
                line_color
              
            ),
          
          marker =
            list(
              
              size = 4.5,
              
              color =
                line_color
              
            ),
          
          showlegend =
            FALSE
          
        )
      
      
      
      # ===================================================
      # WICKETS
      # ===================================================
      
      wicket_data <-
        
        innings_data |>
        
        filter(
          wicket_this_ball == 1
        )
      
      
      
      if (
        nrow(wicket_data) > 0
      ) {
        
        
        wicket_hover <- paste0(
          
          "<b>WICKET</b>",
          
          "<br><b>Team:</b> ",
          wicket_data$batting_team,
          
          "<br><b>Delivery:</b> ",
          wicket_data$ball,
          
          "<br><b>Dismissed:</b> ",
          wicket_data$player_dismissed,
          
          "<br><b>Dismissal:</b> ",
          wicket_data$wicket_type,
          
          "<br><b>Bowler:</b> ",
          wicket_data$bowler,
          
          "<br><b>Score:</b> ",
          wicket_data$score,
          
          "<br><b>Phase:</b> ",
          wicket_data$Phase_over
          
        )
        
        
        
        p <- p |>
          
          add_trace(
            
            data =
              wicket_data,
            
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
            
            showlegend =
              FALSE,
            
            marker =
              list(
                
                symbol =
                  "x",
                
                size =
                  12,
                
                color =
                  "#F06464",
                
                line =
                  list(
                    width = 2
                  )
                
              )
            
          )
        
      }
      
      
      
      # ===================================================
      # FINAL SCORE LABEL
      # ===================================================
      
      final_row <-
        
        innings_data |>
        
        slice_tail(
          n = 1
        )
      
      
      
      # opposite label direction for the two innings
      label_ay <-
        
        if (
          idx == 1
        ) {
          
          -34
          
        } else {
          
          34
          
        }
      
      
      
      final_score_annotations[[length(final_score_annotations) + 1]] <- list(
        
        x = final_row$over_progress,
        
        y = final_row$cumulative_runs,
        
        text = paste0(
          "<b>",
          team,
          "</b><br>",
          final_row$score
        ),
        
        showarrow = TRUE,
        
        arrowhead = 2,
        
        arrowcolor = line_color,
        
        ax = -65,
        
        ay = label_ay,
        
        bgcolor = "rgba(12,20,31,0.92)",
        
        bordercolor = line_color,
        
        borderwidth = 1,
        
        borderpad = 5,
        
        font = list(
          color = "#F3F6FA",
          size = 11
        )
        
      )
      
    }
    
    
    
    # =====================================================
    # PHASE LABELS
    # =====================================================
    
    phase_annotations <- list(
      
      
      # ---------------------------------------------------
      # POWERPLAY
      # ---------------------------------------------------
      
      list(
        
        x = 3,
        
        y = 0.985,
        
        xref = "x",
        
        yref = "paper",
        
        text =
          "POWERPLAY",
        
        showarrow =
          FALSE,
        
        font =
          list(
            
            color =
              "#D8AE45",
            
            size =
              10
            
          )
        
      ),
      
      
      # ---------------------------------------------------
      # MIDDLE OVERS
      # ---------------------------------------------------
      
      list(
        
        x = 11,
        
        y = 0.985,
        
        xref = "x",
        
        yref = "paper",
        
        text =
          "MIDDLE OVERS",
        
        showarrow =
          FALSE,
        
        font =
          list(
            
            color =
              "#A9B7C7",
            
            size =
              10
            
          )
        
      ),
      
      
      # ---------------------------------------------------
      # DEATH OVERS
      # ---------------------------------------------------
      
      list(
        
        x = 18,
        
        y = 0.985,
        
        xref = "x",
        
        yref = "paper",
        
        text =
          "DEATH OVERS",
        
        showarrow =
          FALSE,
        
        font =
          list(
            
            color =
              "#55C99A",
            
            size =
              10
            
          )
        
      )
      
    )
    
    
    
    # =====================================================
    # FINAL PLOT LAYOUT
    # =====================================================
    
    p |>
      
      layout(
        
        
        # -------------------------------------------------
        # TRANSPARENT BACKGROUND
        # -------------------------------------------------
        
        paper_bgcolor =
          "rgba(0,0,0,0)",
        
        plot_bgcolor =
          "rgba(0,0,0,0)",
        
        
        
        # -------------------------------------------------
        # FONT
        # -------------------------------------------------
        
        font = list(
          
          family =
            "-apple-system, BlinkMacSystemFont, Segoe UI, sans-serif",
          
          color =
            "#D9E2EC",
          
          size =
            11
          
        ),
        
        
        
        # -------------------------------------------------
        # PHASE SHAPES
        # -------------------------------------------------
        
        shapes =
          phase_shapes,
        
        
        
        # -------------------------------------------------
        # X AXIS
        # -------------------------------------------------
        
        xaxis = list(
          
          title = list(
            
            text =
              "Overs completed",
            
            font = list(
              
              color =
                "#B9C6D4",
              
              size =
                12
              
            )
            
          ),
          
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
              by = 2
            ),
          
          ticktext =
            as.character(
              seq(
                0,
                20,
                by = 2
              )
            ),
          
          tickfont =
            list(
              color = "#9EADBE"
            ),
          
          gridcolor =
            "rgba(152,168,186,0.13)",
          
          zeroline =
            FALSE,
          
          showline =
            TRUE,
          
          linecolor =
            "#34465A",
          
          ticks =
            "outside",
          
          tickcolor =
            "#52657A"
          
        ),
        
        
        
        # -------------------------------------------------
        # Y AXIS
        # -------------------------------------------------
        
        yaxis = list(
          
          title = list(
            
            text =
              "Cumulative runs",
            
            font =
              list(
                
                color =
                  "#B9C6D4",
                
                size =
                  12
                
              )
            
          ),
          
          rangemode =
            "tozero",
          
          tickfont =
            list(
              color = "#9EADBE"
            ),
          
          gridcolor =
            "rgba(152,168,186,0.13)",
          
          zeroline =
            FALSE,
          
          showline =
            FALSE
          
        ),
        
        
        
        # -------------------------------------------------
        # HOVER
        # -------------------------------------------------
        
        hovermode =
          "closest",
        
        
        
        # -------------------------------------------------
        # LEGEND
        # -------------------------------------------------
        
        showlegend =
          FALSE,
        
        
        
        # -------------------------------------------------
        # ANNOTATIONS
        # -------------------------------------------------
        
        annotations =
          c(
            
            phase_annotations,
            
            final_score_annotations
            
          ),
        
        
        
        # -------------------------------------------------
        # MARGINS
        # -------------------------------------------------
        
        margin =
          list(
            
            t = 35,
            
            r = 100,
            
            b = 60,
            
            l = 65
            
          )
        
      ) |>
      
      
      # ===================================================
    # PLOTLY CONFIG
    # ===================================================
    
    config(
      
      displaylogo =
        FALSE,
      
      modeBarButtonsToRemove =
        c(
          "lasso2d",
          "select2d"
        ),
      
      displayModeBar =
        "hover",
      
      responsive =
        TRUE
      
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