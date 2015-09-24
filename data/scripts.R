library(httr)
library(RJSONIO)

# response er eins og það kemur beint úr POST-i
responseToJson <- function(response)
{
  stop_for_status(response)  # Kastar http villu sem R villu
  jsonContent <- content(response, "text")
  
  if (substr(jsonContent, 1, 1) == "\uFEFF")
  { # Hreinsum út Byte-order-mark
    jsonContent <- substring(jsonContent, 2)
  }
  
  return(fromJSON(jsonContent))
}

#############
# Gistinætur í íbúðagistingu
# Útlendingar, 2005-2014, landið í heild sinni, árið í heild sinni
# Gögn: data.ibudagist
#############
ibudagist_keys_response <- GET("http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/ferdathjonusta/Gisting/GiAnnad/SAM01400.px")
ibudagist_keys <- responseToJson(ibudagist_keys_response)

ibudagist_response <- POST("http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/ferdathjonusta/Gisting/GiAnnad/SAM01400.px",
                            content_type("application/json"),
                            body='{
                                    "query": [
                                      {
                                        "code": "Ríkisfang",
                                        "selection": {
                                          "filter": "item",
                                          "values": [
                                            "2"
                                          ]
                                        }
                                      }
                                    ],
                                    "response": {
                                      "format": "json"
                                    }
                                  }')

data.ibudagist <- NULL
ibudagistJson <- responseToJson(ibudagist_response)
i = 1
for (ibudagist in ibudagistJson$data)
{
  for (value in ibudagist$values)
  {
    ar_gildi <- ibudagist_keys$variables[[2]]$valueTexts[i]
    i <- i + 1
    df.ibudagist <- data.frame(ar = ar_gildi, naetur=value)
    data.ibudagist <- rbind(data.ibudagist, df.ibudagist)
  }
}

#############
# Fermetraverð í byggingarvísitöluhúsi
# 1987-2015, árið í heild sinni
# Gögn: data.fermetraverd
#############
fermetraverd_keys_response <- GET("http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/idnadur/byggingavisitala/byggingarvisitala/VIS03304.px")
fermetraverd_keys <- responseToJson(fermetraverd_keys_response)

fermetraverd_response <- POST("http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/idnadur/byggingavisitala/byggingarvisitala/VIS03304.px",
                              content_type("application/json"),
                              body='{
                                    "query": [
                                      {
                                        "code": "Eining",
                                        "selection": {
                                          "filter": "item",
                                          "values": [
                                            "1"
                                          ]
                                        }
                                      }
                                    ],
                                    "response": {
                                      "format": "json"
                                    }
                                  }')

data.fermetraverd <- NULL
fermetraverdJson <- responseToJson(fermetraverd_response)
i <- 0
fjoldi_ara <- length(fermetraverd_keys$variables[[1]]$values)
listi_staks_ars <- NULL
for (fermetraverd in fermetraverdJson$data)
{
  if (fermetraverd$key[[1]] != i && fermetraverd$key[[1]] < 29) 
  {
    medaltal_ars <- Reduce("+", listi_staks_ars) / length(listi_staks_ars)
    ar_gildi <- suppressWarnings(fermetraverd_keys$variables[[1]]$valueTexts[[i + 1]])
    df.fermetraverd <- data.frame(ar = ar_gildi, fermetraverd = medaltal_ars)
    data.fermetraverd <- rbind(data.fermetraverd, df.fermetraverd)
    listi_staks_ars <- NULL
    i <- i + 1
  }
  if (!is.na(as.numeric(fermetraverd$values)))
    listi_staks_ars <- c(listi_staks_ars, as.numeric(fermetraverd$values))
}
medaltal_ars <- Reduce("+", listi_staks_ars) / length(listi_staks_ars)
ar_gildi <- suppressWarnings(fermetraverd_keys$variables[[1]]$valueTexts[[i + 1]])
df.fermetraverd <- data.frame(ar = ar_gildi, fermetraverd = medaltal_ars)
data.fermetraverd <- rbind(data.fermetraverd, df.fermetraverd)
listi_staks_ars <- NULL