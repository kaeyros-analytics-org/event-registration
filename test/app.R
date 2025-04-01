library(shiny)
library(bs4Dash)
library(tidyverse)
library(echarts4r)
library(leaflet)
library(DT)
library(shinyWidgets)


# Interface utilisateur
ui <- bs4DashPage(
  header = bs4DashNavbar(
    title = "Dashboard UCB 2024"
  ),
  sidebar = bs4DashSidebar(
    skin = "dark",
    status = "primary",
    title = "Filtres",
    bs4SidebarMenu(
      bs4SidebarMenuItem(
        "Tableau de bord",
        tabName = "dashboard",
        icon = icon("tachometer-alt")
      ) 
    ),
    pickerInput(
      inputId = "Campagne", 
      label = "Sélectionnez une Campagne :", 
      choices = unique(UCB_data_2024$Campagne),
      selected = unique(UCB_data_2024$Campagne),
      multiple = TRUE
    ),
    pickerInput(
      inputId = "region", 
      label = "Sélectionnez une région :", 
      choices = unique(UCB_data_2024$Region),
      selected = unique(UCB_data_2024$Region),
      multiple = TRUE
    ),
    dateRangeInput(
      inputId = "date_range",
      label = "Sélectionnez une plage de dates :",
      start = min(UCB_data_2024$Date),
      end = max(UCB_data_2024$Date)
    )#,
    # checkboxGroupInput(
    #   inputId = "lot_filter",
    #   label = "Filtrer par type de lot :",
    #   choices = unique(UCB_data_2024$Lot),
    #   selected = unique(UCB_data_2024$Lot)
    # )
  ),
  body = bs4DashBody(
    bs4TabItems(
      bs4TabItem(
        tabName = "dashboard",
        fluidRow(
          bs4Card(
            title = "Performance par région",
            width = 6,
            echarts4rOutput("region_performance")
          ),
          bs4Card(
            title = "Évolution temporelle",
            width = 6,
            echarts4rOutput("time_distribution")
          )
        ),
        fluidRow(
          bs4Card(
            title = "Répartition des lots",
            width = 6,
            echarts4rOutput("lot_distribution")
          ),
          bs4Card(
            title = "Répartition des campagnes",
            width = 6,
            echarts4rOutput("campaign_distribution")  # Nouveau graphique
          )
        )
      )
    )
  ),
  controlbar = bs4DashControlbar(
    title = "Options",
    skin = "light",
    collapsed = TRUE
  ),
  footer = bs4DashFooter(
    div(
      style = "text-align: center; padding: 10px;",
      "© 2024 UCB - Analyse de données | Propulsé par R & Shiny"
    )
  )
)

# Serveur
server <- function(input, output, session) {
  
  # Filtrer les données en fonction des entrées utilisateur
  # Supprimer les lignes avec des valeurs NA pour les colonnes critiques
  filtered_data <- reactive({
    UCB_data_2024 %>%
      filter(
        !is.na(Region),  # Exclure si Region est NA
        !is.na(Lot),     # Exclure si Lot est NA
        Region %in% input$region,
        Campagne %in% input$Campagne,
        Date >= input$date_range[1],
        Date <= input$date_range[2]
      )
  })
  
  # Performance par région
  output$region_performance <- renderEcharts4r({
    data <- filtered_data() %>%
      group_by(Region) %>%
      summarise(Count = n(), .groups = "drop")
    
    if (nrow(data) == 0) {
      return(e_charts() %>% e_text("Aucune donnée disponible", style = list(fontSize = 20)))
    }
    
    data %>%
      e_charts(Region) %>%
      e_bar(Count) %>%
      e_legend(show = TRUE) %>%
      e_tooltip(trigger = "axis")
  })
  
  
  # Évolution temporelle
  output$time_distribution <- renderEcharts4r({
    filtered_data() %>%
      group_by(Date) %>%
      summarise(Count = n(), .groups = "drop") %>%
      e_charts(Date) %>%
      e_line(Count) %>%
      e_tooltip(trigger = "axis")
  })
  
  # Répartition des résultats des lots
  output$lot_distribution <- renderEcharts4r({
    filtered_data() %>%
      count(Lot) %>%
      e_charts(Lot) %>%
      e_pie(n) %>%
      e_tooltip(trigger = "item")
  })
  
  
  # Répartition des campagnes
  output$campaign_distribution <- renderEcharts4r({
    filtered_data() %>%
      count(Campagne) %>%
      e_charts(Campagne) %>%
      e_bar(n) %>%
      e_tooltip(trigger = "axis")
  })
}

# Lancer l'application
shinyApp(ui, server)
