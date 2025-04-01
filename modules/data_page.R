
data_ui <-  function(id) {
  ns <- NS(id)
  fluidPage(
    tags$br(),
    #downloadButton(ns("downloadData"), "Download data",icon = shiny::icon("download")),
    downloadButton(ns("btn_dwn"), "Download as .xlsx", #DefaultButton.shinyInput()
                   style = "background-color: #002157;
                                 float:right; color: white; padding: 10px 20px; border: none;
                                 border-radius: 4px; cursor: pointer;"),
    tags$br(),
    tags$br(),
  reactableOutput(ns("data")))

}

data_server <- function(input, output, session, filterStates){
  data3 <- shiny::reactiveFileReader(1000, NULL, "./data/data_reactive.rds", readRDS)
  filterStates <- reactiveValues(
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
  
  output$data <- renderReactable({
    data <- data_filter() %>% select(createdAt.x,name,city,zone, address,customer_name,business_name,contact,type_of_business,category,
                                     visit_objective, visit_carried_out,comment,prospecting_type,customer_decision,achievement,suggested_introductory_price,
                                     proposed_monthly_price) %>%
      rename("Date"="createdAt.x") %>%
      arrange(desc(Date))
    #rename("Category"="type_of_outlet")
    
    reactable(data,
              # columns = list(
              #   Image = colDef(html = TRUE)  # Permet d'afficher HTML dans la colonne
              # ),
              defaultPageSize = 9,searchable = TRUE,
              highlight = TRUE,
              bordered = TRUE,
              striped = TRUE,
              sortable=TRUE,
              theme = reactableTheme(
                borderColor = "#dfe2e5",
                highlightColor = "#f0f8ff",
                cellStyle = list(
                  borderBottom = "1px solid #dfe2e5"
                ),
                rowStyle = list(
                  "&:hover" = list(
                    backgroundColor = "#f5f5f5"
                  )
                )))
  })
  
  output$btn_dwn <- downloadHandler(
    filename = function() {
      "data.xlsx"
    },
    content = function(file) {
      writexl::write_xlsx(data_filter(), file)
    }
  )
  

}
