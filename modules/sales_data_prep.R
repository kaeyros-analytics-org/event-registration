library(mongolite)
library(plotly)
library(bslib)
library(shiny)
library(bsicons)
library(openxlsx)

connection_string <- ""
fetch_mongodb <- function(connection_string, collection, db) {
  reports <- tryCatch({
    mongo(collection = collection, db = db, url = connection_string)
  }, error = function(e) {
    cat("Erreur de connexion à MongoDB:", e$message, "\n")
    return("Erreur de connexion à MongoDB:", e$message, "\n")
  })
  
  if (is.null(reports)) {
    cat("Impossible de récupérer les rapports depuis MongoDB.\n")
  } else {
    reports <- as.data.frame(reports$find(field = '{}'))
    cat("Données récupérées depuis MongoDB avec succès.\n")
  }
  
  return(reports)
}
salesforms <- fetch_mongodb(connection_string,"salesvisits","test")
salesrepresentative <- fetch_mongodb(connection_string,"salesrepresentatives","test")
#sales <- c("Joel Mbollo","Natacha Begue","Paul Makang","Joyce Nkewang","Eric Djahmeni")

data1 <- merge(salesforms,salesrepresentative,by.x = "sale_representative_id",by.y = "_id")
data1 <- data1 %>% filter(name!="Brice" & name!="F")

data1 <- data1 %>%
  mutate(createdAt = as.POSIXct(createdAt.x, format = "%Y-%m-%d %H:%M:%S"))
data1$createdAt.x <- as.Date(data1$createdAt.x)
data1 <- data1 %>% filter(createdAt.x>="2025-01-01")
data1 <- data1 %>%
  mutate(city = ifelse(name == "Eric Djahmeni", "Yaoundé", city))
data1 <- data1 %>%
  mutate(prospecting_type = ifelse(name == "Eric Djahmeni", "Physique", prospecting_type))
data1 <- data1 %>%
  mutate(customer_decision = ifelse(business_name %in% c("Massage therapeutique asiatique ","Global barber "),
                                    "Pas interessé", customer_decision))
data1 <- data1 %>%
  mutate(customer_decision = ifelse(business_name %in% c("Mahaza beauty","Maurinho onglerie ","Zen Barber",
                                                         "Golden Diamond"),
                                    "Interessé", customer_decision))

colonnes_a_supprimer <- c("sale_representative_id","_id", "sale_representative_code","__v.x", "updatedAt.x",
                          "code", "createdAt.y", "updatedAt.y", "__v.y","createdAt.x")

# Supprimer les colonnes
data1 <- data1 %>%
  select(-one_of(colonnes_a_supprimer))
data1$contact <- as.numeric(data1$contact)

data_old <- read.xlsx("./data/old_bd.xlsx")
#zone, achievement, visit_objective,visit_carried_out
data_old$zone <- NA
data_old$achievement <- NA
data_old$visit_objective <- NA
data_old$visit_carried_out <- NA
data_old$suggested_introductory_price <- NA
data_old$proposed_monthly_price <- NA

# Conversion en format date
data_old$createdAt <- as.Date(data_old$createdAt, origin = "1899-12-30")
data <- bind_rows(data_old,data1)
data <- data %>% rename(createdAt.x=createdAt)
data$name <- ifelse(data$name=="Joyce","Joyce Nkewang",data$name)
data$createdAt.x <- as.Date(data$createdAt.x)
data_week <- data %>%
  mutate(Semaine = floor_date(createdAt.x, unit = "week", week_start = 1))

n_salerep <- length(unique(data$name))

couleurs <- c("#A4A2FF","#F1F39F","#EF63F5","#85DEA3","#F7B17D","#6247aa")

df <- data %>%
  mutate(Semaine = floor_date(createdAt.x, unit = "week")) #, week_start = 1






