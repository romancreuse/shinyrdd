# Ridges pour shiny_Qrev
#' Ridgeline density plots for quantitative data review
#'
#' Creates ridgeline density plots using [ggridges::geom_density_ridges()]  to compare the distribution of a
#' quantitative variable across the levels of a qualitative grouping
#' variable.
#'
#' @param df A data frame.
#' @param x The name of the quantitative variable to be reviewed,
#'   provided as a character string.
#' @param group The name of the qualitative grouping variable,
#'   provided as a character string.
#' @param ... Additional arguments passed to
#'   [ggridges::geom_density_ridges()].
#' @param alpha The transparency of the density ridges. Defaults to `0.7`.
#' @param rel_min_height Lines with heights below this cutoff will be removed. The cutoff is measured relative to the overall maximum. Defaults to 0.01.
#' @param fill A ggplot2 fill scale used to customize the color palette
#'   of the density ridges. Defaults to
#'   [ggplot2::scale_fill_viridis_d()].
#' @param text_size The base text size of the ggplot2 theme.
#'   Defaults to `11`.
#'
#' @return A ggplot2 object.
#' @export
#'
#' @examples
#' # Visualise the distribution of BMI across treatment groups
#' ridges_Qrev(
#'   df = quanti_demo,
#'   x = "BMI",
#'   group = "Treatment"
#' )
ridges_Qrev <- function(
  df,
  x,
  group,
  ...,
  alpha = 0.7,
  rel_min_height = 0.01,
  fill = ggplot2::scale_fill_viridis_d(),
  text_size=11
  ){

ggplot2::ggplot(
  df,
  ggplot2::aes(x = .data[[x]], y = .data[[group]])) +
  ggridges::geom_density_ridges(
    ggplot2::aes(fill=.data[[group]],
                 #retire les queues de distribution
                 rel_min_height = 0.01),
    ...,
    alpha=alpha) +
  fill +
    ggplot2::labs(
      x=choice_from_label(df, x),
      y=choice_from_label(df, group))  +
    ggplot2::theme_minimal(base_size=text_size)

}
