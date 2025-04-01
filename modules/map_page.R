world_shapefile_path <- "./data/Africa_Boundaries-shp/Africa_Boundaries.shp"  # Remplacez par le chemin vers votre shapefile
world_sf <- read_sf(world_shapefile_path)

map_ui <- function(id){

  ns <- NS(id)
  fluentPage(
    h4("Map Overview"),
    leafletOutput(ns("map_plot"), width = "100%", height = 590)
  )
}


map_server <- function(input, output, session, filterStates){
  # data <- data()
  # data_filter <- reactive({
  #   data %>%
  #     filter(createdAt.x >= filterStates$date_start & createdAt.x <= filterStates$date_end) %>%
  #     filter(if (!"TOUT" %in% filterStates$selectedCity) city == filterStates$selectedCity  else TRUE) %>% #filterStates$selectedCity
  #     filter(if (length(filterStates$selectedtyp_pdv) != 0 && !"TOUT" %in% filterStates$selectedtyp_pdv) type_of_outlet %in% filterStates$selectedtyp_pdv  else TRUE) %>%
  #     filter(if (length(filterStates$selectedtyp_prospect) != 0 && !"TOUT" %in% filterStates$selectedtyp_prospect) prospecting_type %in% filterStates$selectedtyp_prospect  else TRUE) %>%
  #     filter(if (!"TOUT" %in% filterStates$commercial) name == filterStates$commercial  else TRUE) #filterStates$selectedCity
  #
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

  output$map_plot <- renderLeaflet({
    d <- data_filter() %>% group_by(city,longitude,latitude) %>% summarise(count=n())
    choosen_countries <- "Cameroon"
    target_map <- world_sf %>% filter(NAME_0 %in% choosen_countries)
    polygon_popup <- paste0("<strong>",d$city,"</strong>", "<br>",
                            "<strong>Nombre de visites: </strong>", d$count
    )%>%
      lapply(htmltools::HTML)

    # target_map <- subset(world_map, country %in% choosen_countries)

    fig_map <- leaflet(data = target_map) %>%
      addTiles() %>%
      addPolygons(weight=1) %>%
      leaflet::addTiles() %>%
      leaflet::addAwesomeMarkers(
        data = d,
        lng = ~as.integer(longitude), lat = ~as.integer(latitude),
        popup = polygon_popup, label = polygon_popup,
        clusterOptions = leaflet::markerClusterOptions()
      )

    fig_map
  })
}










