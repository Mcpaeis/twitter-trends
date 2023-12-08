library(modules) # must load
# load packages --- will use this load all the 
# packages when everything is complete
#packages.Self <- modules::use("core/libs.R")
#packages.Self$getPackages("server")

library(sf)
library(tm)
library(maps)
library(shiny)
library(readr)
library(gifski)
library(igraph)
library(ggraph)
library(tigris)
library(plotly)
library(leaflet)
library(ggplot2)
library(stringr)
library(ggthemes)
library(gganimate)
library(tidyverse)
library(wordcloud)

# source modules
source.all("modules/", grepstring="\\.R")

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output, session) {
  
  # Read and preprocess the data
  unzip("data/tweets_data_v2.csv.zip", exdir = "data")
  tweets <- read.csv("data/tweets_data_v2.csv")
  # Delete the unzipped file
  file.remove("data/tweets_data_v2.csv")
  
  # Set reactive values here
  values <- reactiveValues(current_state = "WA", state_tweets = tweets %>% 
                             filter(state_code=="WA") %>% 
                             mutate(clean_tweet = sapply(clean_tweet, split_text_into_lines, 30, USE.NAMES = F)) )
  
  select_county <- reactive({paste(input$county)})
  static_map <- reactive({input$map_type})
  
  # toast information
  toaster()
  
  # State level maps
  states_sf <- states(class = "sf")
  states_sf <- st_transform(states_sf, crs = 4326) %>% mutate(STATEFP = as.character(STATEFP))
  output$states_map <- get_states_map(states_sf)
  
  # Counties level map
  counties_sf <- counties(class = "sf")
  counties_sf <- st_transform(counties_sf, crs = 4326) %>% mutate(STATEFP = as.character(STATEFP))
  # Counties don't have STUSPS so you have to subset from the state sf
  selected_counties <- counties_sf[counties_sf$STATEFP == states_sf$STATEFP[states_sf$STUSPS=="WA"], ]
  output$counties_map <- get_counties_map(selected_counties)
  
  # Make the time series plot over time 
  output$retweets_states_plot = get_line_plot(tweets, title = "Sentiments Overtime - All States")
  output$retweets_counties_plot = get_line_plot(values$state_tweets, title = "Sentiments Overtime - All Counties", height = 320, width = 670)
  output$polarity_counties_plot = get_line_text_plot(values$state_tweets, title = "Tweets Polarity - All Counties")
  
  
  # Listen to the change in date --- not optimal this way
  # observeEvent(input$time_range, {
  # })
  
  
  # Histogram
  output$histogram <- get_histogram_map(hashtags)
  
  # Watch for click events and update accordingly
  observeEvent(input$states_map_shape_click, {
    clicked_state = input$states_map_shape_click$id

    # Select all counties corresponding to the state
    selected_counties = counties_sf[counties_sf$STATEFP == states_sf$STATEFP[states_sf$STUSPS==clicked_state], ]
    # Update the counties map to the current state
    output$counties_map = get_counties_map(selected_counties)
    
    
    # Set the reactive value
    values$current_state <- clicked_state
    values$state_tweets = tweets %>% filter(state_code==clicked_state)
    
    # Update the retweet time series plot
    output$retweets_states_plot = get_line_plot(values$state_tweets, title = paste("Sentiments Overtime - ", clicked_state, sep = ""))
    
  })
  
  observeEvent(input$counties_map_shape_click, {
    clicked_county = input$counties_map_shape_click$id
    county_tweets = values$state_tweets %>% filter(county==clicked_county)
    print(unique(county_tweets$tmonth))
    # There should be at least one tweets from that county
    if(nrow(county_tweets) < 3 || length(unique(county_tweets$tmonth)) < 3){
      toaster("This county does not currently have tweets in our database. Please select another county.")
    }else{
      county_tweets$clean_tweet = sapply(county_tweets$clean_tweet, split_text_into_lines, 30, USE.NAMES = F)
      output$retweets_counties_plot = get_line_plot(county_tweets, title = paste("Sentiments Overtime - ", clicked_county, " County", sep = ""), height = 320, width = 670)
      output$polarity_counties_plot = get_line_text_plot(county_tweets, title = "Tweets Polarity - All Counties")
    }
    
  })
  
})

return(server)