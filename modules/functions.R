load_shared_data <- function() {
  if (file.exists("./data/shared_data.rds")) {
    return(readRDS("./data/shared_data.rds"))
  } else {
    return(data.frame())  # Si le fichier n'existe pas, retourne un jeu de données vide
  }
}

load_update_data <- function() {
  if (file.exists("./data/updated_data.rds")) {
    return(readRDS("./data/updated_data.rds"))
  } else {
    return(data.frame())  # Si le fichier n'existe pas, retourne un jeu de données vide
  }
}

catalog_overview_card <- function(title, text, content) {
  div(class = "overview_card", style = "box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.5); padding: 10px; border-radius: 8px;",
      tagList(
        div(class = "overview_card_header",
            Text(class = "overview_card_title", title),
            h3(text)
        ),
        h1(class = "overview_card_content", content)
      )
  )
}

accordionCard <- function(accordionId = "accordionOne", 
                          headerId = 'headerOne',
                          targetId = 'collapseOne',
                          headerContent = 'headerContent #1',
                          bodyContent = '',
                          iconId = 'icon',
                          dataset = 'ACLED',
                          optionalTooltip = span("")) {
  
  out <- htmlTemplate("www/htmlComponents/accordionTemplate.html",
                      headerId = paste0(dataset, "_", headerId),
                      accordionId = paste0(dataset, "_", accordionId),
                      accordionIdConcat = paste0("#", paste0(dataset, "_", accordionId)),
                      targetId = paste0(dataset, "_", targetId),
                      targetIdConcat = paste0("#", paste0(dataset, "_", targetId)),
                      headerContent = headerContent,
                      bodyContent = bodyContent,
                      fullScreenId = paste0(iconId, "-fullscreen"),
                      download_button = downloadbtn_ui(id = "downloadbtn_server", 
                                                       popoverId2 = paste0(iconId, "-popover2"), 
                                                       downloadId = paste0(iconId, "-datadownload")),
                      snapshot_button = snapshot(
                        saveScreenId = paste0(iconId, "-savescreen"),
                        popoverId = paste0(iconId, "-popover"),
                        accordionIdConcat = paste0("#", paste0(dataset, "_", accordionId)),
                        saveScreenName = paste0(accordionId),
                        tooltip_scale = div(class = "", style = "display: inline", 
                                            backendTooltip(span(`data-toggle`="tooltip", 
                                                                `data-placement`="right", 
                                                                `data-html` = "true",
                                                                title = "Werte kleiner als 1 verringern die Bildschirmauflösung, Werte größer als 1 erhöhen die Bildschirmauflösung.", 
                                                                HTML('<i class="bi bi-question-circle"></i>')))),
                        tooltip_filter = div(class = "", style = "display: inline; float: right;", 
                                             backendTooltip(span(`data-toggle`="tooltip", 
                                                                 `data-placement`="right", 
                                                                 `data-html` = "true",
                                                                 title = "Werte kleiner als 1 verringern die Bildschirmauflösung, Werte größer als 1 erhöhen die Bildschirmauflösung.", 
                                                                 HTML('<i class="bi bi-question-circle"></i>'))))),
                      optionalTooltip = optionalTooltip
  )
  
  return(out)
  
}

downloadbtn_ui <- function(id, downloadId, popoverId2) {
  
  ns <- NS(id)
  
  out <- htmlTemplate("www/htmlComponents/download_template.html",
                      downloadId = downloadId,
                      popoverId2 = popoverId2)
  
  return(out)
  
}

snapshot <- function(popoverId,
                     saveScreenId       ,
                     accordionIdConcat,
                     saveScreenName,
                     tooltip_scale,
                     tooltip_filter) {
  out <- htmlTemplate("www/htmlComponents/screenshot_template.html",
                      popoverId         = popoverId,
                      saveScreenId      = saveScreenId,
                      accordionIdConcat = accordionIdConcat,
                      saveScreenName    = saveScreenName,
                      tooltip_scale     = tooltip_scale,
                      tooltip_filter    = tooltip_filter,
                      headlineId        = paste0(popoverId, "-extr_title")
  )
  return(out)
}