check_box_input_widget <- function(sentiment_choices){
  ipt = checkboxGroupInput(
    session$ns("sentiments"), "Select Sentiments:", choices = sentiment_choices, selected = sentiment_choices)
  return(ipt)
}