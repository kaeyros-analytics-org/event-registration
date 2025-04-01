

perf_ui <- function(id){
  ns <- NS(id)
  #h2("HELLO")
  page_fluid(
    layout_column_wrap(
      width = 1/3,class = "bslib-grid",

      # First Value Box for "Nombre de visites"
      value_box(#width="0.1",
        title = "Visit rate",
        value = textOutput(ns("text1")), #sum(custom_ventes$Freq)
        showcase = bsicons::bs_icon("speedometer2"),
        full_screen = TRUE,
        theme = value_box_theme(bg = "#BBBBF5", fg = "#6247aa"), #ff5400
        class = "border"
      ),

      # Second Value Box for "Total des ventes"
      value_box(
        title = "Efficiency rate",
        value = textOutput(ns("text2")),
        showcase = bsicons::bs_icon("speedometer2"),
        full_screen = TRUE,
        theme = value_box_theme(bg = "#BBBBF5", fg = "#6247aa"),
        class = "border"),
      value_box(
        title = "Conversion rate",
        value = textOutput(ns("text3")),
        showcase = bsicons::bs_icon("speedometer2"),
        full_screen = TRUE,
        theme = value_box_theme(bg = "#BBBBF5", fg = "#6247aa"),
        class = "border"      )
    ),
    div(style="display: flex; gap:20px",
        div(class="col-lg-6 pr-1 pl-0", id = "table",
            div( class = "subItem_dashboard",
                 uiOutput(ns("plot1"))
            ),
        ),
        div(class="col-lg-6 pl-1 pr-0", id = "linechart",
            div( class = "subItem_dashboard",
                 uiOutput(ns("plot2"))
            ),
        )
    ),
    div(style="display: flex; gap:20px",
        div(class="col-lg-6 pr-1 pl-0", id = "table",
            div( class = "subItem_dashboard",
                 uiOutput(ns("plot3"))
            ),
        ),
        div(class="col-lg-6 pl-1 pr-0", id = "linechart",
            div( class = "subItem_dashboard",
                 uiOutput(ns("plot4"))
            ),
        )
    ),
    div(style="display: flex; gap:20px",
        div(class="col-lg-6 pr-1 pl-0", id = "table",
            div( class = "subItem_dashboard",
                 uiOutput(ns("plot5"))
            ),
        ),
        div(class="col-lg-6 pl-1 pr-0", id = "linechart",
            div( class = "subItem_dashboard",
                 uiOutput(ns("plot6"))
            ),
        )
    )

  )

  
  
}


