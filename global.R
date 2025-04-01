library(shiny)
library(bs4Dash)
library(shinyjs)
library(shiny.fluent)
library(reactable)
library(dplyr)
library(plotly)
library(lubridate)
library(readxl)
library(shinyjs)
library(shinymanager)
library(keyring)
library(echarts4r)
library(flextable)
library(officer)
library(bslib)
library(bsicons)
library(sf)
library(tidyr)
library(leaflet)
library(writexl)

# source("modules/dashboard.R")
# source("modules/add_data.R")
# source("modules/functions.R")
# source("modules/last_days.R")
# source("modules/generate_report.R")
# source("./modules/data_report.R")
# source("./modules/download_data.R")
source("./modules/sales_data_prep.R")
source("./modules/dashboard_page.R")
source("./modules/map_page.R")
source("./modules/data_page.R")
source("./modules/performance_page.R")



#mensuel_data <- readxl::read_xlsx("./data/etat _mensuel_de_jan_2024.xlsx", sheet = 2)
# mensuel_data <- readRDS("./data/shared_data.rds")
# #data <- readxl::read_xlsx("./data/ETATS  MENSUEL DE JAN20241.xlsx")
# data <- readxl::read_xlsx("./data/data1.xlsx")
# data$REFUS <- as.character(data$REFUS)
# data$ACCEPTE <- as.double(data$ACCEPTE)
# data$CONTACT <- as.double(data$CONTACT)
# mensuel_data$REFUS <- as.character(mensuel_data$REFUS)
# mensuel_data$ACCEPTE <- as.double(mensuel_data$ACCEPTE)
# mensuel_data$CONTACT <- as.double(mensuel_data$CONTACT)


#data1 <- readxl::read_xlsx("./data/etat_entreprise_listening_caisse.xlsx")


# filterStates <- reactiveValues(
#   # dataset
#   #dataNavi = list(dataset = "Add data"),
#   #allDataset = NULL,
#   #allSubItem = NULL,
#   categorySelected = "All",
#   #accepteSelected ="All",
#   # statusSelected = "TOUT",
#   date_start = min(mensuel_data$DATE),
#   date_end = max(mensuel_data$DATE),#max(mensuel_data$DATE),
#   filterButton = FALSE
# )
# filterStates <- reactiveValues(
#   # dataset
#   #dataNavi = list(dataset = "Map"),
#   selectedCity = "TOUT",
#   selectedtyp_pdv = "TOUT",
#   selectedtyp_prospect = "TOUT",
#   commercial="TOUT",
#   allCountry = "",
#   TimeSerieRange = NULL,
#   date_start = "2025-01-01",
#   date_end = Sys.Date(),
#   filterButton = FALSE
# )
backendTooltip <- function(tooltipContent,
                           cssClass = "tooltipIcon") {
  
  out <- htmlTemplate("www/htmlComponents/tooltip.html",
                      cssClass = cssClass,
                      tooltipContent = tooltipContent
  )
  
  return(out)
  
}
#ebe8e8 #2B8049
css <- HTML(".btn-primary { 
                  color: #fff;
                  background-color: #a4161a; 
                  border-color: #a4161a;
}
              .panel-auth {
              background-color: #a4161a ;
              }
              .panel-primary {
                  border-color: #939393;
                  width: 100%;
                  z-index: 2;
                  top: 0;
                  left: 0;
                  height: 100%;
                  position: fixed;
                  max-width: 750px;
                  padding: 200px 90px;
              }")
# css <- HTML("
#     body {
#         background: linear-gradient(135deg, #A64BFF 50%, #ffffff 50%);
#         display: flex;
#         justify-content: center;
#         align-items: center;
#         height: 100vh;
#         margin: 0;
#         font-family: Arial, sans-serif;
#     }
#     .panel-auth {
#         background-color: #ffffff;
#         
#         box-shadow: 0 8px 30px rgba(0, 0, 0, 0.2);
#         padding: 40px 30px;
#         width: 800px;
#         text-align: center;
#     }
#     .panel-auth h3 {
#         font-size: 28px;
#         margin-bottom: 20px;
#         font-weight: bold;
#     }
#     .panel-auth h5 {
#         font-size: 16px;
#         margin-bottom: 30px;
#         color: #666;
#     }
#     .panel-auth input {
#         border: 2px solid #A64BFF;
#         border-radius: 25px;
#         padding: 12px 15px;
#         width: 90%;
#         margin-bottom: 20px;
#         font-size: 16px;
#     }
#     .panel-auth .btn-primary {
#         color: #ffffff;
#         background-color: #A64BFF;
#         border: none;
#         border-radius: 25px;
#         padding: 12px 25px;
#         font-size: 18px;
#         cursor: pointer;
#         transition: background-color 0.3s ease;
#         width: 90%;
#     }
#     .panel-auth .btn-primary:hover {
#         background-color: #9228E8;
#     }
#     .panel-auth a {
#         display: block;
#         margin-top: 15px;
#         font-size: 14px;
#         color: #A64BFF;
#         text-decoration: none;
#     }
#     .panel-auth a:hover {
#         text-decoration: underline;
#     }
# ")







# Styles CSS personnalisés
# custom_css <- "
# 
# .custom-nav-buttons {
#   display: flex;
#   gap: 20px;
#   align-items: center;
# }
# 
# .generate {
#   width: max-content !important;
# }
# 
# .input-group-addon {
#   padding: 0 !important;
# }
# 
# .nav-btn {
#   border: none; /* Supprime les bordures */
#   background-color: #f9f9f9;
#   border-radius: 5px;
#   padding: 5px 15px;
#   font-weight: bold;
#   cursor: pointer;
#   transition: all 0.3s ease;
# }
# 
# .nav-btn:hover {
#   background-color: #eaeaea;
# }
# 
# .nav-btn.active {
#   background-color: #DC3545;
#   color: white;
# }
# .btn-filter{
#   background-color: #DC3545;
#   color:  #fff;
#   font-weight: bold;
#   margin-left: 15%;
#   margin-right: 15%
# }
# .cards_overview_list {
#   margin-top: 1rem;
#   display: flex;
#   justify-content: center;
#   margin: auto;
#   gap: 2rem;
#   width: 91%;
# }
# .sidebar-header {
#   display: inline;
#   margin-left: 20px;
# }
# .overview_card {
#   padding-top: 8px;
#   background-color: #FFE4F3;
#   border-radius: 12px;
#   padding: 0.5rem 1rem;
#   border: 1px solid rgb(213, 213, 213);
#   width: 100%;
#   display: flex;
# }
# .overview_card_header {
#     font-size: 0.5rem !important;
#     width: 100%;
# }
# 
# .overview_card_header h2 {
#     font-size: 1.2rem !important;
#     font-weight: bold;
#     margin-top:5px;
# }
# 
# .overview_card_content {
#   font-size: 35px;
#   float: right;
#   padding-top: 8px;
# }
#   
# .overview_card_title {
#   color: #BE1622;
#   font-size: 15px;
# }
# 
# .card-header {
#     padding: 5px;
#     font-weight: bold;
#     border: none;
#     color:#3392c5;
# }
# .card-body {
#     padding: 5px;
# }
#   
# .accordionBody {
#   position: relative;
# }
# 
# "