# credentials <- data.frame(
#   user = c("admin", "user", "Joel Mbollo","Natacha Begue","Paul Makang","Joyce Nkewang","Eric Djahmeni","Odilon","Patrick" 
# ),
#   password = c("admin", "user", "joel2025#", "natacha2025#","paul2025#","joyce2025#", "eric2025#","odilon2025#","patrick2025#"),
#   level = c(2, 0,1,1,1,1,1,1,1),
#   # password will automatically be hashed
#   admin = c(TRUE, FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE),
#   stringsAsFactors = FALSE
# )
# 
# key_set("R-shinymanager-key", "gtacars")
# 
# create_db(
#   credentials_data = credentials,
#   sqlite_path = "./data/database.sqlite", # will be created
#   #passphrase = key_get("R-shinymanager-key", "antid")
#    passphrase = "passphrase_wihtout_keyring"
# )
custom_css <- "

.custom-nav-buttons {
  display: flex;
  gap: 20px;
  align-items: center;
  width:100%;
  justify-content: space-between;
  }

.generate {
  width: max-content !important;
}

.panel-auth {
  background-color: #a06cd5;
}
.btn-primary {
  background-color: #a06cd5 !important;
  border-color: #a06cd5 !important;
}

.input-group-addon {
  padding: 0 !important;
}

.nav-btn {
  border: none; /* Supprime les bordures */
  background-color: #BBBBF5;
  border-radius: 5px;
  padding: 5px 15px;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s ease;
  width: 150px;
}
.layout-fixed .main-sidebar {
  background-color: #EAF4F4;
}
.nav-btn:hover {
  background-color: #eaeaea;
}

.nav-btn.active {
  background-color: #6247AA;
  color: white;
}
.btn-filter{
  background-color: #6247AA;
  color:  #fff;
  font-weight: bold;
  margin-left: 15%;
  margin-right: 15%
}
.cards_overview_list {
  margin-top: 1rem;
  display: flex;
  justify-content: center;
  margin: auto;
  gap: 2rem;
  width: 91%;
  height: 5%;
}
.os-content {
  background-color:#EAF4F4;
}
.card_last_day {
  display: flex; 
  justify-content: center; 
  gap: 20px; 
  margin: 0 250px;
}
.sidebar-header {
  display: inline;
  margin-left: 20px;
  color: black !important;
}
.overview_card {
  padding-top: 8px;
  background-color: #FFE4F3;
  border-radius: 12px;
  padding: 0.5rem 1rem;
  border: 1px solid rgb(213, 213, 213);
  width: 100%;
  display: flex;
}
.overview_card_header {
    font-size: 0.5rem !important;
    width: 100%;
}

.overview_card_header h2 {
    font-size: 1.2rem !important;
    font-weight: bold;
    margin-top:5px;
}

.overview_card_content {
  font-size: 35px;
  float: right;
  padding-top: 8px;
}
  
.overview_card_title {
  color: #BE1622;
  font-size: 15px;
}

.card-header {
    padding: 5px;
    font-weight: bold;
    border: none;
    color:#3392c5;
}
.card-body {
    padding: 5px;
}
  
.accordionBody {
  position: relative;
}
.action-button {
    
}

.modal-dialog {
  position: fixed;
  background-color: blue;
  top: 5%;
  left: 30vw;
  width: 40vw;
 
}

.reactable-llp9uv {
  width:15% !important;
  float: right !important; 
}
.value-box-title {
  font-size:18px !important;
}

.cart {
  display: flex;
  background-color:#2B254B;
  color:white;
  width: 100%;
  height: 100px;
  justify-content: space-between;
  align-items: center;
  padding: 0 15px;
}
.second-child {
  width: 80%;
  display:flex;
  flex-direction: column;
  flex-wrap: wrap;
  

}
.second-child-container {
  width: 100%;
  justify-items: end;
  align-items: end;
  
}
.second-child h1{
  font-size: 25px;
}
.cart-container {
  width: 100%;
  display: flex;
  column-gap: 10px;
}
.nav-btn.active {
    background-color: #6247AA; /* Couleur de fond rouge */
    color: white; /* Couleur du texte */
}
.layout-navbar-fixed .wrapper .main-header {
  background-color: #BBBBF5;
}
"

set_labels(
  language = "en",
  "Please authenticate" = "",
  "Language"=""
)

