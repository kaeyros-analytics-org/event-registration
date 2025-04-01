date1 <- shiny::reactiveFileReader(1000, NULL, "./data/date1.rds", readRDS)
date2 <- shiny::reactiveFileReader(1000, NULL, "./data/date2.rds", readRDS)
cat <- shiny::reactiveFileReader(1000, NULL, "./data/cat.rds", readRDS)


dashboard_ui <- function(id){
  #h1("Welcome Winnie!")
  ns <- NS(id)
  fluentPage(
    #useShinyjs(),
    tags$style("
               .fieldGroup-82{border: none;}
               "),
    #actionButton(ns("refresh"), "Refresh"),
    ################### Header Card
    # div(class = "container-fluid", br(),
    #     # h3(style="margin-left:60px",
    #     #    "Vue d'ensemble des analyses"),
    #     div(class = "row p-0 m-0",
    #         div(class = "cards_overview_list",
    #             # Carte 1 - Actif user
    #             catalog_overview_card("Cars", "Total number", textOutput(ns("user_actif"))),
    #             # Carte 2 - Décaissements initiés
    #             catalog_overview_card("Sales", "Total (XAF)", textOutput(ns("total_pttc"))),
    #             # Carte 3 - Montant du décaissement
    #             catalog_overview_card("Sales", "Average day (XAF)",
    #                                   div(style = "font-size: 25px;", textOutput(ns("mean_pttc")))  # Espace ajouté avant "XAF"
    #             )
    #         )
    #     )
    # ),
    # layout_column_wrap(
    #   width = 1/4,#class = "cards_overview_list",#"bslib-grid",
      
      # First Value Box for "Nombre de visites"
      # value_box(#width="0.8",
      #   title = "Number of visits",
      #   value = textOutput(ns("user_actif")), #sum(custom_ventes$Freq)
      #   showcase = bs_icon("car-front-fill"),
      #   #full_screen = TRUE,
      #   theme = value_box_theme(bg = "#2B254B", fg = "#fff"), #ff5400
      #   class = "border"
      # ),
      
      div(class="cart-container",
        div(class="cart",
        span(class="img-car",
          tags$img(src = "./images/car1.svg", width = "80px")),
        span(class="second-child-container",
             span(class="second-child",
               p("Number of visits"),
               h1(textOutput(ns("user_actif")))
             )
         
          )
      ),
      div(class="cart",
          span(class="img-car",
               tags$img(src = "./images/cash2.svg", width = "80px")),
          span(class="second-child-container",
               span(class="second-child",
                    p("Total sales (FCFA)"),
                    h1(textOutput(ns("total_pttc")))
               )
               
          )
      ),
      div(class="cart",
          span(class="img-car",
               tags$img(src = "./images/cash2.svg", width = "80px")),
          span(class="second-child-container",
               span(class="second-child",
                    p("Sales average day (FCFA)"),
                    h1(textOutput(ns("mean_pttc")))
               )
               
          )
      ),
      div(class="cart",
          span(class="img-car",
               tags$img(src = "./images/car1.svg", width = "80px")),
          span(class="second-child-container",
               span(class="second-child",
                    p("Average number of visits"),
                    h1(textOutput(ns("mean_visits")))
               )
               
          )
      )),
      
      # Second Value Box for "Total des ventes"
      # value_box(
      #   title = "Total sales (FCFA)",
      #   value = textOutput(ns("total_pttc")),#length(unique(data()$name)), # Assuming 'data' is defined in your environment
      #   showcase = bs_icon("cash-stack"),
      #   #full_screen = TRUE,
      #   theme = value_box_theme(bg = "#2B254B", fg = "#fff"),
      #   class = "border"),
      # value_box(
      #   title = "Sales average day (FCFA)",
      #   value = textOutput(ns("mean_pttc")),#length(unique(data()$name)), # Assuming 'data' is defined in your environment
      #   showcase = bs_icon("cash-stack"),
      #   #full_screen = TRUE,
      #   theme = value_box_theme(bg = "#2B254B", fg = "#fff"),
      #   class = "border"),
      # value_box(
      #   title = "Average number of visits",
      #   value = textOutput(ns("mean_visits")),#length(unique(data()$name)), # Assuming 'data' is defined in your environment
      #   showcase = bs_icon("car-front-fill"),
      #   #full_screen = TRUE,
      #   theme = value_box_theme(bg = "#2B254B", fg = "#fff"),
      #   class = "border")
    #),
    
    
    
    br(), ######### Make Space
    fluidRow(
      bs4Card(
        title = "Numbers of visits per day",
        width = 6,
        status = "gray-dark",
        solidHeader = TRUE,
        collapsible = TRUE,
        elevation = 4,
        maximizable = TRUE,
        plotlyOutput(ns("plot1"))
      ),
      bs4Card(
        title = "Sales per day",
        width = 6,
        status = "gray-dark",
        solidHeader = TRUE,
        collapsible = TRUE,
        elevation = 4,
        maximizable = TRUE,
        plotlyOutput(ns("plot2"))
      )
    ), br(),
    fluidRow(
      bs4Card(
        title = "Number of visits per category of cars",
        width = 6,
        status = "gray-dark",
        solidHeader = TRUE,
        collapsible = TRUE,
        elevation = 4,
        maximizable = TRUE,
        plotlyOutput(ns("plot3"))
      ),
      bs4Card(
        title = "Sales per category per day",
        width = 6,
        status = "gray-dark",
        solidHeader = TRUE,
        collapsible = TRUE,
        elevation = 4,
        maximizable = TRUE,
        plotlyOutput(ns("plot4"))
      )
      # bs4Card(
      #   title = "Sales per category",
      #   width = 6,
      #   status = "gray-dark",
      #   solidHeader = TRUE,
      #   collapsible = TRUE,
      #   elevation = 4,
      #   maximizable = TRUE,
      #   plotlyOutput(ns("plot5"))
      # )
    ),
    # bs4Card(
    #   title = "Sales per category per day",
    #   width = 12,
    #   status = "gray-dark",
    #   solidHeader = TRUE,
    #   collapsible = TRUE,
    #   elevation = 4,
    #   maximizable = TRUE,
    #   plotlyOutput(ns("plot4"))
    # )
    
    # div(class="container-fluid",
    #     div(class="row p-0 m-0", style= "justify-content: center; gap: 10px;", 
    #         div(class="col-lg-6 pr-1 pl-0", id = "linechart",
    #             uiOutput(ns("nber_car_per_day"))),
    #         div(class="col-lg-5 pl-1 pr-0", id = "customer_age",
    #             uiOutput(ns("total_pttc_per_day"))))),
    
    
    
    
    # br(),
    # 
    # 
    # div(class="container-fluid",
    #     div(class="row p-0 m-0", style= "justify-content: center; gap: 10px;",
    #         div(class="col-lg-6 pr-1 pl-0", id = "",
    #             uiOutput(ns("category_rate"))),
    #         div(class="col-lg-5 pl-1 pr-0", id = "",
    #             uiOutput(ns("category_pttc"))
    #             #""
    #         )
    #     )
    # ),
    
    
    
    #br(),
    
    
    # div(class="container-fluid",
    #     div(class="row p-0 m-0", style= "justify-content: center; gap: 10px;",
    #         div(class="col-lg-11 pr-1 pl-0", id = "",
    #             div(style = "display: flow-root; align-items: center; justify-content: space-between; margin-bottom: 20px;",
    #                 DefaultButton.shinyInput(ns("btn_dwn"), "Download as csv", 
    #                                          style = "background-color: #002157;
    #                              float:right; color: white; padding: 10px 20px; border: none;
    #                              border-radius: 4px; cursor: pointer;")),
    #             uiOutput(ns("table_1")))
    #         
    #     )
    # ),
    # div(class="col-lg-6 pr-1 pl-0",
    #     textAreaInput("text1",label="",placeholder = "Enter your comments here...",height="200px",width="800px"),
    #     div(style="display: flex; justify-content: flex-end;",
    #         div(style = "margin-right: 10px;",
    #             ActionButton.shinyInput("save", "Save", style = "background-color: #3392c5;
    #                                     height:45px; color: #fff; font-weight: bold;width:50px")),
    #         ActionButton.shinyInput("edit", "Edit", style = "background-color: #3392c5;
    #                        height:45px; color: #fff; font-weight: bold;width:50px")
    #     )
    # )
    # textAreaInput("text1",label="",placeholder = "Ecrivez votre commentaire ici",height="200px",width="800px"),
    # ActionButton.shinyInput("save", "Save", style = "background-color: #3392c5;
    #                                     height:45px; color: #fff; font-weight: bold;width:50px"),
    # ActionButton.shinyInput("edit", "Edit", style = "background-color: #3392c5;
    #                                     height:45px; color: #fff; font-weight: bold;width:50px")
    
  )
}

dashboard_server <- function(input,output,session,shared_data){
  # First plot
  output$nber_car_per_day <- renderUI({
    # out <- accordionCard(accordionId = "accordionPlotcustomers_age",
    #                      headerId = 'plotchart1',
    #                      targetId = 'collapseCcplotchartCustomers_age',
    #                      headerContent = paste0("Numbers of cars per day", sep = ""),
    #                      bodyContent = plotlyOutput(session$ns("plot1")),
    #                      iconId = paste0("_plotchart"),
    #                      dataset = "dataset")
  })
  
  # Second plot
  output$total_pttc_per_day <- renderUI({
    out <- accordionCard(accordionId = "accordionPlotmost_popular_product",
                         headerId = 'plotchart3',
                         targetId = 'collapseCcplotchartMost_popular_product',
                         headerContent = paste0("Sales per day", sep = ""),
                         bodyContent = plotlyOutput(session$ns("plot2")),
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
    
  })
  
  # Third plot
  output$category_rate <- renderUI({
    out <- accordionCard(accordionId = "accordionPlotmost_popular_product",
                         headerId = 'plotchart3',
                         targetId = 'collapseCcplotchartMost_popular_product',
                         headerContent = paste0("Number of visits per category of cars", sep = ""),
                         bodyContent = plotlyOutput(session$ns("plot3")),
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
    
  })
  
  
  # Forth plot
  output$category_pttc <- renderUI({
    out <- accordionCard(accordionId = "accordionPlotcustomers_age",
                         headerId = 'plotchart1',
                         targetId = 'collapseCcplotchartCustomers_age',
                         headerContent = paste0("Sales per category per day", sep = ""),
                         bodyContent = plotlyOutput(session$ns("plot4")),
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  
  
  # Fifth plot
  output$table_1 <- renderUI({
    out <- accordionCard(accordionId = "accordionPlotcustomers_age",
                         headerId = 'plotchart1',
                         targetId = 'collapseCcplotchartCustomers_age',
                         headerContent = paste0("Filtered data", sep = ""),
                         bodyContent = reactableOutput(session$ns("data_table"), height = "400px"),
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  #observe(print(input$categoryInput))
  observeEvent(input$filter_data, {
    filtered_data <- reactive({
      #req(input$categoryInput,input$dateRangeInput[1],input$dateRangeInput[2])
      #mensuel_data <- getReactiveData()
      #mensuel_data <- mensuel_data()
      req(shared_data())
      mensuel_data <- shared_data()
      mensuel_data <- mensuel_data %>%
        filter(DATE >= ymd(input$dateRangeInput[1]) &
                 DATE <= ymd(input$dateRangeInput[2]))%>%
        filter(if (length(input$categoryInput) != 0 && !"All" %in% input$categoryInput)  `CAT`  %in% input$categoryInput  else TRUE) #%>%
      #filter(if (length(filterStates$accepteSelected) != 0 && !"All" %in% filterStates$accepteSelected)  ACCEPTE  %in% filterStates$accepteSelected  else TRUE)
      mensuel_data$DATE <- ymd(mensuel_data$DATE)
      mensuel_data
      })
  })
  observe(print(filtered_data()))
  # observeEvent(input$view_more_data, {
  #   print("View more data button clicked")
  #   filtered_data <- reactive({
  #     #req(input$categoryInput,input$dateRangeInput[1],input$dateRangeInput[2])
  #     #mensuel_data <- getReactiveData()
  #     #mensuel_data <- mensuel_data()
  #     req(shared_data())
  #     mensuel_data <- shared_data()
  #     mensuel_data %>%
  #       filter(DATE >= ymd(input$dateRangeInput[1]) &
  #                DATE <= ymd(input$dateRangeInput[2]))%>%
  #       filter(if (length(input$categoryInput) != 0 && !"All" %in% input$categoryInput)  `CAT`  %in% input$categoryInput  else TRUE) #%>%
  #     #filter(if (length(filterStates$accepteSelected) != 0 && !"All" %in% filterStates$accepteSelected)  ACCEPTE  %in% filterStates$accepteSelected  else TRUE)
  # 
  #   })
  # })
  
  output$plot1 <- renderPlotly({
    # Agréger les données par date
    vehicule_par_jour <- filtered_data() %>%
      group_by(DATE) %>%
      summarise(nombre_vehicules = n()) %>%
    mutate(DATE = ymd(DATE))
    
    # Créer le graphique
    fig <- ggplot(data = vehicule_par_jour, aes(x = DATE, y = nombre_vehicules)) +
      geom_line(color = "#480ca8") +  # Tracer les lignes
      scale_x_date(date_labels = "%b %y") + #%d-%b-%Y
      #geom_point(color = "#002157") +  # Si vous voulez ajouter des points
      labs(title = "", 
           x = "Date", 
           y = "Number of visits") +
      theme_minimal() +  # Utiliser un thème minimal
      theme(axis.text.x = element_text(angle = 45, hjust = 1))   #%>%
    ggplotly(fig) %>%
      config(
        displayModeBar = TRUE,
        displaylogo = FALSE,
        modeBarButtonsToRemove = list(
          'sendDataToCloud',
          'toImage',
          'zoomIn2d',
          "zoomOut2d",
          'toggleSpikelines',
          'resetScale2d',
          'lasso2d',
          #'zoom2d',
          'pan2d',
          'select2d',
          'hoverClosestCartesian',
          'hoverCompareCartesian'
        ),
        scrollZoom = FALSE
      )


    # # Créer le graphique en barres avec Plotly
    # vehicule_par_jour %>%
    #   e_charts(DATE) %>%
    #   e_line(nombre_vehicules, name = "Nombre de véhicules", symbol = "circle", 
    #          symbolSize = 8, itemStyle = list(color = "#002157")) %>%
    #   e_tooltip(trigger = "axis", 
    #             formatter = htmlwidgets::JS("function(params) {
    #           return params[0].name + ': ' + params[0].value;
    #         }")) %>%
    #   e_x_axis(name = "Date", axisLabel = list(rotate = 45)) %>%
    #   e_y_axis(name = "Nombre de voitures") %>%
    #   e_title("") %>%
    #   e_legend(show = FALSE) %>%
    #   e_datazoom(show = FALSE) %>%
    #   e_grid(left = '3%', right = '4%', bottom = '3%', containLabel = TRUE)
    
    # plotly::plot_ly(data = vehicule_par_jour,
    #                 x = ~DATE,
    #                 y = ~nombre_vehicules,
    #                 marker = list(color=c("#002157")),
    #                 text = paste(vehicule_par_jour$nombre_vehicules, sep = ""), textposition = 'outside',
    #                 colors = c("red"), type = 'scatter', mode = 'lines') %>%
    #   layout(title = "",
    #          xaxis = list(title = "Date", tickangle = 45),
    #          yaxis = list(title = "Number of cars")) %>%
    #   config(displayModeBar = TRUE, displaylogo = FALSE, modeBarButtonsToRemove = list(
    #     'sendDataToCloud',
    #     'toImage',
    #     'zoomIn2d',
    #     "zoomOut2d",
    #     'toggleSpikelines',
    #     'resetScale2d',
    #     'lasso2d',
    #     'zoom2d',
    #     'pan2d',
    #     'select2d',
    #     'hoverClosestCartesian',
    #     'hoverCompareCartesian'),
    #     zoom2d = FALSE,
    #     scrollZoom = FALSE)
  })
  
  output$plot2 <- plotly::renderPlotly({
    
    # Regrouper les données par date et calculer le total des PTTC
    data_agg <- filtered_data() %>%
      group_by(DATE) %>%
      summarise(Total_P_TTC = sum(PTTC, na.rm = TRUE),
                nb_vehicules = n())
    
    plotly::plot_ly(
      data = data_agg,
      x = ~DATE,
      y = ~Total_P_TTC,
      type = 'scatter',
      mode = 'lines', # Seules les lignes
      # colors = c("#483D8B", "slateblue", "#0077BE", "#5696CC", "#82B7FE",
      #            "#76B7DA", "#B7E5FF", "#A6DAFF")
      # colors = c("slateblue", "#008080", "#6B8E23", "#BDB76B")
      # colline <- c("slateblue", "#008080", "#BDB76B", "#B8860B", "#FFF8DC", "#A9A9A9", "#FF7F50", "#5F9EA0")
      # colors = c("#DB7093", "#9370DB", "#87CEEB", "#66CDAA")
      
      line = list(color = "#DC3545"), 
      text = ~paste("Date:", DATE, "<br>Sales (FCFA):", formatC(Total_P_TTC, format = "f", digits = 0, big.mark = "."),
                    "<br>Number of vehicles:", nb_vehicules),  # Format du texte d'affichage
      hoverinfo = 'text', 
      textposition = 'outside'
    ) %>%
      layout(
        title = "",
        xaxis = list(title = "Date", tickangle = 45),
        yaxis = list(title = "Total amount (XAF)")
      ) %>%
      config(
        displayModeBar = TRUE,
        displaylogo = FALSE,
        modeBarButtonsToRemove = list(
          'sendDataToCloud',
          'toImage',
          'zoomIn2d',
          "zoomOut2d",
          'toggleSpikelines',
          'resetScale2d',
          'lasso2d',
          #'zoom2d',
          'pan2d',
          'select2d',
          'hoverClosestCartesian',
          'hoverCompareCartesian'
        ),
        scrollZoom = FALSE
      )
  })
  
  output$plot3 <- plotly::renderPlotly({
    
    # Calculer le pourcentage de chaque catégorie
    data_percentage <- filtered_data() %>%
      group_by(CAT) %>%
      summarise(Total = n(),
                sales = sum(PTTC, na.rm = TRUE)) %>%
      mutate(Pourcentage = round(Total / sum(Total) * 100, 2))
    print(data_percentage)
    # Créer le graphique en barres avec Plotly
    plotly::plot_ly(data = data_percentage,
                    x = ~CAT,
                    y = ~Total,
                    marker = list(color=c("#DC3545")),
                    text = paste(formatC(data_percentage$sales, format = "f", digits = 0, big.mark = "."), sep = ""), 
                    hovertext = ~paste("Category:", CAT, "<br>Number of cars:", Total,"<br>Sales:", formatC(sales, format = "f", digits = 0, big.mark = ".")),  # Format du texte d'affichage
                    hoverinfo = 'text', 
                    textposition = 'outside',
                    colors = c("red"), type = 'bar') %>%
      layout(title = "",
             xaxis = list(title = "CAT", tickangle = 0),
             yaxis = list(title = "Total")) %>%
      config(displayModeBar = TRUE, displaylogo = FALSE, modeBarButtonsToRemove = list(
        'sendDataToCloud',
        'toImage',
        'zoomIn2d',
        "zoomOut2d",
        'toggleSpikelines',
        'resetScale2d',
        'lasso2d',
        #'zoom2d',
        'pan2d',
        'select2d',
        'hoverClosestCartesian',
        'hoverCompareCartesian'),
        zoom2d = FALSE,
        scrollZoom = FALSE)
  })
  
  output$plot4 <- plotly::renderPlotly({
    
    # Calculer le total PTTC par jour et par catégorie
    data_summary <- filtered_data() %>%
      group_by(DATE, CAT) %>%
      summarise(Total_P_TTC = sum(PTTC), .groups = 'drop')
    
    plotly::plot_ly(
      data_summary, 
      x = ~DATE, 
      y = ~Total_P_TTC, 
      color = ~CAT, 
      colors = c("#0077b6","#480ca8","#ef3c2d","#2c0735","#fb3640","#002157"),
      type = 'scatter', 
      mode = 'lines', # Seulement des lignes, pas de points
      text = ~paste("Date:", DATE, "<br>Sales (FCFA):", formatC(Total_P_TTC, format = "f", digits = 0, big.mark = "."),
                    "<br>Category:", CAT),  # Format du texte d'affichage
      hoverinfo = 'text'
    ) %>%
      layout(
        title = "",
        xaxis = list(title = "Date", tickangle = 45),
        yaxis = list(title = "Total PTTC (XAF)"),
        legend = list(title = list(text = "Category"))
      ) %>%
      config(
        displayModeBar = TRUE,
        displaylogo = FALSE,
        modeBarButtonsToRemove = list(
          'sendDataToCloud',
          'toImage',
          'zoomIn2d',
          "zoomOut2d",
          'toggleSpikelines',
          'resetScale2d',
          'lasso2d',
          #'zoom2d',
          'pan2d',
          'select2d',
          'hoverClosestCartesian',
          'hoverCompareCartesian'
        ),
        zoom2d = FALSE,
        scrollZoom = FALSE
      )
  })
  
  
  output$data_table <- renderReactable({
    
    data_for_table <- filtered_data()%>%
      select(-c("REFUS", "C/CV"))
    reactable(
      data_for_table,
      striped = TRUE,
      highlight = TRUE,
      defaultPageSize = 50,
      bordered = TRUE,
      theme = reactableTheme(
        borderColor = "#B5E4FB",
        stripedColor = "#F5F9FF",
        highlightColor = "#D9E4FF",
        cellPadding = "10px 15px",
        style = list(
          fontFamily = "Segoe UI, Helvetica, Arial, sans-serif",
          fontSize = "0.8rem",
          backgroundColor = "#ffffff",
          color = "#333333",
          borderRadius = "8px",  # Coins arrondis pour plus de douceur
          boxShadow = "0px 4px 12px rgba(0, 0, 0, 0.1)"  # Ombre pour un effet de profondeur
        ),
        headerStyle = list(
          backgroundColor = "#002157",
          color = "#ffffff",
          fontWeight = "bold",
          textAlign = "left",  # Aligner les en-têtes à gauche
          padding = "10px 15px"
        ),
        rowStyle = list(
          textAlign = "left",  # Alignement du texte des lignes à gauche
          borderRadius = "8px"  # Coins arrondis des cellules pour correspondre au tableau général
        ),
        searchInputStyle = list(
          width = "100%",
          padding = "8px",
          borderRadius = "8px",
          border = "1px solid #B5E4FB"
        )
      )
    )
    
  })
  
  output$plot5 <- plotly::renderPlotly({
    
    # Calculer le pourcentage de chaque catégorie
    data_percentage <- filtered_data() %>%
      group_by(CAT) %>%
      summarise(Total_P_TTC = sum(PTTC)) %>%
      mutate(Pourcentage = round(Total_P_TTC / sum(Total_P_TTC) * 100, 2))
    print(data_percentage)
    # Créer le graphique en barres avec Plotly
    plotly::plot_ly(data = data_percentage,
                    x = ~CAT,
                    y = ~Total_P_TTC,
                    marker = list(color=c("#DC3545")),
                    text = paste(data_percentage$Total_P_TTC, sep = ""), 
                    #text = ~paste("Category:", CAT, "<br>Number of cars:", Total),  # Format du texte d'affichage
                    hoverinfo = 'text', 
                    textposition = 'outside',
                    colors = c("red"), type = 'bar', mode = 'lines+markers') %>%
      layout(title = "",
             xaxis = list(title = "CAT", tickangle = 0),
             yaxis = list(title = "Total")) %>%
      config(displayModeBar = TRUE, displaylogo = FALSE, modeBarButtonsToRemove = list(
        'sendDataToCloud',
        'toImage',
        'zoomIn2d',
        "zoomOut2d",
        'toggleSpikelines',
        'resetScale2d',
        'lasso2d',
        #'zoom2d',
        'pan2d',
        'select2d',
        'hoverClosestCartesian',
        'hoverCompareCartesian'),
        zoom2d = FALSE,
        scrollZoom = FALSE)
  })
  
  output$user_actif <- renderText({
    nrow(filtered_data())
    #length(unique(filtered_data()$IMMATRI))
  })
  
  
  output$total_pttc <- renderText({
    total <- sum(filtered_data()$PTTC,na.rm = TRUE)
    formatted_total <- formatC(total, format = "f", digits = 0, big.mark = ".")
    formatted_total 
  })
  
  output$mean_pttc <- renderText({
    #mean(filtered_data()$PTTC, na.rm=TRUE)
    #total <- mean(filtered_data()$PTTC, na.rm=TRUE)
    total <- sum(filtered_data()$PTTC, na.rm=TRUE)/length(unique(filtered_data()$DATE))
    formatted_total <- formatC(total, format = "f", digits = 0, big.mark = ".")
    formatted_total
  })
  
  output$mean_visits <- renderText({
    total <- round(nrow(filtered_data())/length(unique(filtered_data()$DATE)))
  })
  
  shinyjs::onclick("btn_dwn", shinyjs::runjs(paste("Reactable.downloadDataCSV(",
                                                   "'",session$ns('data_table'),"'",
                                                   ", ","'",
                                                   "data table",".csv","')",sep = "")))
}