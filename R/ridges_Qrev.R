# Ridges pour shiny_Qrev

ridges_Qrev <- function(
  df,
  x,
  group,
  ...,
  alpha = 0.7,
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
