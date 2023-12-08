toaster <- function(message = paste("Data was last updated on", "20th November, 2023", sep = " ")){
  return (
    toastr_info(
      message, title = "Last Updated",
      closeButton = TRUE,
      newestOnTop = FALSE,
      progressBar = TRUE,
      position = c("bottom-full-width"),
      preventDuplicates = TRUE,
      showDuration = 400,
      hideDuration = 1000,
      timeOut = 5000,
      extendedTimeOut = 1000,
      showEasing = c("swing"),
      hideEasing = c("swing"),
      showMethod = c("fadeIn"),
      hideMethod = c("fadeOut")
    ))
}