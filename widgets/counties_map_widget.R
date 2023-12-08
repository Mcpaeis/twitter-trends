counties_map_widget <- function(){
  
  shinydashboardPlus::box(
    title = h4("Counties Trend Map", align = "center"), 
    closable = FALSE, 
    width = NULL,
    status = "primary", 
    solidHeader = FALSE, 
    collapsible = TRUE,
    p(
      fluidRow(
        column(
          width = 6,
          addSpinner(leafletOutput("counties_map", height = "700px"), spin = "double-bounce", color = "red")
        ),
        column(
          width = 6,
          fluidRow( addSpinner(imageOutput("retweets_counties_plot", height = "320px"), spin = "dots", color = "red") ),
          vs_box(height = 1),
          fluidRow( addSpinner(plotlyOutput("polarity_counties_plot", width = "98%", height = "350px"), spin = "double-bounce", color = "red") )
          )
      )
    )
  )
}