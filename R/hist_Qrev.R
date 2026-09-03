# Histogrammes pour shiny_Qrev

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
    geom_vline(
      xintercept = bmin,
      color=bmin_col,
      inherit.aes = FALSE
    ) +
    annotate("text",
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
  theme_minimal(base_size=text_size)

}
