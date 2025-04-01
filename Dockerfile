# Base R Shiny image
FROM rocker/shiny

# Installation de l'openjdk
RUN apt-get update && apt-get install -y openjdk-8-jdk

# Installation des dépendances R spécifiées
RUN R -e "install.packages(c( \
    'shiny', 'bs4Dash', 'shinyjs', 'shiny.fluent', 'reactable', 'dplyr', 'plotly', \
    'lubridate', 'readxl', 'shinymanager', 'shinythemes','shiny.fluent', 'shiny.router', 'shinyjs', 'shinymanager', 'keyring', 'echarts4r', 'flextable', \
    'officer', 'bslib', 'bsicons' \
  ))"

# Make a directory in the container
WORKDIR /app

# Copy your files into the container....S
COPY . /app 

RUN rm -rf /app/renv /app/renv.lock

# Installation de libglpk40 et libsecret-1-0
RUN apt-get update && apt-get install -y libglpk40 libsecret-1-0

# Installation des dépendances système pour les packages R
RUN apt-get update && apt-get install -y libudunits2-dev libproj-dev libgdal-dev libgeos-dev libgsl-dev

# Expose the application port
EXPOSE 8180

# Run the R Shiny app
CMD ["R", "-e", "Sys.setenv(RENV_AUTO_LOADER_ENABLED = FALSE); shiny::runApp('/app', host = '0.0.0.0', port = 8180)"]
