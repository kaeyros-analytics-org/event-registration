source("./modules/add_data.R")

server <- function(input, output, session,shared_data) {

  res_auth <- shinymanager::secure_server(
    check_credentials = shinymanager::check_credentials(
      "./data/database.sqlite",
      #passphrase = key_get("R-shinymanager-key", "antid")
      passphrase = "passphrase_wihtout_keyring"
    )
  )

  creds_reactive <- reactive({

    reactiveValuesToList(res_auth)
  })
  
  
  # Créer un objet réactif pour data
  data_reactive <- reactiveVal(data)  # Initialiser avec votre dataframe
  
  observe({
    creds <- creds_reactive()
    req(creds)  # Assurez-vous que creds n'est pas NULL
    
    if (!is.null(creds$level)) {
      if (creds$level == 1) {
        filtered_data <- data %>% filter(name == creds$user)
        data_reactive(filtered_data)
      } else {
        data_reactive(data)  # Réinitialiser à l'ensemble de données complet
      }
      
      # Sauvegarder les données réactives dans un fichier .rds
      saveRDS(data_reactive(), file = "./data/data_reactive.rds")
    }
  })
  
  observeEvent(input$filter_data, {
    print("Apply the filter")
    session$userData$filterStates$selectedCity <- input$cityInput
    session$userData$filterStates$commercial <- input$commercialInput
    session$userData$filterStates$selectedtyp_pdv <- input$pdvInput
    session$userData$filterStates$date_start <- input$dateRangeInput[1]
    session$userData$filterStates$date_end <- input$dateRangeInput[2]
    session$userData$filterStates$selectedtyp_prospect <- input$prospectInput
    session$userData$filterStates$filterButton <- TRUE
  })
  
  observeEvent(input$today,{
    session$userData$filterStates$date_start <- Sys.Date()
    session$userData$filterStates$date_end <- Sys.Date()
    session$userData$filterStates$selectedCity <- input$cityInput
    session$userData$filterStates$commercial <- input$commercialInput
    session$userData$filterStates$date_end <- input$dateRangeInput[2]
    session$userData$filterStates$selectedtyp_prospect <- input$prospectInput
    
  })
  
  ################ Reset filter on sidebar DATA
  observeEvent(input$reset_filter, {
    print("Reset the filter")
    session$userData$filterStates$selectedCity <- "TOUT"
    session$userData$filterStates$selectedQuartier <- "TOUT"
    session$userData$filterStates$selectedCategory <- "TOUT"
    session$userData$filterStates$date_start <- "2025-01-01"
    session$userData$filterStates$date_end <- Sys.Date()
    session$userData$filterStates$TimeSerieRange <- NULL ########## en commentaire dans Filter_section
    session$userData$filterStates$filterButton <- FALSE
  })

  # Variable réactive pour suivre la page active
  active_page <- reactiveVal("dashboard")
  
  # Gérer les clics sur les boutons
  observeEvent(input$go_dashboard, {
    active_page("dashboard")
    updateButtonState("go_dashboard")
    #updateButtonInactive("go_dashboard")
  })
  
  observeEvent(input$go_add_data, {
    active_page("map")
    updateButtonState("go_add_data")
    updateButtonInactive("go_dashboard")
  })
  
  # observeEvent(input$go_last_day_stats, {
  #   active_page("last_day_stats")
  #   updateButtonState("go_last_day_stats")
  #   updateButtonInactive("go_dashboard")
  # })
  observeEvent(input$data, {
    active_page("data")
    updateButtonState("data")
    updateButtonInactive("go_dashboard")
  })
  observeEvent(input$perf, {
    active_page("performance")
    updateButtonState("perf")
    updateButtonInactive("go_dashboard")
  })
  
  # Mise à jour des classes CSS pour les boutons
  updateButtonState <- function(active_id) {
    ids <- c("go_add_data", "go_last_day_stats","data","go_perf")  #"go_dashboard",
    for (id in ids) {
      if (id == active_id) {
        shinyjs::runjs(sprintf("$('#%s').addClass('active');", id))
      } else {
        shinyjs::runjs(sprintf("$('#%s').removeClass('active');", id))
      }
    }
  }
  
  
  #Rendre les boutons inactifs
  updateButtonInactive <- function(inactive_id) {
    ids <- c("go_dashboard","go_add_data", "go_last_day_stats", "data","go_perf") # Liste des boutons
    for (id in ids) {
      if (id == inactive_id) {
        shinyjs::runjs(sprintf("$('#%s').removeClass('active');", id)) # Supprime la classe active pour le bouton spécifié
      } else {
        shinyjs::runjs(sprintf("$('#%s').addClass('inactive');", id)) # Optionnel : ajouter une classe inactive ou gérer visuellement
      }
    }
  }

  # Contenu dynamique
  output$page_content <- renderUI({
    switch(active_page(),
           # "add_data" = add_data_ui(session$ns("add_data")),
           # "last_day_stats" = last_day_ui(session$ns("last_day")),
           "dashboard" = dashboard_page_ui(session$ns("dashboard")),
           "data" = data_ui(session$ns("data")),
           "map" = map_ui(session$ns("map")),
           "performance" = perf_ui(session$ns("perf"))

    )
  })
  callModule(dashboard_page_server, id = "dashboard",filterStates)
  callModule(data_server, id = "data",filterStates)
  callModule(map_server, id = "map",filterStates)
  callModule(perf_server, id = "perf",filterStates)

  output$dateRange <- renderUI({
    tagList(
      div(class="sidebar-header", tags$a("Choisir l'écart de date: ")),
      backendTooltip(span(`data-toggle`="tooltip",
                          `data-placement`="right",
                          `data-html` = "true",
                          title = "Choississez l'écart de de date. Il doit être d'une semaine max.<br/>
                           <b>Comment ça fonctionne:</b>
                           Crée une paire d'entrées de texte qui, lorsqu'elles sont cliquées,
                          font apparaître des calendriers sur lesquels l'utilisateur peut cliquer pour sélectionner des dates.",
                          HTML('<i class="bi bi-question-circle"></i>'))),
      dateRangeInput("dateRangeInput", label = NULL,format = "dd-mm-yyyy",
                     start = as.Date(session$userData$filterStates$date_start), end = as.Date(session$userData$filterStates$date_end),
                     #start = filterStates$date_start, end = filterStates$date_end,
                     min = "2025-01-01", max = Sys.Date()), #format(as.Date(Sys.Date(), format = "%Y-%m-%d"), "%d-%m-%Y")
      tags$script(src = "./js/tooltip.js")
    )
  })
  
  ################## City selection filter
  output$city <- renderUI({
    selection <- session$userData$filterStates$selectedCity
    choices = c("TOUT", unique(data$city))
    tagList(
      div(class="sidebar-header", tags$a("Sélection de la ville: ")),
      backendTooltip(span(`data-toggle`="tooltip",
                          `data-placement`="right",
                          `data-html` = "true",
                          title = "Vous pouvez choisir la ville.
                            Cette sélection a un impact sur les données affichés",
                          HTML('<i class="bi bi-question-circle"></i>'))),
      selectInput("cityInput", label = NULL,
                  choices = choices ,
                  selected = selection),
    )
  })
  
  ################## Commercial selection filter
  output$commercial <- renderUI({
    selection <- session$userData$filterStates$commercial
    choices = c("TOUT", unique(data$name))
    tagList(
      div(class="sidebar-header", tags$a("Sélection des commerciaux : ")),
      backendTooltip(span(`data-toggle`="tooltip",
                          `data-placement`="right",
                          `data-html` = "true",
                          title = "Vous pouvez choisir un ou plusieurs commerciaux.
                            Cette sélection a un impact sur les données affichés",
                          HTML('<i class="bi bi-question-circle"></i>'))),
      selectInput("commercialInput", label = NULL,
                  choices = choices ,
                  selected = selection),
    )
  })
  
  
  
  ################## Type of pdv selection filter
  output$typ_pdv <- renderUI({
    selection <- session$userData$filterStates$selectedtyp_pdv
    choices = c("TOUT", unique(data$type_of_business))
    tagList(
      div(class="sidebar-header", tags$a("Sélection du type de pdv: ")),
      backendTooltip(span(`data-toggle`="tooltip",
                          `data-placement`="right",
                          `data-html` = "true",
                          title = "Vous pouvez choisir les types de point de vente.
                            Cette sélection a un impact sur les données affichés",
                          HTML('<i class="bi bi-question-circle"></i>'))),
      
      selectizeInput(inputId = "pdvInput", label = NULL, choices = choices, selected = selection, multiple = TRUE,
                     options = NULL)
    )
  })
  
  ################## Type of prospection selection filter
  output$typ_prospect <- renderUI({
    selection <- session$userData$filterStates$selectedtyp_prospect
    choices = c("TOUT", unique(data$prospecting_type))
    tagList(
      div(class="sidebar-header", tags$a("Sélection du type de prospection: ")),
      backendTooltip(span(`data-toggle`="tooltip",
                          `data-placement`="right",
                          `data-html` = "true",
                          title = "Vous pouvez choisir les types de prospection.
                            Cette sélection a un impact sur les données affichés",
                          HTML('<i class="bi bi-question-circle"></i>'))),
      
      selectizeInput(inputId = "prospectInput", label = NULL, choices = choices, selected = selection, multiple = TRUE,
                     options = NULL)
    )
  })
  
  
  
  output$filter_button <- renderUI({
    DefaultButton.shinyInput("filter_data", class = "btn-filter",
                             text = "Apply Filter",
                             iconProps = list(iconName = "Send"),
                             style = "background-color: #6247AA; color: #fff;"
    )
  })
  
  ############# Button to Reset a filter
  output$reset_filter <- renderUI({
    DefaultButton.shinyInput("reset_filter", class = "btn-filter",
                             text = "Reset Filter",
                             iconProps = list(iconName = "Refresh"),
                             style = "background-color: #fff; color: #000;"
    )
  })
}