# Histogrammes pour shiny_Qrev

#' Histograms for quantitative data review
#'
#' Creates a histogram using [ggplot2::geom_histogram()] for the review of a quantitative variable,
#' optionally stratified by a qualitative grouping variable. Optional
#' minimum and maximum values can be displayed together with the
#' corresponding numbers of observations outside these limits.
#'
#' @param df A data frame.
#' @param x The name of the quantitative variable to be reviewed,
#'   provided as a character string.
#' @param group An optional qualitative grouping variable, provided as a
#'   character string. Defaults to `"Aucune"` (none).
#' @param bmin An optional minimum value to display on the plot. The number
#'   of observations of `x` strictly below this value is displayed.
#' @param bmax An optional maximum value to display on the plot. The number
#'   of observations of `x` strictly above this value is displayed.
#' @param bins The number of bins in the histogram. Defaults to 30.
#' @param ... Additional arguments passed to [ggplot2::geom_histogram()].
#' @param color The color of the histogram bin borders. Defaults to `"black"`.
#' @param fill The fill color of the histogram bins. Defaults to `"grey"`.
#' @param group_fill A ggplot2 fill scale used to customize the color palette
#'   when a grouping variable is specified. Defaults to
#'   [ggplot2::scale_fill_viridis_d()].
#' @param bmin_col The color of the minimum value vertical line.
#'   Defaults to `"darkblue"`.
#' @param bmax_col The color of the maximum value vertical line.
#'   Defaults to `"red"`.
#' @param alpha The transparency of the histogram. Defaults to `0.7`.
#' @param text_size The base text size of the ggplot2 theme. Defaults to `11`.
#'
#' @return A ggplot2 object.
#' @export
#'
#' @examples
#' # Simple visualisation of the distribution
#' # Variable names must be provided as character strings
#' hist_Qrev(df = quanti_demo, x = "BMI")
#'
#' # Customise grouping, minimum and maximum values, and number of bins
#' # for a more detailed review
#' hist_Qrev(
#'   df = quanti_demo,
#'   x = "BMI",
#'   group = "Treatment",
#'   bmin = 12,
#'   bmax = 45,
#'   bins = 35
#' )
hist_Qrev <- function(
  df,
  x,
  group="Aucune",
  bmin = NA,
  bmax = NA,
  bins=30,
  ...,
  color="black",
  fill="grey",
  group_fill= ggplot2::scale_fill_viridis_d(),
  bmin_col="darkblue",
  bmax_col="red",
  alpha=0.7,
  text_size=11
  ){

if(group=="Aucune"){
  p <- ggplot2::ggplot(df) +
    ggplot2::geom_histogram(ggplot2::aes(x = .data[[ x ]]),
                   color=color,
                   fill=fill,
                   alpha=alpha,
                   ...,
                   bins = bins)
}else{
  p <- ggplot2::ggplot(df) +
    ggplot2::geom_histogram(ggplot2::aes(x = .data[[ x ]],fill = .data[[ group ]]),
                   color=color,
                   alpha=alpha,
                   ...,
                   bins = bins) +
    group_fill
}

# Bornes

  #Extraction de la hauteur max pour les annotations
  hist <- graphics::hist(
    df[[x]],
    plot = FALSE,
    breaks = bins
  )

  ymax <- max(hist$counts)

  # Etendue pour la position x des annotations

  offset <- diff(range(df[[x]], na.rm = TRUE)) * 0.02

### ---- BORNES MIN ---- ###
if(!is.na(bmin)){

  # Calcul du nombre d'obs < bmin
  n_bmin <- sum(df[[x]] < bmin,na.rm = T)

  p <- p +
    ggplot2::geom_vline(
      xintercept = bmin,
      color=bmin_col,
      inherit.aes = FALSE
    ) +
    ggplot2::annotate("text",
             x = bmin - offset,
             y = ymax,
             label = n_bmin,
             color = bmin_col
    )
}

### ---- BORNES MAX ---- ###
if(!is.na(bmax)){

  # Calcul du nombre d'obs > bmax
  n_bmax <- sum(df[[x]] > bmax,na.rm = T)

  p <- p +
    ggplot2::geom_vline(
      xintercept = bmax,
      color=bmax_col,
      inherit.aes = FALSE
    ) +
    ggplot2::annotate("text",
             x = bmax + offset,
             y = ymax,
             label = n_bmax,
             color = bmax_col
    )
}

p +
  ggplot2::labs(
    x = choice_from_label(df, x),
    y = "Nombre d'observations"
  ) +
  ggplot2::theme_minimal(base_size=text_size)

}
