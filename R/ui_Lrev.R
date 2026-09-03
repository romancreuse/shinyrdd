# UI shiny_revL

ui_Lrev <- function(df,quali_vars){
  shiny::fluidPage(
  
  
    shiny::titlePanel("Revue de données longitudinales"),
  # inputs -----
    shiny::sidebarLayout(
      shiny::sidebarPanel(width=2,
                          shiny::selectInput(
                   inputId = "ID",
                   label = "Variable ID",
                   choices = choices_from_labels(df, colnames(df))
                 ),
                 shiny::selectInput(
                   inputId = "temps",
                   label = "Variable temps",
                   choices = choices_from_labels(df, colnames(df))
                 ),
                 shiny::selectInput(
                   inputId = "invest",
                   label = "Variable à investiguer",
                   choices = choices_from_labels(df, colnames(df))
                 ),
                 shiny::selectInput(
                   inputId = "groupe",
                   label = "Variable de groupage",
                   choices = c("Aucune", choices_from_labels(df, quali_vars)),
                   selected = "Aucune"
                 ),
                 shiny::conditionalPanel(
                   condition = "input.groupe != 'Aucune'",
                   shiny::checkboxGroupInput(
                     inputId = "incl",
                     label = "Groupes à inclure",
                     choices = NULL
                   )
                 ),
                 shiny::selectInput(
                   inputId = "isol",
                   label = "ID à isoler",
                   choices = c("Aucune"),
                   selected = "Aucune"
                 ),
                 shiny::uiOutput("x_slider"),
                 shiny::uiOutput("y_slider"),
                 shiny::actionButton("go", "Mettre à jour"),
                 shiny::checkboxInput(inputId = "react",
                                      label = "Graph interactif",
                                      value = F),
                 shiny::selectInput(
                   inputId = "resid",
                   label = "Visualisation",
                   choices = c("Valeurs brutes", "Résidus"),
                   selected = "Valeurs brutes"
                 ),
                 shiny::conditionalPanel(condition = "output.isoldisp == true",
                 shiny::actionButton("store", "Ajouter à la liste d'outliers"),
                 shiny::textAreaInput(
                   "comment",
                   "Commentaire",
                   placeholder = "Décrire l'anomalie observée..."
                 )),
                 shiny::helpText("ID stockés"),
                 shiny::uiOutput("review_ids"),
                 shiny::downloadButton(
                   outputId = "export_outliers",
                   label = "Exporter les outliers"
                 )
    ),
    
    # outputs ----
    shiny::mainPanel(width=10,
                     shiny::conditionalPanel(condition = "input.react == false",        
                                             shiny::plotOutput("plot_base")
              ),
              shiny::conditionalPanel(condition = "input.react == true",
                               plotly::plotlyOutput("plot_inter")
              ),
              shiny::conditionalPanel(condition = "output.isoldisp == true",
                               DT::dataTableOutput("isol")
              )
    )
  )
)
}  