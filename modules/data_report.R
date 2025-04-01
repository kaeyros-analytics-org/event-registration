filtered_data <- reactive({
  #mensuel_data <- getReactiveData()
  #mensuel_data <- mensuel_data()
  mensuel_data <- readRDS("./data/shared_data.rds")
  mensuel_data %>%
    filter(DATE >= ymd(filterStates$date_start) &
             DATE <= ymd(filterStates$date_end)+1)%>%
    filter(if (length(filterStates$categorySelected) != 0 && !"All" %in% filterStates$categorySelected)  `CAT`  %in% filterStates$categorySelected  else TRUE) #%>%
    #filter(if (length(filterStates$accepteSelected) != 0 && !"All" %in% filterStates$accepteSelected)  ACCEPTE  %in% filterStates$accepteSelected  else TRUE)
  
})

plot1 <- reactive({
  # Agréger les données par date
  vehicule_par_jour <- filtered_data() %>%
    group_by(DATE) %>%
    summarise(nombre_vehicules = n())
  
  # Créer le graphique
  ggplot(data = vehicule_par_jour, aes(x = DATE, y = nombre_vehicules)) +
    geom_line(color = "#002157") +  # Tracer les lignes
    geom_point(color = "#002157") +  # Si vous voulez ajouter des points
    labs(title = "", 
         x = "Date", 
         y = "Number of cars") +
    theme_minimal() +  # Utiliser un thème minimal
    theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Incliner les labels de l'axe x
})

plot2 <- reactive({
  # Regrouper les données par date et calculer le total des PTTC
  data_agg <- filtered_data() %>%
    group_by(DATE) %>%
    summarise(Total_P_TTC = sum(PTTC, na.rm = TRUE))
  
  # Créer le graphique
  ggplot(data = data_agg, aes(x = DATE, y = Total_P_TTC)) +
    geom_line(color = "#002157") +  # Tracer les lignes
    geom_point(color = "#002157") +  # Si vous voulez ajouter des points
    labs(title = "", 
         x = "Date", 
         y = "Total amount (XAF)") +
    theme_minimal() +  # Utiliser un thème minimal
    theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Incliner les labels de l'axe x
})

plot3 <- reactive({
  
  # Calculer le pourcentage de chaque catégorie
  data_percentage <- filtered_data() %>%
    group_by(CAT) %>%
    summarise(Total = n()) %>%
    mutate(Pourcentage = round(Total / sum(Total) * 100, 2))
  print(data_percentage)
  
  # Créer le graphique en barres
  ggplot(data = data_percentage, aes(x = CAT, y = Total)) +
    geom_bar(stat = "identity", fill = "#002157") +  # Utiliser stat="identity" pour les totaux
    geom_text(aes(label = Total), vjust = -0.5) +  # Ajouter des étiquettes au-dessus des barres
    labs(title = "", 
         x = "CAT", 
         y = "TOTAL") +
    theme_minimal() +  # Utiliser un thème minimal
    theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Incliner les labels de l'axe x
  
})

plot4 <- reactive({
  # Calculer le total PTTC par jour et par catégorie
  data_summary <- filtered_data() %>%
    group_by(DATE, CAT) %>%
    summarise(Total_P_TTC = sum(PTTC), .groups = 'drop')
  
  
  # Créer le graphique en lignes avec ggplot2
  ggplot(data = data_summary, aes(x = DATE, y = Total_P_TTC, color = CAT)) +
    geom_line() +  # Tracer les lignes pour chaque catégorie
    geom_point() +  # Ajouter des points pour chaque observation
    labs(title = "", 
         x = "Date", 
         y = "Total PTTC (XAF)", 
         color = "Category") +  # Titre de la légende
    theme_minimal() +  # Utiliser un thème minimal
    theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Incliner les labels de l'axe x
})