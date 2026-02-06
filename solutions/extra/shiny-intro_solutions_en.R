library(shiny)
library(bslib)
library(tidyverse)

# Load the cleaned measles outbreak data
linelist <- readRDS("data/clean/moissala_data.rds")

# UI: Define the app layout and appearance
ui <- page_sidebar(
  title = "Moissala measles Outbreak",

  # Sidebar: Contains input controls for filtering and customizing
  sidebar = sidebar(
    # Date range filter for outbreak timeline
    dateRangeInput(
      "date_range",
      "Select Date Range:",
      start = min(linelist$date_onset, na.rm = TRUE),
      end = max(linelist$date_onset, na.rm = TRUE),
      min = min(linelist$date_onset, na.rm = TRUE),
      max = max(linelist$date_onset, na.rm = TRUE)
    ),

    # Dropdown to select time aggregation unit
    selectInput(
      inputId = "time_unit",
      label = "Time Unit:",
      choices = c("Day", "Week", "Month", "Year"),
      selected = "Day"
    )
  ),

  # Main content: Epicurve plot
  plotOutput("epicurve"),

  # Tabbed panels for additional analyses
  navset_tab(
    nav_panel("Age Pyramid", plotOutput("age_pyramid")),
    nav_panel("Summary Statistics", tableOutput("summary_table"))
  )
)

# Server: Define the reactive logic and outputs
server <- function(input, output, session) {
  # Reactive: Filter data based on selected date range
  filtered_data <- reactive({
    linelist |>
      filter(
        date_onset >= input$date_range[1],
        date_onset <= input$date_range[2]
      )
  })

  # Reactive: Aggregate cases by selected time unit
  plot_df <- reactive({
    filtered_data() |>
      mutate(
        agg_date = lubridate::floor_date(
          date_onset,
          unit = tolower(input$time_unit)
        )
      ) |>
      count(agg_date)
  })

  # Output: Render the epidemic curve
  output$epicurve <- renderPlot({
    # Count valid dates for caption
    n_valid <- nrow(filtered_data() |> filter(!is.na(date_onset)))

    # Create bar chart of cases over time
    plot_df() |>
      ggplot(aes(x = agg_date, y = n)) +
      geom_col(fill = "#E74C3C", color = "white", linewidth = 0.3) +
      labs(
        title = paste("Cases by", input$time_unit),
        subtitle = paste(
          "Date range:",
          format(input$date_range[1], "%b %d, %Y"),
          "to",
          format(input$date_range[2], "%b %d, %Y")
        ),
        x = paste("Date of Onset (", input$time_unit, ")", sep = ""),
        y = "Number of Cases (n)",
        caption = paste(
          "Displaying",
          n_valid,
          "cases with valid dates"
        )
      ) +
      theme_minimal()
  })

  # Reactive: Prepare data for age pyramid (remove missing values)
  pyramid_df <- reactive({
    filtered_data() |>
      filter(!is.na(age_group) & !is.na(sex)) |>
      mutate(sex = case_match(sex, "m" ~ "male", "f" ~ "female"))
  })

  # Output: Render age pyramid visualization
  output$age_pyramid <- renderPlot({
    apyramid::age_pyramid(
      data = pyramid_df(),
      age_group = "age_group",
      split_by = "sex"
    )
  })

  # Output: Render summary statistics table by age group
  output$summary_table <- renderTable({
    filtered_data() |>
      summarise(
        .by = age_group,
        `Total Cases` = n(),
        `Male (n)` = sum(sex == "m", na.rm = TRUE),
        `Male (%)` = round(sum(sex == "m", na.rm = TRUE) / n() * 100, 1),
        `Female (n)` = sum(sex == "f", na.rm = TRUE),
        `Female (%)` = round(sum(sex == "f", na.rm = TRUE) / n() * 100, 1),
        `CFR (%)` = round(
          digits = 2,
          sum(outcome == "dead", na.rm = TRUE) /
            sum(outcome %in% c("dead", "recovered"), na.rm = TRUE) *
            100
        )
      )
  })
}

# Run the application
shinyApp(ui, server)
