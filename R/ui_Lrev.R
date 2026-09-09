# UI shiny_revL

ui_Lrev <- function(
    df,
    quali_vars){
  shiny::fluidPage(
    shiny::titlePanel("Revue de donn\u00e9es longitudinales"),
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
                   label = "Variable \u00e0 investiguer",
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
                     label = "Groupes \u00e0 inclure",
                     choices = NULL
                   )
                 ),
                 shiny::selectInput(
                   inputId = "isol",
                   label = "ID \u00e0 isoler",
                   choices = c("Aucune"),
                   selected = "Aucune"
                 ),
                 shiny::uiOutput("x_slider"),
                 shiny::uiOutput("y_slider"),
                 shiny::actionButton("go", "Mettre \u00e0 jour"),
                 shiny::checkboxInput(inputId = "react",
                                      label = "Graph interactif",
                                      value = F),
                 shiny::selectInput(
                   inputId = "resid",
                   label = "Visualisation",
                   choices = c("Valeurs brutes", "R\u00e9sidus"),
                   selected = "Valeurs brutes"
                 ),
                 shiny::conditionalPanel(condition = "output.isoldisp == true",
                 shiny::actionButton("store", "Ajouter \u00e0 la liste d'outliers"),
                 shiny::textAreaInput(
                   "comment",
                   "Commentaire",
                   placeholder = "D\u00e9crire l'anomalie observ\u00e9e..."
                 )),
                 shiny::helpText("ID stock\u00e9s"),
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
                              # Data from the selected ID
                               DT::dataTableOutput("isol")
              )
    )
  )
)
}
