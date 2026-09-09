#' Launch the longitudinal data review application
#'
#' Launches a Shiny application for reviewing longitudinal quantitative
#' data. The application allows users to explore individual trajectories
#' through spaghetti plots, visualise groups, filter observations by group
#' level or isolate individual IDs, visualise raw values or residuals from a
#' linear mixed-effects model, and store observations for review.
#'
#' @param df A data frame containing the longitudinal data to review,
#' with one row per observation.
#' @param qual_conv An optional character vector specifying the names of
#' variables to convert to factors before launching the application.
#' Only qualitative variables (factors or character variables) are
#' displayed as grouping variable choices in the application's user
#' interface. Defaults to NULL.
#'
#' @return This function launches a Shiny application and does not return
#' a data object.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Launch the application with the demo data
#' shiny_Lrev(longi_demo)
#'
#' # Convert selected categorical variables to factors
#' shiny_Lrev(
#' longi_demo,
#' qual_conv = c("Gender")
#' )
#' }
shiny_Lrev <- function(df,qual_conv=NULL){

# data management ----

  # Transformation des variables précisées en factor
  df <- df |> dplyr::mutate(
    dplyr::across(dplyr::all_of(qual_conv), ~ {
      lab <- attr(.x, "label")
      y <- factor(.x)
      attr(y, "label") <- lab
      y
    })
  )

# Liste de variable quali (classe factor ou character)
quali_vars <- c(names(df)[unlist(lapply(df[,1:ncol(df)],is.factor))],
                names(df)[unlist(lapply(df[,1:ncol(df)],is.character))])

# ui -----

ui <- ui_Lrev(df=df,quali_vars=quali_vars)

# server ------

server <- server_Lrev(df=df)

# lancement ----

shiny::shinyApp(ui = ui, server = server)

}

