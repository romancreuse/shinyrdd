

shiny_Qrev <- function(df=trial,qual_conv=NULL,ID=NULL){
  
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

# Liste de variables quanti
quanti_vars <- names(df)[lapply(df[,1:ncol(df)],is.numeric)%>%unlist]

# Liste de variable quali (classe factor ou character)
quali_vars <- c(names(df)[lapply(df[,1:ncol(df)],is.factor)%>%unlist],
                names(df)[lapply(df[,1:ncol(df)],is.character)%>%unlist])

#Retrait ID 
quali_vars <- quali_vars[!quali_vars %in% ID]

# ui -----

ui <- ui_Qrev(df=df,quali_vars=quali_vars,quanti_vars=quanti_vars)  

# sever -----

server <- server_Qrev(df=df,quanti_vars=quanti_vars,ID=ID)

# lancement -----

shiny::shinyApp(ui = ui, server = server)

}