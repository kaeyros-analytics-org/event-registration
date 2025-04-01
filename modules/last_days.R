#source("./modules/import_data.R")

# last_day_ui <- function(id){
#   ns <- NS(id)
#   fluentPage(
#         div(style="display: flex; justify-content: center; gap: 20px; margin: 0 250px;",
#         catalog_overview_card("Cars", "Total number of cars", 21),
#         catalog_overview_card("Sales Revenue", "Total Sales", 21)
#     ),
#     tags$br(),
#     # div(style="display:flex; gap:20px",
#     #     uiOutput(ns("plot1")),
#     #     uiOutput(ns("plot2"))
#     # )
#     div(class="container-fluid",
#         div(class="row p-0 m-0", style= "justify-content: center; gap: 10px;",
#             div(class="col-lg-6 pr-1 pl-0", id = "linechart",
#                 uiOutput(ns("plot1"))),
#             div(class="col-lg-5 pl-1 pr-0", id = "customer_age",
#                 uiOutput(ns("plot2")))))
#   )
#   
# }
last_day_ui <- function(id) {
  ns <- NS(id)
  fluentPage(
    # Section supérieure avec les cartes
    # div(style="display: flex; justify-content: center; gap: 20px; margin: 0 250px;",
    #     catalog_overview_card("Cars", "Total number of cars", textOutput(ns("nb_cars"))),
    #     catalog_overview_card("Sales Revenue", "Total Sales", textOutput(ns("sales_cars")))
    # ),
    # div(style="text-align: center;",
    #     h4("Latest update:",as.Date(max(mensuel_data$DATE)-1))
    # ),
    #h2("Latest update:",as.Date(max(mensuel_data$DATE)-1)),
    layout_column_wrap(
      width = 1/2,class = "card_last_day",#"bslib-grid",
      
      # First Value Box for "Nombre de visites"
      value_box(#width="0.1",
        title = "Number of visits",
        value = textOutput(ns("nb_cars")), #sum(custom_ventes$Freq)
        paste("Yesterday:",as.Date(max(mensuel_data$DATE)-1)),
        tags$br(),
        #textOutput(ns("text1"))
        paste("Latest updated data:",max(mensuel_data$DATE)),
        showcase = bs_icon("car-front-fill"),
        #full_screen = TRUE,
        theme = value_box_theme(bg = "#2B254B", fg = "#fff"), #ff5400
        class = "border"
      ),
      
      # Second Value Box for "Total des ventes"
      value_box(
        title = "Total sales (FCFA)",
        value = textOutput(ns("sales_cars")),
        paste("Yesterday:",as.Date(max(mensuel_data$DATE)-1)),
        tags$br(),
        #textOutput(ns("text2"))
        paste("Latest updated data:",max(mensuel_data$DATE)),
        showcase = bs_icon("cash-stack"),
        #full_screen = TRUE,
        theme = value_box_theme(bg = "#2B254B", fg = "#fff"),
        class = "border")
    ),
    # Ligne vide pour l'espacement
    tags$div(style="height: 20px;"),  # Ajustez la hauteur selon vos besoins
    # fluidRow(
    #   uiOutput(ns("plot1")),
    #   uiOutput(ns("plot2")))
    # )
    # Section inférieure avec les graphiques
  div(class="container-fluid",
      div(class="row p-0 m-0", style="justify-content: center; gap: 10px;margin: 0 250px;",
          div(class="col-lg-5 pr-1 pl-0", id="linechart",
              uiOutput(ns("plot1"))),
          div(class="col-lg-5 pl-1 pr-0", id="customer_age",
              uiOutput(ns("plot2")))
      )
  ),
  div(class="container-fluid",
      div(class="row p-0 m-0", style="justify-content: center; gap: 10px;margin: 0 250px;",
          div(class="col-lg-5 pr-1 pl-0", id="linechart",
              uiOutput(ns("plot3"))),
          div(class="col-lg-5 pl-1 pr-0", id="customer_age",
              uiOutput(ns("plot4")))
      )
  )
  )
}


