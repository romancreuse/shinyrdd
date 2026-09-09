# server shiny_Lrev

server_Lrev <- function(df){
  function(session, input, output) {

  # MAJ de l'input d'inclusion en fonction du groupe choisi -----
  shiny::observeEvent(input$groupe, {

    if (input$groupe == "Aucune") {
      shiny::updateCheckboxGroupInput(
        session,
        inputId = "incl",
        choices = character(0),
        selected = character(0)
      )
      return()
    }

    shiny::updateCheckboxGroupInput(
      session,
      inputId = "incl",
      choices = unique(df[[input$groupe]])|>stats::na.omit(),
      selected = unique(df[[input$groupe]])|>stats::na.omit()
    )
  })

  # Inputs gelas lors des majs --------

  ID_go <- shiny::eventReactive(input$go, input$ID)

  temps_go <- shiny::eventReactive(input$go, input$temps)

  invest_go  <- shiny::eventReactive(input$go, input$invest)

  groupe_go <- shiny::eventReactive(input$go, input$groupe)

  x_go <- shiny::eventReactive(input$go,input$x)

  y_go <- shiny::eventReactive(input$go, input$y)

  isol_go <- shiny::eventReactive(input$go,
                           input$isol)

  incl_go <- shiny::eventReactive(input$go, input$incl)

  # MAJ salecteur de trace ------

  shiny::observeEvent(input$ID, {

    ids <- unique(
      as.character(
        stats::na.omit(df[[input$ID]])
      )
    )

    shiny::updateSelectInput(
      session,
      inputId = "isol",
      choices = c(
        "Aucune" = "Aucune",
        stats::setNames(ids, ids)
      ),
      selected = "Aucune"
    )

  })

  # MAJ sliders ------

  output$x_slider <- shiny::renderUI({
    shiny::req(input$temps)

    if (is.numeric(df[[input$temps]])) {
      shiny::sliderInput(
        "x",
        input$temps,
        min = min(df[[input$temps]], na.rm = TRUE)|> floor(),
        max = max(df[[input$temps]], na.rm = TRUE) |> ceiling(),
        value = c(min(df[[input$temps]], na.rm=TRUE) |> floor(),
                  max(df[[input$temps]], na.rm=TRUE) |> ceiling())
      )
    }
  })

  output$y_slider <- shiny::renderUI({
    shiny::req(input$invest)

    if (is.numeric(df[[input$invest]])) {
      shiny::sliderInput(
        "y",
        input$invest,
        min = min(df[[input$invest]], na.rm = TRUE) |> floor(),
        max = max(df[[input$invest]], na.rm = TRUE) |> ceiling(),
        value = c(min(df[[input$invest]], na.rm=TRUE) |> floor(),
                  max(df[[input$invest]], na.rm=TRUE) |> ceiling())
      )
    }
  })

  # df filtra ------

  data_spaghet <- shiny::reactive({

    .prepare_spag_data(df=df,
                       x=invest_go(),
                       time=temps_go(),
                       ID = ID_go(),
                       group = groupe_go(),
                       incl=incl_go(),
                       isol=isol_go(),
                       y_type=input$resid)

  })

  # graphs -----

  # graph de base ggplot

  output$plot_base <- shiny::renderPlot({

    spag_Lrev(df,
              x=invest_go(),
              time=temps_go(),
              ID = ID_go(),
              group = groupe_go(),
              isol=isol_go(),
              incl = incl_go(),
              y_type=input$resid,
              ylim=y_go(),
              xlim=x_go(),
              text_size=20)

  })

  # graph interactif avec plotly

  output$plot_inter <- plotly::renderPlotly({

    p <- spag_Lrev(df,
                   x=invest_go(),
                   time=temps_go(),
                   ID = ID_go(),
                   group = groupe_go(),
                   isol=isol_go(),
                   incl = incl_go(),
                   y_type=input$resid,
                   ylim=y_go(),
                   xlim=x_go(),
                   text_size=12)

    p <- plotly::ggplotly(
      p,
      tooltip = "text",
      source = "spag"
    )

    p <- plotly::event_register(
      p,
      "plotly_click"
    )

    return(p)

  })

  # Selecteur de trace par click

  shiny::observeEvent(plotly::event_data("plotly_click", source = "spag"), {

    ed <- plotly::event_data("plotly_click", source = "spag")

    shiny::updateSelectInput(
      session,
      inputId = "isol",
      selected = ed$key
    )

  })

  # Tableau de donnaes de la trace isolae -----

  output$isol <- DT::renderDT({

    DT::datatable(
      data_spaghet() |>
        dplyr::filter(.data[[ID_go()]]%in%isol_go()),
      options = list(
        pageLength = 50
      )
    )

  })

  # stockage des outliers ------

  # Affichage de l'option de stockage

  output$isoldisp <- shiny::reactive({

    isol_go() != "Aucune"

  })

  shiny::outputOptions(
    output,
    "isoldisp",
    suspendWhenHidden = FALSE
  )

  # Liste de stockage

  review_list <- shiny::reactiveVal(
    data.frame(
      ID = character(),
      Variable = character(),
      Commentaire = character()
    )
  )

  # Maj liste stockage

  shiny::observeEvent(input$store, {

    shiny::req(isol_go(), invest_go())

    old <- review_list()

    new <- data.frame(
      ID = isol_go(),
      Variable = invest_go(),
      Commentaire = input$comment
    )

    pos <- which(new$ID==old$ID & new$Variable==old$Variable)

    if (length(pos) == 0) {
      lst <- rbind(old,new)
    } else {
      lst <- old[-pos, ]
    }

    review_list(lst)

  })

  # Maj du boutton de gestion de liste
  shiny::observe({

    shiny::req(isol_go(), invest_go())

    rev <- review_list()

    present <- any(
      rev$ID == isol_go() &
        rev$Variable == invest_go()
    )

    if (present) {

      shiny::updateActionButton(
        session,
        "store",
        label = "Retirer de la liste de revue"
      )

    } else {

      shiny::updateActionButton(
        session,
        "store",
        label = "Ajouter \u00e0 la liste de revue"
      )

    }

    # Remise a 0 de la zone de commentaires

    shiny::updateTextAreaInput(
      session = session,
      "comment",
      value = ""
    )

  })

  # Affichage des id stockas

  output$review_ids <- shiny::renderUI({

    rev <- review_list()

    if (nrow(rev) == 0) {
      return(shiny::helpText("Aucun"))
    }

    htmltools::tags$ul(
      lapply(
        seq_len(nrow(rev)),
        function(i) {
          htmltools::tags$li(
            paste(
              rev$ID[i],
              rev$Variable[i],
              sep = " | "
            )
          )
        }
      )
    )

  })

  # Export des outliers -------
  output$export_outliers <- export_Lrev(review_list())

  }
}
