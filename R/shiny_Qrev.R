#' Launch the quantitative data review application
#'
#' Launches a Shiny application for reviewing quantitative data.
#' The application allows users to explore the distribution of quantitative
#' variables, visualise groups, filter observations, identify potential
#' outliers, and store observations for review.
#'
#' @param df A data frame containing the quantitative data to review.
#' @param qual_conv An optional character vector specifying the names of
#'   variables to convert to factors before launching the application.
#'   Qualitative variables (factors or character variables) are displayed
#'   as grouping variable choices in the application's user interface.
#'   Defaults to `NULL`.
#' @param ID An optional character string specifying the name of the
#'   variable containing individual identifiers. This variable is excluded
#'   from the grouping variable choices. Defaults to `NULL`.
#'
#' @return This function launches a Shiny application and does not return
#'   a data object.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Launch the application with the demo data
#' shiny_Qrev(quanti_demo)
#'
#' # Convert selected categorical variables to factors
#' shiny_Qrev(
#'   quanti_demo,
#'   qual_conv = c("Gender")
#' )
#'
#' # Specify the variable containing individual identifiers
#' shiny_Qrev(
#'   quanti_demo,
#'   ID = "ID"
#' )
#' }
shiny_Qrev <- function(df,qual_conv=NULL,ID=NULL){

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

# Liste de variables quanti
quanti_vars <- names(df)[unlist(lapply(df[,1:ncol(df)],is.numeric))]

# Liste de variable quali (classe factor ou character)
quali_vars <- c(names(df)[unlist(lapply(df[,1:ncol(df)],is.factor))],
                names(df)[unlist(lapply(df[,1:ncol(df)],is.character))])

#Retrait ID
quali_vars <- quali_vars[!quali_vars %in% ID]

# ui -----

ui <- ui_Qrev(df=df,quali_vars=quali_vars,quanti_vars=quanti_vars)

# sever -----

server <- server_Qrev(df=df,quanti_vars=quanti_vars,ID=ID)

# lancement -----

shiny::shinyApp(ui = ui, server = server)

}
