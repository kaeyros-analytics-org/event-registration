download_data_ui <- function(id) {
  ns <- NS(id)
  fluentPage(
    # # Section supérieure avec les cartes
    # div(style="display: flex; justify-content: center; gap: 20px; margin: 0 250px;",
    #     catalog_overview_card("Cars", "Total number of cars", textOutput(ns("nb_cars"))),
    #     catalog_overview_card("Sales Revenue", "Total Sales", textOutput(ns("sales_cars")))
    # ),
    # Ligne vide pour l'espacement
    tags$div(style="height: 20px;"),  # Ajustez la hauteur selon vos besoins
    # fluidRow(
    #   uiOutput(ns("plot1")),
    #   uiOutput(ns("plot2")))
    # )
    # Section inférieure avec les graphiques
    div(class="container-fluid",
        div(class="row p-0 m-0", style= "justify-content: center; gap: 10px;",
            div(class="col-lg-11 pr-1 pl-0", id = "",
                # div(style = "display: flow-root; align-items: center; justify-content: space-between; margin-bottom: 20px;",
                #     DefaultButton.shinyInput(ns("btn_dwn"), "Download as csv", 
                #                              style = "background-color: #002157;
                #                  float:right; color: white; padding: 10px 20px; border: none;
                #                  border-radius: 4px; cursor: pointer;")),
                div(style = "display: flow-root; align-items: center; justify-content: space-between; margin-bottom: 20px;",
                    downloadButton(ns("btn_dwn"), "Download as .xlsx", #DefaultButton.shinyInput()
                                   style = "background-color: #002157;
                                 float:right; color: white; padding: 10px 20px; border: none;
                                 border-radius: 4px; cursor: pointer;")),
                uiOutput(ns("table_1")))
            
        )
    )
  )
}

download_data_server <- function(input, output, session, filterStates,shared_data,updated_data){
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
      # mensuel_data$DATE <- ymd(mensuel_data$DATE)
      # mensuel_data$`DATE P.V` <- ymd(mensuel_data$`DATE P.V`)
      mensuel_data
      
    })
  })
  
  output$table_1 <- renderUI({
    out <- accordionCard(accordionId = "accordionPlotcustomers_age",
                         headerId = 'plotchart1',
                         targetId = 'collapseCcplotchartCustomers_age',
                         headerContent = paste0("Filtered data", sep = ""),
                         bodyContent = reactableOutput(session$ns("data_table"), height = "400px"),
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  #observe(print(filtered_data()))
  output$data_table <- renderReactable({
    data_for_table <- filtered_data()
    #data_for_table$`DATE P.V` <- as_date(data_for_table$`DATE P.V`, origin = "1899-12-30")
    data_for_table$`DATE P.V` <- as.Date(data_for_table$`DATE P.V`, origin = "1899-12-30")
    data_for_table <- subset(data_for_table, DESCRIPTIONS!="TERENCE DZEAYE SHEY")
    max_date <- max(data_for_table$`DATE P.V`)
    
    data_for_table <- data_for_table %>%
      mutate(DATE = ymd(DATE)) #%>%
    #   mutate(`DATE P.V` = ymd(`DATE P.V`))
    # data_for_table$Date <- as.Date(data_for_table$Date)
    # data_for_table$`DATE P.V` <- as.Date(data_for_table$`DATE P.V`)
    # data_for_table <- filtered_data()%>%
    #   select(-c("REFUS", "C/CV"))
    reactable(
      data_for_table,
      striped = TRUE,
      highlight = TRUE,
      defaultPageSize = 50,
      bordered = TRUE,
      searchable = TRUE,
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
      ),
      rowStyle = function(index) {
        if (data_for_table$`DATE P.V`[index] >= max_date - 7) {
          list(backgroundColor = "#ffdc34")  # Couleur pour les lignes répondant à la condition
        } else {
          list(backgroundColor = "white")  # Couleur par défaut
        }
      }
    )
    
  })
  
  # shinyjs::onclick("btn_dwn", shinyjs::runjs(paste("Reactable.downloadDataCSV(",
  #                                                  "'",session$ns('data_table'),"'",
  #                                                  ", ","'",
  #                                                  "data",".csv","')",sep = "")))
  output$btn_dwn <- downloadHandler(
    filename = function() {
      "data.xlsx"
    },
    content = function(file) {
      writexl::write_xlsx(filtered_data(), file)
    }
  )
}