ui <- dashboardPage(
  fullscreen = TRUE,
  scrollToTop = TRUE,
  header = bs4DashNavbar(
    title = dashboardBrand(
      title = "Sales Reporting",
      #color = "danger", #gray-dark
      href = "https://kaeyros-analytics.com/fr",
      image = "./images/kaeyros.png"
      #opacity = 0.8
    ),
    skin = "light",
    status = "white",
    fixed = TRUE,
    # Boutons personnalisés pour la navigation
    div(
      class = "custom-nav-buttons",
      div(style="display: flex; gap: 13px;",
        actionButton("go_add_data", "Map", class = "nav-btn"),
      actionButton("data", "Data", class = "nav-btn"),
      actionButton("perf", "Performance", class = "nav-btn"),
      #actionButton("go_last_day_stats", "Last Day Stats", class = "nav-btn"),
      actionButton("go_dashboard", "Dashboard", class = "nav-btn active")
      )
      # div(
      #   actionButton("generate_repport_data", "Generate", class = "btn-filter",
      #              icon = icon("file-download"),
      #              style = "background-color: black; color: white;border-color: #000;
      #                             cursor: pointer; margin-left: inherit; display: flex; align-items: center; column-gap: 4px;"
      # ))
    )
    ################# Button to upload files
    # actionButton("generate_repport_data", "Generate", class = "btn-filter",
    #              icon = icon("file-download"),
    #              style = "background-color: black; color: white;border-color: #000;
    #                               cursor: pointer; margin-left: inherit;"
    # ),
    # downloadButton("download_report", "Download Report", style = "visibility: hidden;")
    #downloadButton("download_report", "Download as.docx)",style = "visibility: hidden;")
  ),
  sidebar = bs4DashSidebar(
    
    minified = FALSE,
    fixed = TRUE,
    status = "#2B254B",
    div(
      id = "filters",  # Conteneur pour les filtres
      tagList(actionButton("today", class = "btn-filter",
                               label = "Aujourd'hui"
                               #iconProps = list(iconName = "calendar"),
                               #style = "background-color: #14259B; color: #fff;"
      )),
      br(),
      div(id = "filterBox", style = "align-items: center;",
          #actionButton("today","Aujourd'hui"),
          tagList(
            uiOutput("dateRange"),
            #uiOutput(ns("timeSerie")),
            uiOutput("city"),
            uiOutput("typ_pdv"),
            uiOutput("typ_prospect"),
            uiOutput("commercial"),
            uiOutput("filter_button"),
            tags$br(),
            uiOutput("reset_filter"),
          )
          
      )
      
    )
  ),
  body = bs4DashBody(
    useShinyjs(),
    # Pour rendre les cartes extensible
    tags$script(
      "$(function(){
        $('.card')
        .find('[data-card-widget=\"maximize\"]')
        .on('click', function(e) {
          // it may take some time for the resizing of the card to happen
          setTimeout(function(){
            let chart = $(e.target)
              .closest('.card')
              .find('.echarts4r')
              .first();

            if(!chart)
              return;

            let id = chart.attr('id')

            let $parent = $(chart).parent(); 
            let w = $parent.width();
            let h = $parent.height();
            console.log(h);
            $('#chart').parent().css({
              width: w + 'px',
              height: h + 'px'
            })
            get_e_charts(id).resize({width: w, height: h});
          }, 250);
        });
      });"
    ),
    uiOutput("page_content")  # Contenu dynamique
  ),
  footer = bs4DashFooter(
    div(
      style = "text-align: center; padding: 10px;",
      "© 2024 GTA - Dashboard | By Kaeyros Analytics"
    )
  ))
  
ui <- tagList(
  tags$head(
    tags$style(HTML(custom_css))
  ),
  useShinyjs(),  # Pour manipuler dynamiquement les classes CSS
  ui
)

ui <- shinymanager::secure_app(ui,choose_language = FALSE, enable_admin = TRUE,
                               # changing theme for the credentials

                               theme = shinythemes::shinytheme("united"), #journal,sandstone,spacelab
                               tags_top = tags$div(
                                 tags$head(tags$style(css)),
                                 tags$h3("Login", style = "text-align: left; font-weight: bold;"), #align:lnbeft
                                 tags$h5("Welcome back! Please log in to access your account ", style = "text-align: left;"),

                               )
)

# ui <- shinymanager::secure_app(
#   ui,
#   choose_language = FALSE,
#   enable_admin = TRUE,
#   tags_top = tags$div(
#     tags$head(tags$style(css)),
#     div(
#       class = "panel-auth",
#       tags$h3("Login"),
#       tags$h5("Welcome back! Please log in to access your account"),
#       tags$input(type = "text", placeholder = "Username", id = "username"),
#       tags$input(type = "password", placeholder = "Password", id = "password"),
#       tags$button(class = "btn-primary", "Login"),
#       tags$a(href = "#", "Forgot password?")
#     )
#   )
# )