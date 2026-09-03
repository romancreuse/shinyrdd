
shiny_Lrev <- function(df,qual_conv=NULL){

# data management ----
    
  # Transformation des variables précisées en factor 
  df <- df %>% mutate(
    across(all_of(qual_conv), ~ {
      lab <- attr(.x, "label")
      y <- factor(.x)
      attr(y, "label") <- lab
      y
    })
  )

# Liste de variable quali (classe factor ou character)
quali_vars <- c(names(df)[lapply(df[,1:ncol(df)],is.factor)%>%unlist],
                names(df)[lapply(df[,1:ncol(df)],is.character)%>%unlist])

# ui -----

ui <- ui_Lrev(df=df,quali_vars=quali_vars)

# server ------

server <- server_Lrev(df=df)

# lancement ----

shiny::shinyApp(ui = ui, server = server)

}

