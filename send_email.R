library(mailR)
library(dplyr)
library(glue)



data1 <- readRDS("C:/Users/LENOVO/Desktop/GTA/data/shared_data.rds")
#data1$DATE <- as.POSIXct(data1$DATE, format = "%d-%m-%Y %H:%M:%S")
data1 <- data1 %>% 
  mutate(DATE = as.Date(DATE)) %>%
  filter(DATE == as.Date(max(DATE) - 1))
nb_cars <- nrow(data1)
nb_sales <- sum(data1$PTTC)
cat <- data1 %>% group_by(CAT) %>%
  summarise(value=n())

# Générer la première phrase
intro <- glue("Pour la journée d'hier {nb_cars} voitures ont effectué des visites, générant un chiffre d'affaires total de {format(nb_sales, big.mark = ' ')} FCFA.")

# Générer les phrases pour chaque catégorie
details <- cat %>%
  mutate(sentence = glue("{value} voiture{ifelse(value > 1, 's', '')} de catégorie {CAT}")) %>%
  pull(sentence)

# Construire la phrase avec des virgules et un "et" final
details_text <- if (length(details) > 1) {
  paste(
    paste(details[-length(details)], collapse = ", "),
    details[length(details)],
    sep = " et "
  )
} else {
  details
}

# Ajouter la phrase complète
final_text <- glue("{intro} Nous avons eu {details_text}.")

# Afficher le résultat
print(final_text)

library(yaml)

# Lire le fichier de configuration
config <- yaml::read_yaml("C:/Users/LENOVO/Desktop/GTA/data/config.yml")

#Accéder aux informations
email_user <- config$email$user
email_pass <- config$email$pass
smtp_host <- config$smtp$host
smtp_port <- config$smtp$port
smtp_ssl <- config$smtp$ssl


send.mail(from = email_user,
          to = "winnie.mafouo@kaeyros-analytics.com",
          subject = "Report",
          body = final_text,
          smtp = list(host.name = smtp_host, port = 25,
                      user.name = email_user,#"test@kaeyros-analytics.de",
                      passwd = email_pass, ssl = TRUE),#"@@Test$$", ssl = TRUE),
          authenticate = TRUE,
          send = TRUE)

