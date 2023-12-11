library(shiny)
library(ggplot2)
library(readr)

ui <- fluidPage(
  titlePanel("LDA Output Visualization"),
  sidebarLayout(
    sidebarPanel(
      selectInput("state", "Select State", choices = c("All", "Alabama", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "District of Columbia", "Florida", "Georgia", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Luisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wyoming", "Wisconsin"))
    ),
    mainPanel(
      plotOutput("ldaPlot")
    )
  )
)

server <- function(input, output) {
  
  output$ldaPlot <- renderPlot({
    if (input$state == "All") {
      data_path <- "https://raw.githubusercontent.com/Mcpaeis/twitter-trends/master/LDA/top_terms_df_all.csv"
    } else {
      data_path <- paste0("https://raw.githubusercontent.com/Mcpaeis/twitter-trends/master/LDA/", input$state, "_lda.csv")
    }
    
    top_terms <- read_csv(data_path)
    top_terms$topic <- as.factor(top_terms$topic)
    
    ggplot(top_terms, aes(x = reorder(term, beta), y = beta, fill = topic)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      facet_wrap(~ topic, scales = "free") +
      scale_fill_viridis_d() +  # This line adds a color scale
      labs(x = "Term", y = "Probability", title = paste("Top 10 Words in Each Topic -", input$state)) +
      theme_minimal()
  })
}

shinyApp(ui = ui, server = server)
