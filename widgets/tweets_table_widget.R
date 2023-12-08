tweets_table_widget <- function(){
  
  shinydashboardPlus::box(
    title = h4("Tweets Tabular Analysis", align = "center"), 
    closable = FALSE, 
    width = NULL,
    status = "primary", 
    solidHeader = FALSE, 
    collapsible = TRUE,
    p(
      # Add your __Output here
    )
  )
}