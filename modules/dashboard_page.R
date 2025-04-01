######## UI for situation global
catalog_overview_card <- function(title, text, content) {
  div(class = "overview_card",
      tagList(
        div(class = "overview_card_header",
            Text(class = "overview_card_title", title),
            h4(text)
        ),
        h1(class = "overview_card_content", content)
      )
  )
}

# filterStates <- reactiveValues(
#   # dataset
#   dataNavi = list(dataset = "Map"),
#   selectedCity = "TOUT",
#   selectedtyp_pdv = "TOUT",
#   selectedtyp_prospect = "TOUT",
#   commercial="TOUT",
#   allCountry = "",
#   TimeSerieRange = NULL,
#   date_start = "2025-02-01",
#   date_end = Sys.Date(),
#   filterButton = FALSE
# )

dashboard_page_ui <- function(id){
  ns <- NS(id)
  shinyjs::useShinyjs()
  page_fluid(
    tags$br(),
    layout_column_wrap(
      width = 1/3,class = "bslib-grid",

      # First Value Box for "Nombre de visites"
        value_box(#width="0.1",
        title = "Number of visits",
        value = textOutput(ns("text1")), #sum(custom_ventes$Freq)
        showcase = plotlyOutput(ns("visites")),
        full_screen = TRUE,
        theme = value_box_theme(bg = "#BBBBF5", fg = "#6247aa"), #ff5400
        class = "border"
      ),

      # Second Value Box for "Total des ventes"
      value_box(
        title = "Number of Sales Rep.",
        value = textOutput(ns("text2")),#length(unique(data()$name)), # Assuming 'data' is defined in your environment
        showcase = bsicons::bs_icon("person-standing"),#plotlyOutput(ns("sparkline")),
        full_screen = TRUE,
        theme = value_box_theme(bg = "#BBBBF5", fg = "#6247aa"),
        class = "border"),
      # img(src='freepik__background__15783 (1).png', align = "right",height="180px")
      value_box(
        title = "Number of Sales",
        #paste("Peaked on:",best_day$Date),
        #value = sum(custom_ventes$Freq), # Assuming 'custom_ventes' is defined in your environment
        value = textOutput(ns("sales_text")), # Assuming 'data' is defined in your environment
        showcase = bsicons::bs_icon("wallet-fill"),
        #showcase = plotlyOutput(ns("vente")),
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
    div(style="display: flex;gap:20px",
        div(class="col-lg-6 pr-1 pl-0", id = "table",
            div( class = "subItem_dashboard",
                 uiOutput(ns("plot5"))
            ),
        ),
        div(class="col-lg-6 pl-1 pr-0", id = "linechart",
            div( class = "subItem_dashboard",
                 uiOutput(ns("plot9"))

            ),
        )
    ),
    div(style="display: flex;gap:20px",
        div(class="col-lg-6 pr-1 pl-0", id = "table",
            div( class = "subItem_dashboard",
                 uiOutput(ns("plot7"))
            ),
        ),
        div(class="col-lg-6 pl-1 pr-0", id = "linechart",
            div( class = "subItem_dashboard",
                 uiOutput(ns("plot8"))

            ),
        )
    ),
    div(style="display: flex;gap:20px",
        div(class="col-lg-6 pr-1 pl-0", id = "table",
            div( class = "subItem_dashboard",
                 uiOutput(ns("plot6"))
            ),
        ),
        div(class="col-lg-6 pl-1 pr-0", id = "linechart",
            div( class = "subItem_dashboard",
                 uiOutput(ns("plot10"))

            ),
        )
    )
    # uiOutput(ns("plot5"))

    )

}

########### Server for situation global
dashboard_page_server <- function(input, output, session, filterStates){
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
  
  output$text1 <- renderText({
    length(data_filter()$name)
  })
  output$text2 <- renderText({
    paste(length(unique(data_filter()$name)), "/", length(unique(data$name)))
  })
  
  # output$text2 <- renderText({
  #   length(unique(data_filter()$name))
  # })
  output$best_com <- renderText({
    com_vente <- data_filter() %>% filter(visit_objective=="Vente de Sema") %>%
      select(name)
    com_vente <- as.data.frame(table(com_vente$name))
    com_vente <- as.data.frame(com_vente %>% filter(Freq==max(Freq)))$Var1
    com_vente
  })
  
  output$treemap <- renderEcharts4r({ #renderD3tree2
    # data_tree <- data_filter() %>% group_by(type_of_outlet,customer_decision) %>%
    #   summarise(count=n())
    data_tree <- data_filter() %>% group_by(type_of_business,customer_decision) %>% #,customer_decision
      summarise(count=n()) %>%
      rename(parents=type_of_business) %>%
      rename(labels=customer_decision)
    tm_structure <- data_tree %>%
      group_by(parents) %>%
      summarise(
        value = sum(count), # Somme des counts pour chaque parent
        children = list(
          tibble(
            name = labels,
            value = count
          )
        )
      ) %>%
      rename(name = parents)
    tm_structure %>%
      e_charts() %>%
      e_treemap(
        leafDepth = 1,  #drilldown
        #breadcrumb = FALSE, #remove it
        backgroundColor = "red",
        itemStyle = list(
          normal = list(
            borderWidth = 0,
            gapWidth = 2,
            backgroundColor = "gray70"
          )
        ),
        name = "Having fun with treemaps",
        upperLabel = list(
          normal = list(
            show = FALSE,
            height = 30,
            formatter = "{b}",
            color = "white",
            fontSize = 10
          )
        )
      )%>%
      e_tooltip() %>%
      e_labels(show = TRUE,
               verticalAlign = "top",
               fontSize = 24,
               formatter = "{b}\n{@value}"
      ) %>%
      e_title(" ",
              textStyle = list(fontSize = 36),
              textVerticalAlign = "top",
              left = "center"
      ) #%>% #backgroundColor = "#CD853F64"
    #e_theme("dark")
  })
  
  
  output$plot1 <- renderUI({
    out <- accordionCard(accordionId = "accordionPlot2",
                         headerId = 'plotchart2',
                         targetId = 'collapseCcplotchart2',
                         headerContent = paste0("Visited POS per sales rep", sep = ""),
                         bodyContent = echarts4rOutput(session$ns("vis_com")),
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  output$plot2 <- renderUI({
    out <- accordionCard(accordionId = "accordionPlot2",
                         headerId = 'plotchart2',
                         targetId = 'collapseCcplotchart2',
                         headerContent = paste0("Category of POS by customer decision", sep = ""),
                         bodyContent = echarts4rOutput(session$ns("treemap")), #d3tree2Output
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  output$plot3 <- renderUI({
    out <- accordionCard(accordionId = "accordionPlot2",
                         headerId = 'plotchart2',
                         targetId = 'collapseCcplotchart2',
                         headerContent = paste0("Total number of visits per sales rep", sep = ""),
                         bodyContent = plotlyOutput(session$ns("evolution_visites")),
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  output$plot4 <- renderUI({
    out <- accordionCard(accordionId = "accordionPlot2",
                         headerId = 'plotchart2',
                         targetId = 'collapseCcplotchart2',
                         headerContent = paste0("Total number of visits", sep = ""),
                         bodyContent = plotlyOutput(session$ns("evolution_ventes")),
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  output$plot5 <- renderUI({
    out <- accordionCard(accordionId = "accordionPlot2",
                         headerId = 'plotchart2',
                         targetId = 'collapseCcplotchart2',
                         headerContent = paste0("Number of sales per Sales Rep", sep = ""),
                         bodyContent = plotlyOutput(session$ns("sales_srep")), #commercial_cust_decision
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  output$plot6 <- renderUI({
    out <- accordionCard(accordionId = "accordionPlot2",
                         headerId = 'plotchart2',
                         targetId = 'collapseCcplotchart2',
                         headerContent = paste0("Number of sales", sep = ""),
                         bodyContent = uiOutput(session$ns("vente1")),
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  output$plot7 <- renderUI({
    out <- accordionCard(accordionId = "accordionPlot2",
                         headerId = 'plotchart2',
                         targetId = 'collapseCcplotchart2',
                         headerContent = paste0("Number of sales per Sales Rep and customer decision", sep = ""),
                         bodyContent = plotlyOutput(session$ns("commercial_cust_decision")),
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  output$plot8 <- renderUI({
    out <- accordionCard(accordionId = "accordionPlot2",
                         headerId = 'plotchart2',
                         targetId = 'collapseCcplotchart2',
                         headerContent = paste0("Repartition of visits by cities", sep = ""),
                         bodyContent = echarts4rOutput(session$ns("ville_repartition")),
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  output$plot9 <- renderUI({
    out <- accordionCard(accordionId = "accordionPlot2",
                         headerId = 'plotchart2',
                         targetId = 'collapseCcplotchart2',
                         headerContent = paste0("Repartition of visits by categories", sep = ""),
                         bodyContent = plotlyOutput(session$ns("category_pos")),
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  output$plot10 <- renderUI({
    out <- accordionCard(accordionId = "accordionPlot2",
                         headerId = 'plotchart2',
                         targetId = 'collapseCcplotchart2',
                         headerContent = paste0("Repartition of promises by Sales Rep.", sep = ""),
                         bodyContent = plotlyOutput(session$ns("promesse_srep")),
                         iconId = paste0("_plotchart"),
                         dataset = "dataset")
  })
  
  # # Rendering the first plot (sparkline)
  output$visites <- renderPlotly({
    #f
    custom_ventes <- as.data.frame(table(data_filter()$customer_decision))
    plotly::plot_ly(custom_ventes, x = ~Var1,
                    type = "bar",
                    y = ~Freq,
                    hoverinfo = 'text',
                    marker = list(color = c("#4798CD")),
                    hovertext = paste(
                      paste(custom_ventes$Var1),
                      "<br>",custom_ventes$Freq
                    )
                    #text = paste(custom_ventes$Freq, sep = ""), textposition = 'outside'
                    
    ) %>%
      layout(
        xaxis = list(visible = F, showgrid = F, title = ""),
        yaxis = list(visible = F, showgrid = F, title = ""),
        hovermode = "x",
        margin = list(t = 0, r = 0, l = 0, b = 0),
        font = list(color = "black"),
        paper_bgcolor = "transparent",
        plot_bgcolor = "transparent"
      ) %>%
      config(displayModeBar = F) %>%
      htmlwidgets::onRender(
        "function(el) {
      el.closest('.bslib-value-box')
        .addEventListener('bslib.card', function(ev) {
          Plotly.relayout(el, {'xaxis.visible': ev.detail.fullScreen});
        })
    }"
      )
  })
  
  output$vis_com <- renderEcharts4r({
    vis_com <- as.data.frame(table(data_filter()$name))
    vis_com <- vis_com %>%
      e_charts(x = Var1) %>%
      e_pie(serie = Freq,
            selectedMode= "multiple",
            selectedOffset= 15,
            radius = c("45%", "75%"),
            itemStyle = list(borderRadius = 10,
                             borderColor= '#fff',
                             borderWidth= 2),
            label = list(show = TRUE,
                         formatter = '{d}%'),
      ) %>%
      e_labels(show = TRUE,
               formatter = "{c} \n {d}%",
               position = "inside") %>%
      #e_color(color = c("#E4ECF4","#A5C0DB","#93AAFD","#007FFF","#4A3AFF", "#004C99","#0B223A")) %>%
      e_color(color = c("#A4A2FF","#F1F39F","#EF63F5","#85DEA3","#F7B17D","#6247aa")) %>%
      
      
      e_legend(show = TRUE,
               orient = 'vertical',
               itemGap = 0.5,
               right = 0,
               top = 0
      ) %>%
      e_grid(left = 100, top = 5) %>%
      e_title(
        text = nrow(data_filter()),          # Le chiffre que tu veux afficher
        left = "center",      # Centrer horizontalement
        top = "50%",          # Centrer verticalement
        textStyle = list(
          fontSize = 20,      # Taille du texte
          fontWeight = "bold"
        )
      ) %>% e_tooltip(
        formatter = htmlwidgets::JS("
      function(params){
        return('<strong>' + params.name)
      }
    ")
      )
    vis_com
  })
  output$evolution_visites <- renderPlotly({
    data <- data_filter()
    data$createdAt.x <- as.Date(data$createdAt.x)
    d <- data %>% group_by(createdAt.x,name) %>% summarise(n=n())
    
    date_range <- seq(min(d$createdAt.x), max(d$createdAt.x), by = "day")
    names <- unique(d$name)
    
    # Créer toutes les combinaisons possibles de dates et de noms
    complete_data <- expand.grid(createdAt.x = date_range, name = names)
    
    # Faire une jointure avec le dataframe d'origine pour ajouter les valeurs manquantes
    complete_df <- complete_data %>%
      left_join(d, by = c("createdAt.x", "name")) %>%
      replace_na(list(n = 0))  # Remplacer les NA par 0 dans la colonne 'n'
    
    # Créer un graphique de lignes avec Plotly, une ligne pour chaque 'name'
    # couleurs <- c("#05299e", "#5e4ae3", "#947bd3", "#4A148C",
    #               "#f0a7a0", "#f26ca7", "#72195a")
    couleurs <- c("#A4A2FF","#F1F39F","#EF63F5","#85DEA3","#F7B17D","#6247aa")
    plotly::plot_ly(data = complete_df, type = "scatter", mode = "lines") %>%
      add_trace(x = ~createdAt.x, y = ~n, name = ~name, mode = 'lines+markers',color = ~name,colors = couleurs,
                hovertext = paste("Date :", complete_df$createdAt.x,
                                  "<br>Sales Rep :",complete_df$name,
                                  "<br>Number of visits :",complete_df$n
                ),
                hoverinfo = 'text') %>%
      layout(title = "",
             uniformtext=list(minsize=15, mode='show'),
             xaxis = list(title = "<b> Date </b>",type="date", tickformat="%d-%m-%Y", tickangle= -45,
                          tickvals = complete_df$createdAt.x,
                          tickfont = list(size = 14),
                          titlefont = list(size = 16)),
             yaxis = list(title = "<b> Total number of visits </b>", titlefont = list(color = "#4A3AFF", size = 14),
                          
                          tickfont = list(size = 14)),
             showlegend = TRUE) %>%
      config(displayModeBar = T,displaylogo = FALSE, modeBarButtonsToRemove = list(
        'sendDataToCloud','toImage','zoomIn2d',"zoomOut2d",'toggleSpikelines',
        'resetScale2d','lasso2d','zoom2d','pan2d','select2d','hoverCompareCartesian'),
        scrollZoom = F)
  })
  output$evolution_ventes <- renderPlotly({
    d <- data_filter() %>% group_by(createdAt.x) %>% summarise(count=n())
    date_range <- seq(min(d$createdAt.x), max(d$createdAt.x), by = "day")
    
    # Créer toutes les combinaisons possibles de dates et de noms
    complete_data <- expand.grid(createdAt.x = date_range)
    
    # Faire une jointure avec le dataframe d'origine pour ajouter les valeurs manquantes
    complete_df <- complete_data %>%
      left_join(d, by = c("createdAt.x")) %>%
      replace_na(list(count = 0))  # Remplacer les NA par 0 dans la colonne 'n'
    plotly::plot_ly(data = complete_df, type = "scatter", mode = "lines") %>%
      add_trace(x = ~createdAt.x, y = ~count, mode = 'lines+markers',colors = couleurs,
                hovertext = paste("Date :", complete_df$createdAt.x,
                                  "<br>Number of visits :",complete_df$count
                ),
                hoverinfo = 'text') %>%
      layout(title = "",
             uniformtext=list(minsize=15, mode='show'),
             xaxis = list(title = "<b> Date </b>",type="date", tickformat="%d-%m-%Y", tickangle= -45,
                          tickvals = complete_df$createdAt.x,
                          tickfont = list(size = 14),
                          titlefont = list(size = 16)),
             yaxis = list(title = "<b> Total number of visits </b>", titlefont = list(color = "#4A3AFF", size = 14),
                          
                          tickfont = list(size = 14)),
             showlegend = FALSE) %>%
      config(displayModeBar = T,displaylogo = FALSE, modeBarButtonsToRemove = list(
        'sendDataToCloud','toImage','zoomIn2d',"zoomOut2d",'toggleSpikelines',
        'resetScale2d','lasso2d','zoom2d','pan2d','select2d','hoverCompareCartesian'),
        scrollZoom = F)
    
  })
  #
  output$sales_srep <- renderPlotly({
    # Assurez-vous que la colonne createdAt.x est bien au format date-temps
    d <- data_filter() %>% group_by(createdAt.x,name) %>% summarise(n=n())
    date_range <- seq(min(d$createdAt.x), max(d$createdAt.x), by = "day")
    names <- unique(d$name)
    
    # Créer toutes les combinaisons possibles de dates et de noms
    complete_data <- expand.grid(createdAt.x = date_range, name = names)
    
    # Faire une jointure avec le dataframe d'origine pour ajouter les valeurs manquantes
    complete_df <- complete_data %>%
      left_join(d, by = c("createdAt.x", "name")) %>%
      replace_na(list(n = 0))
    data_vente <- data_filter() %>% filter(achievement=="vente")
    data_vente <- data_vente %>% group_by(createdAt.x,name) %>%
      summarise(n=n())
    complete_data_vente <- complete_data %>%
      left_join(data_vente, by = c("createdAt.x", "name")) %>%
      replace_na(list(n = 0))
    
    plotly::plot_ly(data = complete_data_vente, type = "scatter", mode = "lines") %>%
      add_trace(x = ~createdAt.x, y = ~n, name = ~name, mode = 'lines+markers',color = ~name,colors = couleurs,
                hovertext = paste("Date :", complete_data_vente$createdAt.x,
                                  "<br>Sales Rep :",complete_data_vente$name,
                                  "<br>Number of sales :",complete_data_vente$n
                ),
                hoverinfo = 'text') %>%
      layout(title = "",
             uniformtext=list(minsize=15, mode='show'),
             xaxis = list(title = "<b> Date </b>",type="date", tickformat="%d-%m-%Y", tickangle= -45,
                          tickvals = complete_data_vente$createdAt.x,
                          tickfont = list(size = 14),
                          titlefont = list(size = 16)),
             # yaxis = list(title = "<b> Total number of sales </b>", titlefont = list(color = "#4A3AFF", size = 14),
             #
             #              tickfont = list(size = 14),
             #              range = c(0, max(complete_data_vente$n) * 1.1)),
             yaxis = list(
               title = "<b> Total number of sales </b>",
               titlefont = list(color = "#4A3AFF", size = 14),
               tickfont = list(size = 14),
               autorange = FALSE,
               range = c(0, max(complete_data_vente$n) + 1)  # Ajuster la limite supérieure
             ),
             showlegend = TRUE) %>%
      config(displayModeBar = T,displaylogo = FALSE, modeBarButtonsToRemove = list(
        'sendDataToCloud','toImage','zoomIn2d',"zoomOut2d",'toggleSpikelines',
        'resetScale2d','lasso2d','zoom2d','pan2d','select2d','hoverCompareCartesian'),
        scrollZoom = F)
  })
  #
  output$commercial_cust_decision <- renderPlotly({
    couleurs <- c("#A4A2FF","#F1F39F","#EF63F5","#85DEA3","#F7B17D","#6247aa")
    data_stack <- data_filter() %>% group_by(name,customer_decision) %>% summarise(n=n())
    data_stack <- data_stack %>%
      pivot_wider(
        names_from = customer_decision,  # Nom des colonnes à créer
        values_from = n,                 # Valeurs à remplir dans ces colonnes
        values_fill = list(n = 0)        # Remplir les NA par 0
      )
    couleurs <- c("Interessé" = '#6247aa', "Pas interessé" = '#EF63F5') #"Vente" = '#85DEA3',
    # Initialisation du graphique
    plot_stack <- plot_ly(data_stack, y = ~name, orientation = 'h')
    
    # Obtenir les noms des colonnes sans "name"
    colonnes <- setdiff(names(data_stack), "name")
    
    for (colonne in colonnes) {
      if (colonne %in% names(couleurs)) {
        plot_stack <- plot_stack %>%
          add_trace(
            x = data_stack[[colonne]],
            name = colonne,
            type = 'bar',
            marker = list(color = couleurs[[colonne]])
          )
      } else {
        warning(paste("Couleur manquante pour la colonne :", colonne))
      }
    }
    
    # Configurer le layout
    plot_stack <- plot_stack %>% layout(
      yaxis = list(title = 'Total number of visits'),
      barmode = 'stack',
      xaxis = list(title = 'Customer decision')
    ) %>%
      config(displayModeBar = TRUE, displaylogo = FALSE, modeBarButtonsToRemove = list(
        'sendDataToCloud','toImage','zoomIn2d',"zoomOut2d",'toggleSpikelines','resetScale2d',
        'lasso2d','zoom2d','pan2d','select2d','hoverClosestCartesian','hoverCompareCartesian'),
        zoom2d = FALSE,
        scrollZoom = FALSE)
    plot_stack
  })
  #
  data_vente <- reactive({
    vente <- data_filter() %>% filter(achievement=="vente")
    vente <- vente %>%
      group_by(as.Date(createdAt.x)) %>%
      summarise(n=n())
    vente <- vente %>% rename("Date"=`as.Date(createdAt.x)`)
  })
  output$vente1 <- renderUI({
    if(nrow(data_vente())==0) {
      h3("Pas de vente")
      
    } else {
      plotlyOutput(session$ns("vente"))
    }
  })
  
  output$vente <- renderPlotly({
    vente <- data_vente()
    plotly::plot_ly(data = vente, type = "scatter", mode = "lines") %>%
      add_trace(x = ~Date, y = ~n, name = "Nombre", mode = 'lines+markers',
                color = I("#BBBBF5"), span = I(1),
                fill = 'tozeroy', alpha = 0.2,
                line = list(color = '#6247aa', width = 2.5), marker=list(color = '#6247aa', width = 5),
                hovertext = paste("Date :", vente$Date,
                                  "<br>Number of sales :",vente$n
                ),
                hoverinfo = 'text') %>%
      layout(title = "",
             uniformtext=list(minsize=15, mode='show'),
             xaxis = list(title = "<b> Date </b>",type="date", tickformat="%d-%m-%Y", tickangle= -45,
                          tickvals = vente$Date,
                          tickfont = list(size = 14),
                          titlefont = list(size = 16)),
             yaxis = list(
               title = "<b> Total number of sales </b>",
               titlefont = list(color = "#4A3AFF", size = 14),
               tickfont = list(size = 14),
               autorange = FALSE,
               range = c(0, max(vente$n) + 1)  # Ajuster la limite supérieure
             ),
             showlegend = FALSE) %>%
      config(displayModeBar = T,displaylogo = FALSE, modeBarButtonsToRemove = list(
        'sendDataToCloud','toImage','zoomIn2d',"zoomOut2d",'toggleSpikelines',
        'resetScale2d','lasso2d','zoom2d','pan2d','select2d','hoverCompareCartesian'),
        scrollZoom = F)
    
    
  })
  #
  output$ville_repartition <- renderEcharts4r({
    d <- data_filter() %>% group_by(city) %>% summarise(n=n())
    
    d %>%
      e_charts(city) %>%
      e_pie(n,radius = c("50%", "80%")) %>%
      e_color(color = c("#A4A2FF","#F1F39F","#EF63F5","#85DEA3","#F7B17D","#6247aa")) %>%
      e_legend(show = TRUE,
               orient = 'vertical',
               itemGap = 0.5,
               right = 0,
               top = 0
      ) %>%
      e_labels(show = TRUE,
               formatter = "{c} \n {d}%",
               position = "inside") %>%
      e_tooltip(
        formatter = htmlwidgets::JS("
      function(params){
        return('<strong>' + params.name)
      }
    "))
  })
  
  output$sales_text <- renderText({
    data <- subset(data_filter(),achievement=="vente")
    if(nrow(data)==0) {
      "0"
    } else {
      nrow(data)
    }
  })
  
  output$text2_1 <- renderText({
    length(unique(data$name))
  })
  
  output$category_pos <- renderPlotly({
    pos_cat <- subset(data_filter(), !is.na(category))
    pos_cat <- pos_cat %>%
      group_by(category,customer_decision) %>%
      summarise(count=n())
    custom_colors <- c("Interessé" = "#A4A2FF", "Pas interessé" = "#6247aa")
    
    # Créer un graphique à barres empilées avec des couleurs personnalisées
    fig <- plot_ly(data = pos_cat,
                   x = ~category,
                   y = ~count,
                   color = ~customer_decision,
                   colors = custom_colors,  # Utiliser la palette de couleurs personnalisées
                   type = 'bar',
                   text = ~count,
                   textposition = 'auto') %>%
      layout(title = " ",
             barmode = 'stack',
             xaxis = list(title = "Category"),
             yaxis = list(title = "Count"))
  })
  
  output$promesse_srep <- renderPlotly({
    promise_srep <- data_filter() %>% filter(achievement %in% c("vente","promesse","pas de vente"))
    promise_srep <- promise_srep %>%
      group_by(name,achievement) %>%
      summarise(count=n())
    custom_colors <- c("vente" = "#A4A2FF", "promesse" = "#6247aa", "pas de vente"="#EF63F5" )
    
    fig <- plot_ly(data = promise_srep,
                   x = ~name,
                   y = ~count,
                   color = ~achievement,
                   colors = custom_colors,  # Utiliser la palette de couleurs personnalisées
                   type = 'bar',
                   text = ~count,
                   textposition = 'auto') %>%
      layout(title = " ",
             barmode = 'stack',
             xaxis = list(title = "Name"),
             yaxis = list(title = " "))
  })
}

# basic treemap
# treemap <- treemap(data_tree,
#                    index=c("type_of_outlet","customer_decision"),
#                    #index=paste(data_tree, count, sep ="\n"),
#                    title=" ",
#                    vSize="count",
#                    type="index",
#                    title.legend=" ",
#                    palette = "PuBu",
#                    bg.labels=c("white"),
#                    align.labels=list(
#                      c("center", "center"),
#                      c("right", "bottom")
#                    )
# )
# d3tree2(treemap)
