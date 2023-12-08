library(dplyr)
library(tm)
library(tidyr)
library(readr)
library(tidytext)
library(topicmodels)
library(ggplot2)

# Create a mapping of state abbreviations to full names
state_map <- c("AL" = "Alabama", "AK" = "Alaska", "AZ" = "Arizona", "AR" = "Arkansas", "CA" = "California", 
               "CO" = "Colorado", "CT" = "Connecticut", "DE" = "Delaware", "FL" = "Florida", "GA" = "Georgia", 
               "HI" = "Hawaii", "ID" = "Idaho", "IL" = "Illinois", "IN" = "Indiana", "IA" = "Iowa", 
               "KS" = "Kansas", "KY" = "Kentucky", "LA" = "Louisiana", "ME" = "Maine", "MD" = "Maryland", 
               "MA" = "Massachusetts", "MI" = "Michigan", "MN" = "Minnesota", "MS" = "Mississippi", "MO" = "Missouri", 
               "MT" = "Montana", "NE" = "Nebraska", "NV" = "Nevada", "NH" = "New Hampshire", "NJ" = "New Jersey", 
               "NM" = "New Mexico", "NY" = "New York", "NC" = "North Carolina", "ND" = "North Dakota", "OH" = "Ohio", 
               "OK" = "Oklahoma", "OR" = "Oregon", "PA" = "Pennsylvania", "RI" = "Rhode Island", "SC" = "South Carolina", 
               "SD" = "South Dakota", "TN" = "Tennessee", "TX" = "Texas", "UT" = "Utah", "VT" = "Vermont", 
               "VA" = "Virginia", "WA" = "Washington", "WV" = "West Virginia", "WI" = "Wisconsin", "WY" = "Wyoming", 
               "DC" = "District of Columbia")

# Define a function to process a batch of data
process_batch <- function(batch_data) {
  # Replace state abbreviations with full names
  batch_data$state <- state_map[batch_data$state]
  
  # Tokenize and remove stopwords, include state in the count
  data_tokens <- batch_data %>%
    unnest_tokens(word, tweet) %>%
    anti_join(get_stopwords()) %>%
    count(state, tweet_id, word, sort = TRUE) %>%
    filter(!word %in% c("http", "bit.ly"), !grepl("^[0-9]+$", word)) %>%
    filter(n > 0)
  
  # Filter out empty documents
  empty_docs <- setdiff(batch_data$tweet_id, data_tokens$tweet_id)
  batch_data <- batch_data %>% filter(!(tweet_id %in% empty_docs))
  
  # Initialize an empty data frame to store results
  combined_data <- data.frame()
  
  # Process each state separately
  states_list <- unique(batch_data$state)
  for(state in states_list) {
    state_data <- data_tokens %>% filter(state == state)
    if(nrow(state_data) > 0) {
      dtm_data <- state_data %>% cast_dtm(document = tweet_id, term = word, value = n)
      lda_model <- LDA(dtm_data, k = 5) # Reduced number of topics
      topic_terms <- tidy(lda_model, matrix = "beta")
      top_terms <- topic_terms %>%
        group_by(topic) %>%
        top_n(10, beta) %>%
        ungroup() %>%
        arrange(topic, desc(beta))
      top_terms$state <- state
      # Combine data for all states
      combined_data <- rbind(combined_data, top_terms)
    }
  }
  
  # Return the combined data
  return(combined_data)
}

# Define a chunk_processor function
chunk_processor <- function(chunk, pos) {
  process_batch(chunk)
}

# Load tweets data in chunks and apply the function to each batch of data
chunk_size <- 10000  # Adjust this size based on your system's memory capacity
all_data <- read_csv_chunked("C:/Users/Philip/Downloads/tweets_data.csv", chunk_processor, chunk_size = chunk_size, col_types = cols())

# Write the combined data to a CSV file
write.csv(all_data, "C:/Users/Philip/Downloads/combined_state_topics.csv", row.names = FALSE)
