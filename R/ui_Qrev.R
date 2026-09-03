# UI shiny_Qrev

ui_Qrev <- function(df,quali_vars,quanti_vars){

  shiny::fluidPage(
  shiny::titlePanel("Revue de données quantitatives"),
  # inputs ----
  shiny::sidebarLayout(
    shiny::sidebarPanel(width = 2,
                 # Variable quanti à investiguer
                 shiny::conditionalPanel(
                   condition = "input.tabs == 'Graphs continu'|| input.tabs == 'Liste outliers'",
                   shiny::selectInput(
                     inputId = "num",
                     label = "Variable à investiguer",
                     choices = choices_from_labels(df, quanti_vars)
                   )
                 ),
                 # Choix pour la variable de groupage = Aucune + liste des variables quali
                 shiny::selectInput(
                   inputId = "grp",
                   label = "Variable de groupage",
                   choices = c("Aucune",choices_from_labels(df, quali_vars)),
                   selected = "Aucune"
                 ),
                 # Si une variable de groupage est sélectionnée, possiblité d'exclures certaines modalités de l'analyse
                 # Ici par défaut vide, mis à jour dans le server quand un groupe est selectionné
                 shiny::conditionalPanel(
                   condition = "input.grp != 'Aucune'",
                   shiny::checkboxGroupInput(
                     inputId = "incl",
                     label = "Groupes à inclure",
                     choices = NULL
                   )
                 ),
                 shiny::actionButton("go", "Mettre à jour"),
                 shiny::conditionalPanel(
                   condition = "input.tabs == 'Graphs continu'|| input.tabs == 'Liste outliers'",
                   shiny::numericInput(
                     inputId = "bmin",
                     label = "Borne min outlier",
                     value = NA
                   ),
                   shiny::numericInput(
                     inputId = "bmax",
                     label = "Borne max outlier",
                     value = NA
                   )
                 ),
                 shiny::conditionalPanel(
                   condition = "input.tabs == 'Graphs continu'",
                   shiny::numericInput(
                     inputId = "bins",
                     label = "Granularité (histogramme)",
                     value = 30,
                     min = 1
                   )
                 ),
                 shiny::conditionalPanel(
                   condition = "(input.bmax != null || input.bmin != null)",
                   actionButton("store", "Ajouter à la liste d'outliers")
                 ),
                 shiny::conditionalPanel(
                   condition = "output.has_outliers",
                   downloadButton(
                     outputId = "export_outliers",
                     label = "Exporter les outliers"
                   ),
                   helpText("Tables stockées"),
                   uiOutput("stored_tables")
                 ),
                 shiny::checkboxGroupInput(
                   inputId = "desc",
                   label = "Variables à inclure dans les tableaux",
                   choices = choices_from_labels(df,colnames(df)),
                   selected = choices_from_labels(df,colnames(df))
                 )
                 
    ),
  # Outputs ---- 
  shiny::mainPanel(width = 10,
                   shiny::tabsetPanel(id = "tabs",
                                      shiny::tabPanel(
                            title = "Graphs continu",
                            
                            htmltools::div(
                              style = "margin-bottom: 30px;",
                              gt::gt_output("desc_num")
                            ),
                            htmltools::div(
                              style = "margin-bottom: 30px;",
                              shiny::plotOutput("hist")
                            ),
                            
                            htmltools::div(
                              style = "margin-bottom: 30px;",
                              shiny::plotOutput("ridges")
                            )
                          ),
                          shiny::tabPanel(
                            title = "Liste outliers",
                            htmltools::br(),
                            DT::dataTableOutput("outliers")
                          ),
                          shiny::tabPanel(
                            title = "Tableau descriptif",
                            htmltools::span(textOutput("date_removed"), style="color:red"),
                            gt::gt_output("desc")
                          )
                          
              )
    )
  )
)
}