last_day_server <- function(input, output, session, filterStates,shared_data){
  
  filtered_data <- reactive({
    mensuel_data <- shared_data()#shared_data$data
    mensuel_data %>%
      filter(DATE >= as.Date(max(mensuel_data$DATE)) -1 & #ymd(filterStates$date_start
               DATE <= as.Date(max(mensuel_data$DATE)) -1) #%>%
      #filter(if (length(filterStates$categorySelected) != 0 && !"All" %in% filterStates$categorySelected)  `CAT`  %in% filterStates$categorySelected  else TRUE) #%>%
      #filter(if (length(filterStates$accepteSelected) != 0 && !"All" %in% filterStates$accepteSelected)  ACCEPTE  %in% filterStates$accepteSelected  else TRUE)
    
  })
  
  filtered_data_7days <- reactive({
    mensuel_data <- shared_data()#shared_data$data
    mensuel_data %>%
      filter(DATE >= as.Date(max(mensuel_data$DATE))-7 & #Sys.Date()-7 & #ymd(filterStates$date_start
               DATE <= as.Date(max(mensuel_data$DATE))) #%>%
      #filter(if (length(filterStates$categorySelected) != 0 && !"All" %in% filterStates$categorySelected)  `CAT`  %in% filterStates$categorySelected  else TRUE) #%>%
      #filter(if (length(filterStates$accepteSelected) != 0 && !"All" %in% filterStates$accepteSelected)  ACCEPTE  %in% filterStates$accepteSelected  else TRUE)
    
  })
  filtered_data_lastmonth <- reactive({
    mensuel_data <- shared_data()#shared_data$data
    mensuel_data %>%
      filter(DATE >= as.Date(max(mensuel_data$DATE))-30 & #Sys.Date()-7 & #ymd(filterStates$date_start
               DATE <= as.Date(max(mensuel_data$DATE))) #%>%
  })
  
  output$nb_cars <- renderText({
    nrow(filtered_data())
  })
  output$text1 <- renderText({
    #as.Date(max(mensuel_data$DATE) - 1)
    format(as.Date(max(mensuel_data$DATE) - 1), "%Y-%m-%d")
  })
  
  output$text2 <- renderText({
    format(as.Date(max(mensuel_data$DATE) - 1), "%Y-%m-%d")
    #as.Date(max(mensuel_data$DATE) - 1)
  })
  
  output$sales_cars <- renderText({
    formatC(sum(filtered_data()$PTTC), format = "f", digits = 0, big.mark = ".")
  })
  output$plot1 <- renderUI({
    out <- accordionCard(accordionId = "accordionPlotcustomers_age",
                         headerId = 'plotchart1',
                         targetId = 'collapseCcplotchartCustomers_age',
                         headerContent = paste0("Last 7 days visits", sep = ""),
                         bodyContent = plotlyOutput(session$ns("plot11")),
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  output$plot2 <- renderUI({
    out <- accordionCard(accordionId = "accordionPlotcustomers_age",
                         headerId = 'plotchart1',
                         targetId = 'collapseCcplotchartCustomers_age',
                         headerContent = paste0("Last 7 days sales", sep = ""),
                         bodyContent = plotlyOutput(session$ns("plot12")),
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  output$plot3 <- renderUI({
    out <- accordionCard(accordionId = "accordionPlotcustomers_age",
                         headerId = 'plotchart1',
                         targetId = 'collapseCcplotchartCustomers_age',
                         headerContent = paste0("Last month visits", sep = ""),
                         bodyContent = plotlyOutput(session$ns("last_month_cars")),
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  output$plot4 <- renderUI({
    out <- accordionCard(accordionId = "accordionPlotcustomers_age",
                         headerId = 'plotchart1',
                         targetId = 'collapseCcplotchartCustomers_age',
                         headerContent = paste0("Last month sales", sep = ""),
                         bodyContent = plotlyOutput(session$ns("last_month_sales")),
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  
  output$plot11 <- plotly::renderPlotly({
    # Agréger les données par date
    vehicule_par_jour <- filtered_data_7days() %>%
      group_by(DATE) %>%
      summarise(nombre_vehicules = n())
    
    plotly::plot_ly(data = vehicule_par_jour,
                    x = ~DATE,
                    y = ~nombre_vehicules,
                    marker = list(color=c("#002157")),
                    #text = paste(vehicule_par_jour$nombre_vehicules, sep = ""), 
                    text = ~paste("Date:", DATE, "<br>Number of vehicles:", nombre_vehicules),  # Format du texte d'affichage
                    hoverinfo = 'text', 
                    textposition = 'outside',
                    colors = c("red"), type = 'scatter', mode = 'lines+markers') %>%
      layout(title = "",
             xaxis = list(title = "Date", tickangle = 45,tickformat = "%b %d %Y"),
             yaxis = list(title = "Number of visits")) %>%
      config(displayModeBar = TRUE, displaylogo = FALSE, modeBarButtonsToRemove = list(
        'sendDataToCloud','toImage','zoomIn2d',"zoomOut2d",'toggleSpikelines','resetScale2d',
        'lasso2d','pan2d','select2d','hoverClosestCartesian','hoverCompareCartesian'),
        zoom2d = FALSE,
        scrollZoom = FALSE)
  })
  
  output$plot12 <- plotly::renderPlotly({
    
    # Regrouper les données par date et calculer le total des PTTC
    data_agg <- filtered_data_7days() %>%
      group_by(DATE) %>%
      summarise(Total_P_TTC = sum(PTTC, na.rm = TRUE))
    
    # Créer le graphique en barres avec Plotly
    plotly::plot_ly(data = data_agg,
                    x = ~DATE, 
                    y = ~Total_P_TTC,
                    marker = list(color=c("#002157")),
                    #text = paste(data_agg$Total_P_TTC, sep = ""), 
                    text = ~paste("Date:", DATE, "<br>Sales (FCFA):", Total_P_TTC),  # Format du texte d'affichage
                    hoverinfo = 'text', 
                    textposition = 'outside',
                    colors = c("red"), type = 'scatter', mode = 'lines+markers') %>%
      layout(title = "",
             xaxis = list(title = "Date", tickangle = 45,tickformat = "%b %d %Y"),
             yaxis = list(title = "Total amount (XAF)")) %>%
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
  
  output$last_month_cars <- plotly::renderPlotly({
    # Agréger les données par date
    vehicule_par_jour <- filtered_data_lastmonth() %>%
      group_by(DATE) %>%
      summarise(nombre_vehicules = n())
    
    plotly::plot_ly(data = vehicule_par_jour,
                    x = ~DATE,
                    y = ~nombre_vehicules,
                    marker = list(color=c("#002157")),
                    #text = paste(vehicule_par_jour$nombre_vehicules, sep = ""), 
                    text = ~paste("Date:", DATE, "<br>Number of vehicles:", nombre_vehicules),  # Format du texte d'affichage
                    hoverinfo = 'text', 
                    textposition = 'outside',
                    colors = c("red"), type = 'scatter', mode = 'lines+markers') %>%
      layout(title = "",
             xaxis = list(title = "Date", tickangle = 45,tickformat = "%b %d %Y"),
             yaxis = list(title = "Number of visits")) %>%
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
  
  output$last_month_sales <- plotly::renderPlotly({
    
    # Regrouper les données par date et calculer le total des PTTC
    data_agg <- filtered_data_lastmonth() %>%
      group_by(DATE) %>%
      summarise(Total_P_TTC = sum(PTTC, na.rm = TRUE))
    
    # Créer le graphique en barres avec Plotly
    plotly::plot_ly(data = data_agg,
                    x = ~DATE, 
                    y = ~Total_P_TTC,
                    marker = list(color=c("#002157")),
                    #text = paste(data_agg$Total_P_TTC, sep = ""), 
                    text = ~paste("Date:", DATE, "<br>Sales (FCFA):", Total_P_TTC),  # Format du texte d'affichage
                    hoverinfo = 'text', 
                    textposition = 'outside',
                    colors = c("red"), type = 'scatter', mode = 'lines+markers') %>%
      layout(title = "",
             xaxis = list(title = "Date", tickangle = 45,tickformat = "%b %d %Y"),
             yaxis = list(title = "Total amount (XAF)")) %>%
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
}