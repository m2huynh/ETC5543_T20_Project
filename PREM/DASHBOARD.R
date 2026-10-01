library(shiny)
library(dplyr)
library(plotly)

# =========================================================
# UI
# =========================================================

ui <- fluidPage(
  
  titlePanel("BBL Match Explorer"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput(
        inputId = "season",
        label = "Select Season:",
        choices = sort(unique(db_data$season))
      ),
      
      selectInput(
        inputId = "match",
        label = "Select Match:",
        choices = NULL
      )
      
    ),
    
    mainPanel(
      
      plotlyOutput(
        outputId = "score_plot",
        height = "650px"
      )
      
    )
  )
)


# =========================================================
# SERVER
# =========================================================

server <- function(input, output, session) {
  
  
  # -------------------------------------------------------
  # Get matches for selected season
  # -------------------------------------------------------
  
  season_matches <- reactive({
    
    req(input$season)
    
    db_data |>
      filter(
        season == input$season
      ) |>
      group_by(match_id) |>
      summarise(
        
        match_date = first(match_date),
        
        team_1 = first(
          batting_team[innings == 1]
        ),
        
        team_2 = first(
          bowling_team[innings == 1]
        ),
        
        teams = paste(
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
  
  
  # -------------------------------------------------------
  # Update match dropdown
  # -------------------------------------------------------
  
  observeEvent(input$season, {
    
    matches <- season_matches()
    
    choices <- setNames(
      
      matches$match_id,
      
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
      selected = choices[1]
    )
    
  })
  
  
  # -------------------------------------------------------
  # Get selected match
  # -------------------------------------------------------
  
  selected_match <- reactive({
    
    req(
      input$season,
      input$match
    )
    
    db_data |>
      filter(
        season == input$season,
        match_id == input$match
      ) |>
      arrange(
        innings,
        delivery_order
      ) |>
      mutate(
        
        # continuous over position
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
    # Match information for graph title
    # -----------------------------------------------------
    
    team_1 <- data |>
      filter(innings == 1) |>
      pull(batting_team) |>
      first()
    
    team_2 <- data |>
      filter(innings == 1) |>
      pull(bowling_team) |>
      first()
    
    match_date <- first(data$match_date)
    
    
    # -----------------------------------------------------
    # Start plot
    # -----------------------------------------------------
    
    p <- plot_ly()
    
    
    # =====================================================
    # PHASE BACKGROUND
    # =====================================================
    
    
    # Powerplay: overs 0-6
    p <- p |>
      layout(
        shapes = list(
          
          list(
            type = "rect",
            x0 = 0,
            x1 = 6,
            y0 = 0,
            y1 = 1,
            yref = "paper",
            fillcolor = "rgba(100, 180, 255, 0.08)",
            line = list(width = 0),
            layer = "below"
          ),
          
          # Mid-Game: overs 6-16
          list(
            type = "rect",
            x0 = 6,
            x1 = 16,
            y0 = 0,
            y1 = 1,
            yref = "paper",
            fillcolor = "rgba(150, 150, 150, 0.05)",
            line = list(width = 0),
            layer = "below"
          ),
          
          # Death: overs 16-20
          list(
            type = "rect",
            x0 = 16,
            x1 = 20,
            y0 = 0,
            y1 = 1,
            yref = "paper",
            fillcolor = "rgba(255, 100, 100, 0.07)",
            line = list(width = 0),
            layer = "below"
          )
          
        )
      )
    
    
    # =====================================================
    # ADD EACH INNINGS
    # =====================================================
    
    for (inn in sort(unique(data$innings))) {
      
      innings_data <- data |>
        filter(
          innings == inn
        ) |>
        arrange(
          delivery_order
        )
      
      
      team <- first(
        innings_data$batting_team
      )
      
      
      # ---------------------------------------------------
      # Hover information
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
        
        "<br>",
        
        "<br><b>Score:</b> ",
        innings_data$score,
        
        "<br><b>Runs this ball:</b> ",
        innings_data$runs_this_ball,
        
        "<br><b>Run rate:</b> ",
        round(
          innings_data$team_run_rate,
          2
        ),
        
        "<br>",
        
        "<br><b>Batter:</b> ",
        innings_data$striker,
        
        "<br><b>Non-striker:</b> ",
        innings_data$non_striker,
        
        "<br><b>Bowler:</b> ",
        innings_data$bowler,
        
        "<br>",
        
        "<br><b>Wicket:</b> ",
        ifelse(
          innings_data$wicket_this_ball == 1,
          "Yes",
          "No"
        )
      )
      
      
      # ---------------------------------------------------
      # Score progression line
      # ---------------------------------------------------
      
      p <- p |>
        add_trace(
          
          data = innings_data,
          
          x = ~over_progress,
          y = ~cumulative_runs,
          
          type = "scatter",
          mode = "lines+markers",
          
          name = team,
          
          text = hover_text,
          hoverinfo = "text",
          
          line = list(
            width = 3
          ),
          
          marker = list(
            size = 5
          )
        )
      
      
      # ---------------------------------------------------
      # Wicket markers
      # ---------------------------------------------------
      
      wicket_data <- innings_data |>
        filter(
          wicket_this_ball == 1
        )
      
      
      if (nrow(wicket_data) > 0) {
        
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
          wicket_data$score
        )
        
        
        p <- p |>
          add_trace(
            
            data = wicket_data,
            
            x = ~over_progress,
            y = ~cumulative_runs,
            
            type = "scatter",
            mode = "markers",
            
            text = wicket_hover,
            hoverinfo = "text",
            
            marker = list(
              symbol = "x",
              size = 13,
              color = "red",
              line = list(
                width = 2
              )
            ),
            
            showlegend = FALSE
          )
      }
      
      
      # ---------------------------------------------------
      # Final score label
      # ---------------------------------------------------
      
      final_row <- innings_data |>
        slice_tail(
          n = 1
        )
      
      
      p <- p |>
        add_annotations(
          
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
          ax = 35,
          ay = -30
        )
      
    }
    
    
    # =====================================================
    # GRAPH FORMATTING
    # =====================================================
    
    p |>
      layout(
        
        title = list(
          
          text = paste0(
            "<b>Scoring Comparison</b>",
            "<br>",
            "<sup>",
            team_1,
            " vs ",
            team_2,
            " | ",
            match_date,
            "</sup>"
          )
          
        ),
        
        
        # -------------------------------------------------
        # X axis
        # -------------------------------------------------
        
        xaxis = list(
          
          title = "Overs",
          
          range = c(
            0,
            20.5
          ),
          
          tickmode = "array",
          
          tickvals = seq(
            0,
            20,
            2
          ),
          
          ticktext = seq(
            0,
            20,
            2
          ),
          
          zeroline = FALSE
        ),
        
        
        # -------------------------------------------------
        # Y axis
        # -------------------------------------------------
        
        yaxis = list(
          
          title = "Runs",
          
          rangemode = "tozero",
          
          zeroline = FALSE
        ),
        
        
        # -------------------------------------------------
        # Hover
        # -------------------------------------------------
        
        hovermode = "closest",
        
        
        # -------------------------------------------------
        # Legend
        # -------------------------------------------------
        
        legend = list(
          
          orientation = "h",
          
          x = 0,
          y = 1.12
          
        ),
        
        
        # -------------------------------------------------
        # Phase labels
        # -------------------------------------------------
        
        annotations = c(
          
          list(
            x = 3,
            y = 1.02,
            xref = "x",
            yref = "paper",
            text = "<b>Powerplay</b>",
            showarrow = FALSE
          ),
          
          list(
            x = 11,
            y = 1.02,
            xref = "x",
            yref = "paper",
            text = "<b>Mid-Game</b>",
            showarrow = FALSE
          ),
          
          list(
            x = 18,
            y = 1.02,
            xref = "x",
            yref = "paper",
            text = "<b>Death</b>",
            showarrow = FALSE
          )
          
        ),
        
        
        margin = list(
          t = 110,
          r = 80,
          b = 70,
          l = 70
        )
        
      ) |>
      
      
      # ---------------------------------------------------
    # Plotly toolbar
    # ---------------------------------------------------
    
    config(
      
      displaylogo = FALSE,
      
      modeBarButtonsToRemove = c(
        "lasso2d",
        "select2d"
      )
      
    )
    
  })
  
}


# =========================================================
# RUN APP
# =========================================================

shinyApp(
  ui = ui,
  server = server
)

