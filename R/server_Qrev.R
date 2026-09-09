
server_Qrev <- function(df,quanti_vars,ID){

  function(session, input, output) {


  # MAJ input inclusion -----
    shiny::observeEvent(input$grp, {

    if (input$grp == "Aucune") {
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
      choices = unique(df[[input$grp]])|>stats::na.omit(),
      selected = unique(df[[input$grp]])|>stats::na.omit()
    )
  })

  # MAJ bornes a 0 lors du changement de variables -------
    shiny::observeEvent(input$num, {

      shiny::updateNumericInput(
      session,
      inputId = "bmin",
      label = "Borne min outlier",
      value = NA
    )

      shiny::updateNumericInput(
      session,
      inputId = "bmax",
      label = "Borne max outlier",
      value = NA
    )

  })

  # Inputs geles lors des majs --------
  grp_go <- shiny::eventReactive(input$go, input$grp)
  incl_go <- shiny::eventReactive(input$go, input$incl)
  num_go  <- shiny::eventReactive(input$go, input$num)

  # Filtrage du jeu par groupe ----

  df_filtre <- shiny::eventReactive(input$go, {

    temp <- df

    if (grp_go() != "Aucune") {

      temp <- temp |>
        dplyr::filter(.data[[grp_go()]] %in% incl_go())


      # Retrait des niveaux inutilises en conservant labels

      if(is.factor(temp[[grp_go()]])){

        temp[[grp_go()]] <- droplevels(temp[[grp_go()]])
        attr(temp[[grp_go()]], "label") <- choice_from_label(df,grp_go())

      }


    }

    return(temp)

  })

  # Filtrage outliers ----

  df_outliers <- shiny::reactive({

    temp <- df_filtre()

     if (!is.na(input$bmax) && is.na(input$bmin)){

      temp <- temp |>
        dplyr::filter( .data[[num_go()]] > input$bmax )

    } else if (is.na(input$bmax)&!is.na(input$bmin)){

      temp <- temp |>
        dplyr::filter( .data[[num_go()]] < input$bmin )

    } else {

      temp <- temp |>
        dplyr::filter( .data[[num_go()]] < input$bmin |
                  .data[[num_go()]] > input$bmax )

    }

    return(temp)

  })

  # Figures -------

  ## tables descriptives -------

  # Description globale

  output$desc <- gt::render_gt({

    shiny::req(input$go)

    df_table <- df_filtre() |>
      # Variables selectionnees -ID
      dplyr::select(if(grp_go()!="Aucune"){grp_go()},input$desc,-ID) |>
      # Retrait des dates non pris en charge par rastrocket
      dplyr::select(
        dplyr::where(~ !inherits(.x, "Date") && !inherits(.x, "POSIXt"))
      )


    if(grp_go()!="Aucune"){

      RastaRocket::desc_var(df_table,
                            by_group = T,
                            var_group = grp_go(),
                            quanti = quanti_vars[quanti_vars%in%input$desc]) |>
        gtsummary::as_gt()

    } else (

      RastaRocket::desc_var(df_table,
                            quanti = quanti_vars[quanti_vars%in%input$desc]) |>
        gtsummary::as_gt()

    )


  })

  # Message si retrait de dates

  output$date_removed <- shiny::renderText({

    df_date <- df_filtre() |>
      dplyr::select(input$desc, -ID) |>
      dplyr::select(
        dplyr::where(~ inherits(.x, "Date") || inherits(.x, "POSIXt"))
      )

    if (ncol(df_date) > 0) {
        "Les variables dates ne sont pas prises en charge par RastaRocket et ont \u00e9tt\u00e9t retir\u00e9tes du tableau."
    } else {
      ""
    }

  })

  # Description de la variable numerique a investiguer

  output$desc_num <-gt::render_gt({

    shiny::req(input$go)

    if(grp_go()!="Aucune"){
      df_desc_num <- df_filtre()|>
        dplyr::select(grp_go(),num_go())

      RastaRocket::desc_var(df_desc_num,
                            by_group = T,
                            var_group = grp_go(),
                            quanti = num_go()) |>
        gtsummary::as_gt()

    } else {

      df_desc_num <- df_filtre()|>
        dplyr::select(num_go())

      RastaRocket::desc_var(df_desc_num,
                            quanti = num_go()) |>
        gtsummary::as_gt()

    }


  })

  ## Histogramme ----

  output$hist <- shiny::renderPlot({

    shiny::req(input$go)

    hist_Qrev(df=df_filtre(),
              x=num_go(),
              bins=input$bins,
              group=grp_go(),
              bmin=input$bmin,
              bmax=input$bmax,
              text_size=20)

  })

  ## Ridges ----

  output$ridges <- shiny::renderPlot({

    shiny::req(input$go)

    # df_ridges <- df_filtre()

    if(grp_go()!="Aucune"){

      ridges_Qrev(
        df = df_filtre(),
        x = num_go(),
        group = grp_go(),
        text_size=20
      )

    }else(
      NULL
    )

  })

  ## Table outliers ------

  output$outliers <- DT::renderDT({

    DT::datatable(
      df_outliers() |>
        dplyr::select(input$desc),
      options = list(
        pageLength = 50
      )
    )

  })

  # stockage des outliers ----

  # Expression de la condition de reperage d'outliers
  con_name <- shiny::reactive({

    cond <- substr(num_go(),1,5)

    condnum <- character()

    condgrp <- character()

    if ( length(incl_go()) > 0 ){

      condgrp <- paste0(substr(grp_go(),1,5),
                        paste0(substr(incl_go(),1,3), collapse = ","),
                        collapse = ":")

    }


    if (!is.na(input$bmin)){
      condnum <- c(condnum, paste0("<", input$bmin))
    }

    if (!is.na(input$bmax)){
      condnum <- c(condnum, paste0(">", input$bmax))
    }

    condnum <- paste0(condnum, collapse = "|")

    paste0(cond,condnum,condgrp)

  })

  # Maj du boutton de gestion de liste
  shiny::observe({

    shiny::req(con_name())

    if (con_name() %in% names(out_list())) {

      shiny::updateActionButton(
        session,
        "store",
        label = "Retirer de la liste d'outliers"
      )

    } else {

      shiny::updateActionButton(
        session,
        "store",
        label = "Ajouter \u00e0 la liste d'outliers"
      )

    }

  })

  out_list <- shiny::reactiveVal(list())

  # Ajout ou retrait du df d'outliers actuel de la liste d'outlier

  shiny::observeEvent(input$store, {



    shiny::req(con_name())

    lst <- out_list()

    if (con_name() %in% names(lst)) {

      lst[[con_name()]] <- NULL

    } else {

      lst[[con_name()]] <- df_outliers()

    }

    out_list(lst)

  })

  #Tables stockees

  output$stored_tables <- shiny::renderUI({

    shiny::req(out_list())

    htmltools::tags$ul(
      lapply(
        names(out_list()),
        function(x) {
          htmltools::tags$li(x)
        }
      )
    )

  })


  # Export des outliers -----

  # Pour maj bouton telechargement
  output$has_outliers <- shiny::reactive({
    length(out_list()) > 0
  })

  shiny::outputOptions(
    output,
    "has_outliers",
    suspendWhenHidden = FALSE
  )

  output$export_outliers <- export_Qrev(out_list())

  }
}
