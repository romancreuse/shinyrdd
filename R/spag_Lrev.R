# formule pour residus

#' Build the linear mixed-effects model formula
#'
#' Internal function used by [spag_Lrev()] to construct the formula
#' used to calculate longitudinal residuals.
#'
#' @param df A data frame containing the longitudinal data.
#' @param x The name of the response variable, provided as a character string.
#' @param time The name of the time variable, provided as a character string.
#' @param ID The name of the subject identifier variable,
#'   provided as a character string.
#'
#' @return A character string containing the model formula.
#'
#' @keywords internal
.mixed_formula <- function(df,x,time,ID){
  paste0(
    x,
    " ~ ",
    time,
    " + (",
    ifelse(is.numeric(df[[time]]),time,"1"),
    " | ",
    ID,
    ")"
  )
}

# Jeu filtre
#' Prepare data for a longitudinal spaghetti plot
#'
#' Internal function used by [spag_Lrev()] to filter and prepare the data
#' before generating a longitudinal spaghetti plot.
#'
#' When a grouping variable is specified, only the requested group levels
#' are retained. Rows with missing values in the variable of interest or
#' the time variable are removed. Depending on `y_type`, residuals from a
#' linear mixed-effects model are subsequently calculated, and specific
#' subjects can be isolated.
#'
#' @param df A data frame containing the longitudinal data.
#' @param x The name of the variable to be displayed on the y-axis,
#'   provided as a character string.
#' @param time The name of the time variable, provided as a character string.
#' @param ID The name of the subject identifier variable,
#'   provided as a character string.
#' @param group An optional qualitative grouping variable, provided as a
#'   character string. Defaults to `"Aucune"` (none).
#' @param incl An optional character vector specifying the levels of `group`
#'   to retain. Defaults to `NULL`.
#' @param isol An optional character vector specifying the IDs of subjects
#'   to retain. Defaults to `"Aucune"` (none).
#' @param y_type Specifies whether raw values (`"Valeurs brutes"`) or residuals (`"Résidus"`) should be used.
#'   Defaults to `"Valeurs brutes"`.
#'
#' @return A data frame containing the data prepared for [spag_Lrev()].
#'
#' @keywords internal
.prepare_spag_data <- function(df,
                         x,
                         time,
                         ID,
                         group="Aucune",
                         incl=NULL,
                         isol="Aucune",
                         y_type="Valeurs brutes"
                         )
  {

  temp <- df

  if(group!="Aucune"&!is.null(incl)){

    temp <- temp |> dplyr::filter(.data[[group]] %in% incl)

  }

  temp <- temp |> dplyr::filter(
    !is.na(.data[[x]]) & !is.na(.data[[time]])
  )

  # Remplacement de la variable a investiguer par les residus si y_type = Residus
  if(y_type=="R\u00e9sidus"){

    fit <- lme4::lmer(
      stats::as.formula(
      .mixed_formula(df=df,
                    x=x,
                    time=time,
                    ID=ID)
      ),
      data = temp)

    temp$residuals <- stats::resid(fit)

  }

  if(isol!="Aucune"){

    temp <- temp |>
      dplyr::filter(.data[[ID]] %in% isol)

  }

  temp

}

