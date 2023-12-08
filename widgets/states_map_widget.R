states_map_widget <- function(){
  
  shinydashboardPlus::box(
    title = h4("US Trend Map", align = "center"), 
    closable = FALSE, 
    width = NULL,
    status = "primary", 
    solidHeader = FALSE, 
    collapsible = TRUE,
    p(
      fluidRow(
        column(
          width = 6,
          addSpinner(leafletOutput("states_map", height = "500px"), spin = "double-bounce", color = "red")
        ),
        column(
          width = 6,
          addSpinner(imageOutput("retweets_states_plot", height = "500px"), spin = "dots", color = "red"),
          # Time Slider Input
          sliderInput("time_range","Select Time Range:", min = as.POSIXct("2009-01-01"), max = as.POSIXct("2009-12-31"),
                      value = c(as.POSIXct("2009-01-01"), as.POSIXct("2009-12-31")),
                      timeFormat = "%Y-%m-%d")
        )
      )
      
    )
  )
}