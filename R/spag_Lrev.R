# formule pour résidus

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

# Jeu filtré

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
  
  # Remplacement de la variable à xiguer par les résidus si y_type = Résidus
  if(y_type=="Résidus"){
    
    fit <- lme4::lmer(
      stats::as.formula(
      .mixed_formula(df=df,
                    x=x,
                    time=time,
                    ID=ID)
      ),
      data = temp)
    
    temp$residuals <- resid(fit)
    
  }  
  
  if(isol!="Aucune"){
    
    temp <- temp |>
      dplyr::filter(.data[[ID]] %in% isol)
    
  }  
  
  temp
  
}

# Spaghetti plot

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

  # Var y en foncttions résidus/brut
  y_var <- if (y_type == "Résidus") {
    "residuals"
  } else {
    x
  }
  
  # Labels y en fonction résidus/non
  y_lab <- if (y_type == "Résidus") {
    paste("Ecart aux valeurs prédites de ",choice_from_label(df, x))
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
      ggplot2::scale_color_grey(start = 0.2, end = 0.8) +
      ggplot2::guides(color = "none")
    
    
  } else {
    
    p <- p +
      ggplot2::scale_color_viridis_d()
    
  }
  
  # Gestion de x et y lim
  if (y_type=="Valeurs brutes" & !is.null( ylim ) & !is.null( xlim ) & is.numeric(df[[time]]) ) {
    
    p <- p +  ggplot2::coord_cartesian(ylim = ylim,xlim = xlim)
    
  } else if(!is.null(xlim) & is.numeric(df[[time]]) ) {
    
    p <- p +  ggplot2::coord_cartesian(xlim = xlim)
    
  } else if(y_type=="Valeurs brutes" & !is.null(ylim)) {
    
    p <- p +  ggplot2::coord_cartesian(ylim = ylim)
    
  }
  
  # mixed_formule si résidus
  if(y_type == "Résidus"){
    p <- p +
      ggplot2::ggtitle(
        paste0("Résidus des valeurs de ",x," prédis par modèle linéaire mixte (forumle : ",.mixed_formula(df=df,x=x,time=time,ID=ID),")")
      )
  }
  
  return(p)  
  
}