# Spaghetti plot
#' Spaghetti plot for longitudinal data review
#'
#' Creates a longitudinal spaghetti plot showing individual trajectories
#' over time. Observations can be displayed as raw values or as residuals
#' from a linear mixed-effects model. Individuals can optionally be
#' selected or filtered according to a grouping variable.
#'
#' @param df A data frame containing the longitudinal data, meaning 1 line = 1 observation.
#' @param x The name of the variable to be displayed on the y-axis,
#'   provided as a character string.
#' @param time The name of the time variable, provided as a character string. The time variable should be either a numeric variable or an ordered factor.
#' @param ID The name of the subject identifier variable,
#'   provided as a character string.
#' @param group An optional qualitative grouping variable, provided as a
#'   character string. Defaults to `"Aucune"` (none).
#' @param incl An optional character vector specifying the levels of `group`
#'   to include in the plot. Defaults to `NULL`.
#' @param isol An optional character vector specifying the IDs of subjects
#'   to isolate. Defaults to `"Aucune"` (none).
#' @param y_type Specifies whether to display `"Valeurs brutes"` (raw values)
#'   or `"Résidus"` (residuals from a linear mixed-effects model). The mixed model is specified after the filtering by `incl` and before the filtering by `isol` but is not stratified by the `group`.
#'   If `time` is a numeric variable, random effects are applied to the intercept and to `time`. If time is an ordered factor only a random intercept is applied.
#'   Defaults to `"Valeurs brutes"`.
#' @param ylim An optional numeric vector of length two specifying the limits
#'   of the y-axis. Only applied when `y_type = "Valeurs brutes"`.
#' @param xlim An optional numeric vector of length two specifying the limits
#'   of the x-axis. Only applied when `time` is numeric.
#' @param alpha The transparency of the points and trajectories.
#'   Defaults to `0.7`.
#' @param base_color A ggplot2 color scale used to customize the color palette
#'   when no grouping variable is specified. Defaults to
#'   [ggplot2::scale_color_grey()] with start = `0.2`, end = `0.8`.
#' @param group_color A ggplot2 color scale used to customize the color palette
#'   when a grouping variable is specified. Defaults to
#'   [ggplot2::scale_color_viridis_d()].
#' @param text_size The base text size of the ggplot2 theme.
#'   Defaults to `11`.
#'
#' @return A ggplot2 object.
#' @export
#'
#' @examples
#' # Visualise individual trajectories over time
#' spag_Lrev(
#'   df = longi_demo,
#'   x = "Score",
#'   time = "Time",
#'   ID = "ID"
#' )
#'
#' # Also works with discrete time variables
#' spag_Lrev(
#'   df = longi_demo,
#'   x = "Score",
#'   time = "Visit",
#'   ID = "ID"
#' )
#'
#' # Visualise trajectories by center and focus on a plot area
#' spag_Lrev(
#'   df = longi_demo,
#'   x = "Score",
#'   time = "Time",
#'   ID = "ID",
#'   group = "Center",
#'   xlim=c(90,180),
#'   ylim=c(10,75)
#' )
#'
#' # Display residuals from a linear mixed-effects model
#' spag_Lrev(
#'   df = longi_demo,
#'   x = "Score",
#'   time = "Time",
#'   ID = "ID",
#'   y_type = "R\u00e9sidus"
#' )
spag_Lrev <- function(df,
                    x,
                    time,
                    ID,
                    group="Aucune",
                    incl=NULL,
                    isol="Aucune",
                    y_type="Valeurs brutes",
                    ylim=NULL,
                    xlim=NULL,
                    alpha=0.7,
                    base_color=ggplot2::scale_color_grey(start = 0.2, end = 0.8),
                    group_color=ggplot2::scale_color_viridis_d(),
                    text_size=11) {

  df_plot <- .prepare_spag_data(
    df = df,
    x = x,
    time = time,
    ID = ID,
    group = group,
    incl = incl,
    isol = isol,
    y_type = y_type
  )

  # Var y en foncttions residus/brut
  y_var <- if (y_type == "R\u00e9sidus") {
    "residuals"
  } else {
    x
  }

  # Labels y en fonction residus/non
  y_lab <- if (y_type == "R\u00e9sidus") {
    paste("Ecart aux valeurs pr\u00e9dites de ",choice_from_label(df, x))
  } else {
    choice_from_label(df, x)
  }

  # Couleurs en fonction groupe/non
  color <- if(group=="Aucune"){
    ID
  } else {
    group
  }



  p <- ggplot2::ggplot(df_plot,
              ggplot2::aes( x = .data[[time]],
                   y = .data[[y_var]],
                   group = .data[[ID]],
                   color = .data[[color]],
                   key = .data[[ID]],
                   text = paste0(
                     "ID : ", .data[[ID]],
                     "<br>Temps : ", .data[[time]],
                     paste0("<br>",y_lab," : "), .data[[y_var]])
              )
  ) +
    ggplot2::geom_point(alpha=alpha) +
    ggplot2::geom_line(alpha=alpha) +
    ggplot2::labs(y = y_lab) +
    ggplot2::theme_minimal(base_size=text_size)

  # Couleurs en fonction groupe/non
  if( group == "Aucune" ){

    p <- p +
      base_color +
      ggplot2::guides(color = "none")


  } else {

    p <- p +
      group_color

  }

  # Gestion de x et y lim
  if (y_type=="Valeurs brutes" & !is.null( ylim ) & !is.null( xlim ) & is.numeric(df[[time]]) ) {

    p <- p +  ggplot2::coord_cartesian(ylim = ylim,xlim = xlim)

  } else if(!is.null(xlim) & is.numeric(df[[time]]) ) {

    p <- p +  ggplot2::coord_cartesian(xlim = xlim)

  } else if(y_type=="Valeurs brutes" & !is.null(ylim)) {

    p <- p +  ggplot2::coord_cartesian(ylim = ylim)

  }

  # mixed_formule si residus
  if(y_type == "R\u00e9sidus"){
    p <- p +
      ggplot2::ggtitle(
        paste0("R\u00e9sidus des valeurs de ",x," pr\u00e9dis par mod\u00e8le lin\u00e9aire mixte (formule : ",.mixed_formula(df=df,x=x,time=time,ID=ID),")")
      )
  }

  return(p)

}

