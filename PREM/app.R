library(shiny)
library(dplyr)
library(plotly)

# -----------------------------
# UI
# -----------------------------

ui <- fluidPage(
  
  titlePanel("BBL Match Scoring Analysis"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput(
        inputId = "season",
        label = "Select Season:",
        choices = unique(over_data$season)
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
        height = "600px"
      )
      
    )
  )
)


# -----------------------------
# SERVER
# -----------------------------

server <- function(input, output, session) {
  
  
  # Update available matches when season changes
  observeEvent(input$season, {
    
    matches <- over_data |>
      filter(season == input$season) |>
      distinct(match_id) |>
      pull(match_id)
    
    updateSelectInput(
      session,
      inputId = "match",
      choices = matches
    )
    
  })
  
  
  # Filter selected match
  selected_match <- reactive({
    
    req(input$season, input$match)
    
    over_data |>
      filter(
        season == input$season,
        match_id == input$match
      )
    
  })
  
  
  # Interactive scoring comparison graph
  output$score_plot <- renderPlotly({
    
    match_data <- selected_match()
    
    plot_ly(
      data = match_data,
      x = ~over,
      y = ~cumulative_runs,
      color = ~batting_team,
      type = "scatter",
      mode = "lines+markers",
      
      text = ~paste0(
        "Team: ", batting_team,
        "<br>Over: ", over,
        "<br>Score: ", score,
        "<br>Runs this over: ", runs_in_over,
        "<br>Wickets this over: ", wickets_in_over,
        "<br>Phase: ", Phase_over
      ),
      
      hoverinfo = "text"
    ) |>
      
      layout(
        
        title = "Scoring Comparison",
        
        xaxis = list(
          title = "Over",
          dtick = 1,
          range = c(1, 20)
        ),
        
        yaxis = list(
          title = "Cumulative Runs"
        ),
        
        legend = list(
          title = list(
            text = "Team"
          )
        )
      )
    
  })
  
}


# -----------------------------
# RUN APP
# -----------------------------

shinyApp(ui = ui, server = server)