perf_server <- function(input, output, session, filterStates){
  # data_filter <- reactive({
  #   data <- data %>%
  #     filter(as.Date(createdAt.x) >= filterStates$date_start & as.Date(createdAt.x) <= filterStates$date_end) %>%
  #     filter(if (!"TOUT" %in% filterStates$selectedCity) city == filterStates$selectedCity  else TRUE) %>% #filterStates$selectedCity
  #     filter(if (length(filterStates$selectedtyp_pdv) != 0 && !"TOUT" %in% filterStates$selectedtyp_pdv) type_of_business %in% filterStates$selectedtyp_pdv  else TRUE) %>%
  #     filter(if (length(filterStates$selectedtyp_prospect) != 0 && !"TOUT" %in% filterStates$selectedtyp_prospect) prospecting_type %in% filterStates$selectedtyp_prospect  else TRUE) %>%
  #     filter(if (!"TOUT" %in% filterStates$commercial) name == filterStates$commercial  else TRUE)
  #   data %>%
  #     mutate(Semaine = floor_date(createdAt.x, unit = "week", week_start = 1))
  # })
  data3 <- shiny::reactiveFileReader(1000, NULL, "./data/data_reactive.rds", readRDS)
  session$userData$filterStates <- reactiveValues(
    # dataset
    dataNavi = list(dataset = "Map"),
    selectedCity = "TOUT",
    selectedtyp_pdv = "TOUT",
    selectedtyp_prospect = "TOUT",
    commercial="TOUT",
    allCountry = "",
    TimeSerieRange = NULL,
    date_start = "2025-02-01",
    date_end = Sys.Date(),
    filterButton = FALSE
  )
  data_filter <- reactive({
    data3 <- data3() %>%
      filter(as.Date(createdAt.x) >= session$userData$filterStates$date_start & as.Date(createdAt.x) <= session$userData$filterStates$date_end) %>%
      filter(if (!"TOUT" %in% session$userData$filterStates$selectedCity) city == session$userData$filterStates$selectedCity  else TRUE) %>% #filterStates$selectedCity
      filter(if (length(session$userData$filterStates$selectedtyp_pdv) != 0 && !"TOUT" %in% session$userData$filterStates$selectedtyp_pdv) type_of_business %in% session$userData$filterStates$selectedtyp_pdv  else TRUE) %>%
      filter(if (length(session$userData$filterStates$selectedtyp_prospect) != 0 && !"TOUT" %in% session$userData$filterStates$selectedtyp_prospect) prospecting_type %in% session$userData$filterStates$selectedtyp_prospect  else TRUE) %>%
      filter(if (!"TOUT" %in% session$userData$filterStates$commercial) name == session$userData$filterStates$commercial  else TRUE)
    data3 %>%
      mutate(Semaine = floor_date(createdAt.x, unit = "week", week_start = 1))
  })

  output$plot1 <- renderUI({
    out <- accordionCard(accordionId = "accordionPlot2",
                         headerId = 'plotchart2',
                         targetId = 'collapseCcplotchart2',
                         headerContent = paste0("Evolution of the visit rate", sep = ""),
                         bodyContent = plotlyOutput(session$ns("taux_vis_evolution")),
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  output$plot2 <- renderUI({
    out <- accordionCard(accordionId = "accordionPlot2",
                         headerId = 'plotchart2',
                         targetId = 'collapseCcplotchart2',
                         headerContent = paste0("Cumulative visit rate per Sale Rep.", sep = ""),
                         bodyContent = plotlyOutput(session$ns("rate_visit_srep")), #d3tree2Output
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  output$plot3 <- renderUI({
    out <- accordionCard(accordionId = "accordionPlot2",
                         headerId = 'plotchart2',
                         targetId = 'collapseCcplotchart2',
                         headerContent = paste0("Evolution of the efficiency rate", sep = ""),
                         bodyContent = plotlyOutput(session$ns("efficiency_week")), #d3tree2Output
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  output$plot4 <- renderUI({
    out <- accordionCard(accordionId = "accordionPlot2",
                         headerId = 'plotchart2',
                         targetId = 'collapseCcplotchart2',
                         headerContent = paste0("Cumulative efficiency rate per Sale Rep.", sep = ""),
                         bodyContent = plotlyOutput(session$ns("rate_efficiency_srep")), #d3tree2Output
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  output$plot5 <- renderUI({
    out <- accordionCard(accordionId = "accordionPlot2",
                         headerId = 'plotchart2',
                         targetId = 'collapseCcplotchart2',
                         headerContent = paste0("Cumulative conversion rate per Sale Rep.", sep = ""),
                         bodyContent = plotlyOutput(session$ns("conversion_week")), #d3tree2Output
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  output$plot6 <- renderUI({
    out <- accordionCard(accordionId = "accordionPlot2",
                         headerId = 'plotchart2',
                         targetId = 'collapseCcplotchart2',
                         headerContent = paste0("Cumulative conversion rate per Sale Rep.", sep = ""),
                         bodyContent = plotlyOutput(session$ns("rate_conversion_srep")), #d3tree2Output
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  output$text1 <- renderText({
    nb_theorique <- 12*length(unique(data_filter()$createdAt.x))*length(unique(data_filter()$name))
    nb_terrain <- nrow(data_filter())
    taux_cumul_visit <- nb_terrain/nb_theorique*100
    taux_cumul_visit <- round(taux_cumul_visit)
    paste(taux_cumul_visit,"%", sep="")
  })
  output$text2 <- renderText({
    nb_vente <- nrow(data_filter() %>% filter(achievement=="vente"))
    nb_visites <- length(unique(data_filter()$business_name))
    rate_efficiency <- round(nb_vente/nb_visites*100,2)
    paste(rate_efficiency,"%",sep="")
  })
  output$text3 <- renderText({
    nb_vente <- nrow(data_filter() %>% filter(achievement=="vente"))
    nb_promesse <- nrow(data_filter() %>% filter(achievement=="promesse"))
    conversion_rate <- round(nb_vente/nb_promesse*100,2)
    paste(conversion_rate, "%",sep="")

  })

  output$taux_vis_evolution <- renderPlotly({
    stats_par_semaine <- data_filter() %>%
      group_by(Semaine) %>%
      summarize(
        nb_theorique = 12 * 6* length(unique(name)) ,
        nb_terrain = n(),
        taux_cumul_visit = round(nb_terrain / nb_theorique,2)
      )
    plot <- plot_ly(data = stats_par_semaine) %>%
      add_lines(x = ~as.character(Semaine), y = ~taux_cumul_visit, name = "Taux Cumul Visit", mode = "lines+markers") %>%
      layout(
        title = " ",
        xaxis = list(title = "Semaine"),
        yaxis = list(title = "Pourcentage", tickformat = ".0%"),
        #yaxis2 = list(title = "Taux Cumul Visit", overlaying = "y", side = "right"),
        legend = list(x = 0.1, y = max(stats_par_semaine$taux_cumul_visit))
      )

    plot
  })

  output$rate_visit_srep <- renderPlotly({
    date_debut <- min(data_filter()$createdAt.x)
    date_fin <- Sys.Date()#max(data_filter()$createdAt.x)

    sequence_dates <- seq(date_debut, date_fin, by = "day")
    jours_ouvrables <- sequence_dates[wday(sequence_dates) %in% 2:6]
    #nombre_jours_ouvrables <- length(jours_ouvrables)

    stats_par_srep <- data_filter() %>%
      group_by(name) %>%
      summarize(
        nb_theorique=12*length(jours_ouvrables),#12*6*length(unique(data_filter()$Semaine)),
        nb_terrain = n(),
        taux_cumul_visit = round(nb_terrain / nb_theorique,2)
      )
    plot_ly(data = stats_par_srep, x = ~name, y = ~taux_cumul_visit, type = 'bar', name = "Taux Cumul Visit") %>%
      layout(
        title = "",
        xaxis = list(title = "Name"),
        yaxis = list(title = "Cumulative rate of visits (%)", tickformat = ".0%"),
        showlegend = FALSE
      )
  })

  output$efficiency_week <- renderPlotly({
    efficiency_week <- data_filter() %>%
      group_by(Semaine) %>%
      summarize(
        nb_vente = sum(achievement == "vente", na.rm = TRUE),  # Compte le nombre de ventes
        nb_visites = n_distinct(business_name),                  # Compte les visites uniques
        rate_efficiency = round(nb_vente / nb_visites, 2)
      ) %>%
      replace_na(list(nb_vente = 0, rate_efficiency = 0))

    plot <- plot_ly(data = efficiency_week) %>%
      add_lines(x = ~as.character(Semaine), y = ~rate_efficiency, name = "Taux Cumul Visit", mode = "lines+markers") %>%
      layout(
        title = " ",
        xaxis = list(title = "Semaine"),
        yaxis = list(title = "Pourcentage", tickformat = ".0%"),
        #yaxis2 = list(title = "Taux Cumul Visit", overlaying = "y", side = "right"),
        legend = list(x = 0.1, y = max(efficiency_week$rate_efficiency))
      )

    plot

  })

  output$rate_efficiency_srep <- renderPlotly({
    efficiency_srep <- data_filter() %>%
      group_by(name) %>%
      summarise(
        nb_vente = sum(achievement == "vente", na.rm = TRUE),
        nb_visites = n_distinct(business_name),
        rate_efficiency = round(nb_vente / nb_visites, 2)
      )
    plot_ly(data = efficiency_srep, x = ~name, y = ~rate_efficiency, type = 'bar', name = "Taux Cumul Visit") %>%
      layout(
        title = "",
        xaxis = list(title = "Name"),
        yaxis = list(title = "Cumulative rate of efficiency (%)", tickformat = ".0%"),
        showlegend = FALSE
      )
  })

  output$conversion_week <- renderPlotly({
    conversion_week <- data_filter() %>%
      group_by(Semaine) %>%
      summarize(
        nb_vente = sum(achievement == "vente", na.rm = TRUE),  # Compte le nombre de ventes
        nb_promesses = sum(achievement == "promesse", na.rm = TRUE),                # Compte les visites uniques
        rate_conversion = round(nb_vente / nb_promesses, 2)
      ) %>%
      mutate(
        rate_conversion = ifelse(is.nan(rate_conversion), 0, rate_conversion))

    plot_ly(data = conversion_week) %>%
      add_lines(x = ~as.character(Semaine), y = ~rate_conversion, name = "Taux Cumul Visit", mode = "lines+markers") %>%
      layout(
        title = " ",
        xaxis = list(title = "Semaine"),
        yaxis = list(title = "Pourcentage", tickformat = ".0%"),
        #yaxis2 = list(title = "Taux Cumul Visit", overlaying = "y", side = "right"),
        legend = list(x = 0.1, y = max(conversion_week$rate_conversion))
      )
  })

  output$rate_conversion_srep <- renderPlotly({
    conversion_srep <- data_filter() %>%
      group_by(name) %>%
      summarise(
        nb_vente = sum(achievement == "vente", na.rm = TRUE),
        nb_promesse = sum(achievement == "promesse", na.rm = TRUE),
        rate_efficiency = round(nb_vente / nb_promesse, 2)
      )
    plot_ly(data = conversion_srep, x = ~name, y = ~rate_efficiency, type = 'bar', name = "Taux Cumul Visit") %>%
      layout(
        title = "",
        xaxis = list(title = "Name"),
        yaxis = list(title = "Cumulative rate of efficiency (%)", tickformat = ".0%"),
        showlegend = FALSE
      )

  })
  
}
