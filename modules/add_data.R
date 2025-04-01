source("./ui.R")
add_data_ui <- function(id){
  #h1("Welcome WINNIE!")
  useShinyjs()
  ns <- NS(id)
  fluidPage(
    tags$head(
      tags$style(HTML("
      .file-uploader {
        border: 2px dashed #007bff; /* Bordure bleue */
        border-radius: 8px; /* Coins arrondis */
        text-align: center; /* Centrer le texte */
        padding: 60px; /* Augmenté l'espacement intérieur */ 60
        margin: 50px 0; /* Espacement extérieur */
        background-color: #f9f9f9; /* Couleur de fond gris clair */
        color: #007bff; /* Couleur du texte */
        width: 400px; /* Largeur fixée pour le cadre */
      }
      .file-uploader:hover {
        background-color: #e9f5ff; /* Couleur de fond au survol */
        cursor: pointer; /* Curseur pointeur */
      }
      .upload-icon {
        font-size: 50px; /* Taille de l'icône */
        margin-bottom: 10px; /* Espacement sous l'icône */
      }
      .centered {
        display: flex; /* Utilise flexbox */
        justify-content: center; /* Centre horizontalement */
        align-items: center; /* Centre verticalement */
        height: 100vh; /* Prend toute la hauteur de la fenêtre */
      }
    "))
    ),
    
    div(class = "centered", 
        div(class = "file-uploader", 
            tags$i(class = "fa fa-cloud-upload upload-icon"), # Icône de téléchargement
            h3("Browse file to upload"), 
            fileInput(ns("file"), 
                      label = NULL, # Pas de label ici, car on utilise un texte personnalisé
                      multiple = FALSE, 
                      accept = c(".xlsx"), # Accepter uniquement les fichiers Excel
                      buttonLabel = "Choose File", 
                      placeholder = "No file selected",
                      width = "100%"), # Largeur à 100% pour le bouton
            actionButton(ns("preprocess"), "Add data",status="primary") # Bouton pour prétraitement
        )
        
    ),
    
    # Zone pour afficher le tableau des données
    fluidRow(
      column(12,
             tableOutput(ns("dataTable")) # Affichage du tableau
      )
    )
  )
}

add_data_server <- function(input, output, session,shared_data,updated_data) {
  
  observeEvent(input$preprocess, {
    req(input$file)
    
    # Lire les nouvelles données
    new_data <- read_excel(input$file$datapath)
    new_data$ACCEPTE <- as.double(new_data$ACCEPTE)
    new_data$REFUS <- as.character(new_data$REFUS)
    new_data$CONTACT <- as.double(new_data$CONTACT)

    observe({
      data <- shared_data()
      data$REFUS <- as.character(data$REFUS)
    })

    
    new_data$`DATE P.V` <- as.Date(new_data$`DATE P.V`, origin = "1899-12-30")
    new_data$`DATE P.V` <- as.POSIXct(new_data$`DATE P.V`, format = "%Y-%m-%d")
    
    # Vérifier les lignes uniques (nouvelles données seulement)
    updated_data <- anti_join(new_data, shared_data(), by = names(shared_data()))
    
    if (nrow(updated_data) > 0) {
      # Ajouter les nouvelles lignes au dataset réactif
      shared_data(bind_rows(shared_data(), updated_data))  # Mise à jour des données réactives
      # Sauvegarder le dataset mis à jour dans un fichier RDS
      saveRDS(shared_data(), "./data/shared_data.rds")
      updated_data(updated_data)
      saveRDS(updated_data(), "./data/updated_data.rds")
      
      
      # showNotification(
      #   paste(nrow(updated_data), "new rows added to the dataset."),
      #   type = "message"
      # )
    } else {
      print("ras")
      updated_data(data.frame())
      saveRDS(updated_data(), "./data/updated_data.rds")
      
      # updated_data(updated_data)
      # saveRDS(updated_data(), "./data/updated_data.rds")
      #showNotification("No new data found to add.", type = "warning")
    }
  })
  
  observeEvent(input$preprocess, {
    #req(updated_data)  # S'assure que update_data est disponible

    if(nrow(updated_data()) > 0) {
      showModal(modalDialog(
        title = "New data",
        "You need to click the 'Update' button in the sidebar of the dashboard page to update the dashboard with the new data.",
        style = "color: green;"
      ))
    } else {
      showModal(modalDialog(
        title = "No data",
        "There's no new data.",
        #icon=icon("bell"),
        style = "color: green;",
        easyClose = TRUE,
        footer = NULL
      ))
    }
  })
  
  save_preprocess <- reactiveVal(FALSE)
  
  observeEvent(input$preprocess, {
    shinyjs::enable("preprocess")
    save_preprocess(TRUE)  # Met à jour la valeur réactive
    
    # Sauvegarde la valeur sous forme de RDS
    saveRDS(save_preprocess(), file = "./data/save_preprocess.rds")
  })
  
  # observeEvent(input$preprocess, {
  #   # Afficher le bouton caché
  #   shinyjs::show("view_more_data")
  # })
  # observeEvent(input$preprocess, {
  #   print("WINNER")
  #   updateActionButton(session, "go_dashboard", label = "Dashboard", icon = icon("bell"))
  # })
}