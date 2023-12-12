tweets_table_widget <- function(){
  
  shinydashboardPlus::box(
    title = h4("Tweets Tabular Analysis", align = "center"), 
    closable = FALSE, 
    width = NULL,
    status = "primary", 
    solidHeader = FALSE, 
    collapsible = TRUE,
    p(
      sidebarLayout(
        sidebarPanel(
          selectInput("tabular_state", "Select a State:", choices = NULL),  # <-- Set choices to NULL here
          actionButton("plotButton", "Generate Histogram"),
          tags$head(
            tags$style(HTML("
            .checkbox label {
                color: #EEEEEE;
            }
        "))
          ),
          uiOutput("categorySelector")
        ),
        mainPanel(
          plotOutput("topStatesPlot"),
          plotOutput("countyCategoryPlot")
        )
      )
    )
  )
}