# library(mongolite)
# library(plotly)
# library(bslib)
# library(shiny)
# library(bsicons)
# library(openxlsx)
# 
# connection_string <- "mongodb+srv://info:NY8tQ2OLZwdGqu7I@event-registration.1adqzcs.mongodb.net/?retryWrites=true&w=majority&appName=event-registration"
# fetch_mongodb <- function(connection_string, collection, db) {
#   reports <- tryCatch({
#     mongo(collection = collection, db = db, url = connection_string)
#   }, error = function(e) {
#     cat("Erreur de connexion à MongoDB:", e$message, "\n")
#     return("Erreur de connexion à MongoDB:", e$message, "\n")
#   })
# 
#   if (is.null(reports)) {
#     cat("Impossible de récupérer les rapports depuis MongoDB.\n")
#   } else {
#     reports <- as.data.frame(reports$find(field = '{}'))
#     cat("Données récupérées depuis MongoDB avec succès.\n")
#   }
# 
#   return(reports)
# }
# salesforms <- fetch_mongodb(connection_string,"salesvisits","test")
# salesrepresentative <- fetch_mongodb(connection_string,"salesrepresentatives","test")
# #sales <- c("Joel Mbollo","Natacha Begue","Paul Makang","Joyce Nkewang","Eric Djahmeni")
# 
# data1 <- merge(salesforms,salesrepresentative,by.x = "sale_representative_id",by.y = "_id")
# data1 <- data1 %>% filter(name!="Brice" & name!="F")
# 
# data1 <- data1 %>%
#   mutate(createdAt = as.POSIXct(createdAt.x, format = "%Y-%m-%d %H:%M:%S"))
# data1$createdAt.x <- as.Date(data1$createdAt.x)
# data1 <- data1 %>% filter(createdAt.x>="2025-01-01")
# data1 <- data1 %>%
#   mutate(city = ifelse(name == "Eric Djahmeni", "Yaoundé", city))
# data1 <- data1 %>%
#   mutate(prospecting_type = ifelse(name == "Eric Djahmeni", "Physique", prospecting_type))
# data1 <- data1 %>%
#   mutate(customer_decision = ifelse(business_name %in% c("Massage therapeutique asiatique ","Global barber "),
#                                                          "Pas interessé", customer_decision))
# data1 <- data1 %>%
#   mutate(customer_decision = ifelse(business_name %in% c("Mahaza beauty","Maurinho onglerie ","Zen Barber",
#                                                          "Golden Diamond"),
#                                     "Interessé", customer_decision))
# 
# colonnes_a_supprimer <- c("sale_representative_id","_id", "sale_representative_code","__v.x", "updatedAt.x",
#                           "code", "createdAt.y", "updatedAt.y", "__v.y","createdAt.x")
# 
# # Supprimer les colonnes
# data1 <- data1 %>%
#   select(-one_of(colonnes_a_supprimer))
# data1$contact <- as.numeric(data1$contact)
# 
# data_old <- read.xlsx("./data/old_bd.xlsx")
# #zone, achievement, visit_objective,visit_carried_out
# data_old$zone <- NA
# data_old$achievement <- NA
# data_old$visit_objective <- NA
# data_old$visit_carried_out <- NA
# data_old$suggested_introductory_price <- NA
# data_old$proposed_monthly_price <- NA
# # Conversion en format date
# data_old$createdAt <- as.Date(data_old$createdAt, origin = "1899-12-30")
# data <- bind_rows(data_old,data1)
# data <- data %>% rename(createdAt.x=createdAt)
# data$name <- ifelse(data$name=="Joyce","Joyce Nkewang",data$name)
# data$createdAt.x <- as.Date(data$createdAt.x)
# 
# #data <- readRDS("./data/data.rds")
# n_salerep <- length(unique(data$name))
# # data_filter <- reactive({
# #   data %>%
# #     filter(as.Date(createdAt.x) >= filterStates$date_start & as.Date(createdAt.x) <= filterStates$date_end) %>%
# #     filter(if (!"TOUT" %in% filterStates$selectedCity) city == filterStates$selectedCity  else TRUE) %>% #filterStates$selectedCity
# #     filter(if (length(filterStates$selectedtyp_pdv) != 0 && !"TOUT" %in% filterStates$selectedtyp_pdv) type_of_business %in% filterStates$selectedtyp_pdv  else TRUE) %>%
# #     filter(if (length(filterStates$selectedtyp_prospect) != 0 && !"TOUT" %in% filterStates$selectedtyp_prospect) prospecting_type %in% filterStates$selectedtyp_prospect  else TRUE) %>%
# #     filter(if (!"TOUT" %in% filterStates$commercial) name == filterStates$commercial  else TRUE)
# # })
# 
# data3 <- shiny::reactiveFileReader(1000, NULL, "./data/data_reactive.rds", readRDS)
# data_filter <- reactive({
#   data3() %>%
#         filter(as.Date(createdAt.x) >= filterStates$date_start & as.Date(createdAt.x) <= filterStates$date_end) %>%
#         filter(if (!"TOUT" %in% filterStates$selectedCity) city == filterStates$selectedCity  else TRUE) %>% #filterStates$selectedCity
#         filter(if (length(filterStates$selectedtyp_pdv) != 0 && !"TOUT" %in% filterStates$selectedtyp_pdv) type_of_business %in% filterStates$selectedtyp_pdv  else TRUE) %>%
#         filter(if (length(filterStates$selectedtyp_prospect) != 0 && !"TOUT" %in% filterStates$selectedtyp_prospect) prospecting_type %in% filterStates$selectedtyp_prospect  else TRUE) %>%
#         filter(if (!"TOUT" %in% filterStates$commercial) name == filterStates$commercial  else TRUE)
#     
# })

couleurs <- c("#A4A2FF","#F1F39F","#EF63F5","#85DEA3","#F7B17D","#6247aa")

accordionCard <- function(accordionId = "accordionOne", 
                          headerId = 'headerOne',
                          targetId = 'collapseOne',
                          headerContent = 'headerContent #1',
                          bodyContent = '',
                          iconId = 'icon',
                          dataset = 'Home',
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
                                                                title = "Les valeurs inférieures à 1 réduisent la résolution de l'écran, les valeurs supérieures à 1 augmentent la résolution de l'écran.", 
                                                                HTML('<i class="bi bi-question-circle"></i>')))),
                        tooltip_filter = div(class = "", style = "display: inline; float: right;", 
                                             backendTooltip(span(`data-toggle`="tooltip", 
                                                                 `data-placement`="right", 
                                                                 `data-html` = "true",
                                                                 title = "Les valeurs inférieures à 1 réduisent la résolution de l'écran, les valeurs supérieures à 1 augmentent la résolution de l'écran.", 
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