# # Fonction pour récupérer et afficher les informations des competitors
# get_competitors_map_info <- function(df, row_number) {
#   # Vérifier si le numéro de ligne est valide
#   if (row_number <= 0 || row_number > nrow(df)) {
#     stop("Le numéro de ligne est invalide.")
#   }
#
#   # Extraire la ligne spécifiée du dataframe
#   selected_row <- df[row_number, ]
#
#   # Initialiser une liste pour stocker les informations des competitors
#   competitors_info <- list()
#
#   # Parcourir les colonnes du dataframe pour extraire les informations des competitors
#   for (i in 1:5) {  # Supposons qu'il y a au maximum 5 competitors par point de vente
#     competitor <- selected_row[[paste0("competitor", i)]]
#     sku <- selected_row[[paste0("skucompetitor", i)]]
#     price <- selected_row[[paste0("pricecompetitor", i)]]
#
#     # Ajouter les informations du competitor à la liste
#     if (!is.na(competitor)) {
#       competitors_info[[paste0("competitor", i)]] <- competitor
#       competitors_info[[paste0("skucompetitor", i)]] <- sku
#       competitors_info[[paste0("pricecompetitor", i)]] <- price
#     }
#   }
#
#   return(competitors_info)
# }
#
# ########### Fonction pour définir une CARD Layout
# map_panel_card <- function(title, icon, content) {
#   div(class = "map_panel",
#       tagList(
#         h1(class = "title", title),
#         div(class = "content",
#             content,
#             icon
#         )
#       )
#   )
# }
#
#
# map_page_ui <- function(id){
#
#   ns <- NS(id)
#   fluentPage(
#     tags$head(
#       tags$link(rel = "stylesheet", type = "text/css", href = "./css/map_panel.css")
#     ),
#     textOutput(ns("pos_number")),
#     leafletOutput(ns("map_plot"), width = "100%", height = 590),
#     reactOutput(ns("reactPanel"))
#   )
# }
#
#
# map_page_server <- function(input, output, session, filterStates){
#
#   table_data <- reactive({
#     if(is.null(filterStates$countrySelected)){
#       map_all_data <- map_all_data  %>%
#         filter(RegistrationDate >= filterStates$date_start & RegistrationDate <= filterStates$date_end)
#     }else{
#       map_all_data <- map_all_data %>%
#         filter(country %in%  filterStates$countrySelected) %>%
#         filter(RegistrationDate >= filterStates$date_start & RegistrationDate <= filterStates$date_end)
#     }
#     map_all_data
#   })
#
#   #################### GESTION DU PANEL
#   observeEvent(input$map_plot_marker_click, {
#     isPanelOpen(TRUE)
#   })
#   observeEvent(input$hidePanel, isPanelOpen(FALSE))
#
#   ###################  Je vérifie que je suis dans la page MAP
#   observeEvent(filterStates$dataNavi$dataset ,{
#     if(filterStates$dataNavi$dataset == "Map"){
#       output$map_plot <- renderLeaflet({
#         # generate the wordl map
#         world <- maps::map("world", fill=TRUE, plot=FALSE)
#         world_map <- maptools::map2SpatialPolygons(world, sub(":.*$", "", world$names))
#         world_map <- sp::SpatialPolygonsDataFrame(world_map,
#                                                   data.frame(country=names(world_map),
#                                                              stringsAsFactors=FALSE),
#                                                   FALSE)
#
#         choosen_countries <- allCountry_final
#
#         target_map <- subset(world_map, country %in% choosen_countries)
#
#         fig_map <- leaflet(data = target_map) %>%
#           addTiles() %>%
#           addPolygons(weight=1) %>%
#           leaflet::addTiles() %>%
#           leaflet::addAwesomeMarkers(
#             layerId = ~id,
#             data = table_data(),
#             lng = ~`GPS Longitude`, lat = ~`GPS Latitude`,
#             label = paste(table_data()$`posname`,
#                           table_data()$`Consumer`,
#                           sep = " / "),
#             clusterOptions = leaflet::markerClusterOptions())
#
#         fig_map
#       }) # end output$map_plot
#     }
#   })
#
#   ################ je récupère le nombre de pays par rapport au filtre
#   output$pos_number <- renderText({
#     paste("POS numbers: ", nrow(table_data()), sep = "")
#   })
#
#   ################## On récupère les données du compétitor sur lequel on a cliqué.
#   competitors_map_info <- reactive({
#     if(is.null(input$map_plot_marker_click$id)){
#       get_competitors_map_info(map_all_data, 1)
#     }else {
#       get_competitors_map_info(map_all_data, input$map_plot_marker_click$id)
#     }
#   })
#   isPanelOpen <- reactiveVal(FALSE)
#   output$reactPanel <- renderReact({
#     Panel(
#       headerText = "POS Details",
#       isOpen = isPanelOpen(),
#       div( class = "panel__list",
#            div( class = "map_panel",
#                 img(src = map_all_data$shopfrontpicture[input$map_plot_marker_click$id], height = 260, width = 260),
#            ),
#            map_panel_card("POS Name", img(src = "./icons/dataNameIcon.svg"), map_all_data$posname[input$map_plot_marker_click$id]),
#            map_panel_card("Contact", img(src = "./icons/call.svg"), map_all_data$Consumer[input$map_plot_marker_click$id]),
#            map_panel_card("Catégorie de PDV", img(src = "./icons/chart.svg"), map_all_data$channelfocus[input$map_plot_marker_click$id]),
#            map_panel_card("Registration Date", img(src = "./icons/calendar.svg"), map_all_data$RegistrationDate[input$map_plot_marker_click$id]),
#            map_panel_card("Ville", img(src = "./icons/global.svg"), map_all_data$city[input$map_plot_marker_click$id]),
#            map_panel_card("Pays", img(src = "./icons/location.svg"), map_all_data$country_code[input$map_plot_marker_click$id]),
#            # Parcourir les colonnes du dataframe pour afficher les informations des competitors
#            items <- lapply(1:5, function(i) {
#              map_panel_card(paste("Competitor", i), img(src = "./icons/linkIcon.svg"),
#                             paste(competitors_map_info()[[paste0("competitor", i)]],
#                                   " / SKU: ", competitors_map_info()[[paste0("skucompetitor", i)]],
#                                   "/ Price: ", competitors_map_info()[[paste0("pricecompetitor", i)]], sep = ""))
#            })
#            ),
#       onDismiss = JS(paste0(
#         "function() {",
#         "  Shiny.setInputValue('", session$ns("hidePanel"), "', Math.random());",
#         "}"
#       ))
#     )
#   })
# }
