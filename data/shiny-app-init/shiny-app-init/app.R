library(shiny)
library(bslib)
library(tidyverse)

linelist <- readRDS(file.path("data", "clean", "moissala_data.rds"))

ui <- page_sidebar(
  title = "Moissala measles Outbreak",

  sidebar = sidebar(
    dateRangeInput(
      inputId = "date_range",
      label = "Select Date Range:",
      start = min(linelist$date_onset, na.rm = TRUE),
      end = max(linelist$date_onset, na.rm = TRUE),
      min = min(linelist$date_onset, na.rm = TRUE),
      max = max(linelist$date_onset, na.rm = TRUE)
    )
  ),
  plotOutput(
    outputId = "epicurve"
  )
)

server <- function(input, output, session) {
  filtered_data <- reactive({
    linelist |>
      filter(
        date_onset >= input$date_range[1],
        date_onset <= input$date_range[2]
      )
  })

  plot_df <- reactive({
    filtered_data() |>
      count(date_onset)
  })

  output$epicurve <- renderPlot({
    plot_df() |>
      ggplot(aes(x = date_onset, y = n)) +
      geom_col(fill = "steelblue") +
      labs(
        title = "Cases by Date of Onset",
        x = "Date of Onset",
        y = "Number of Cases"
      ) +
      theme_minimal()
  })
}

shinyApp(ui, server)
