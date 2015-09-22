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
# http://px.hagstofa.is/pxis/pxweb/is/Atvinnuvegir/Atvinnuvegir__ferdathjonusta__Gisting__GiAnnad/SAM01400.px/table/tableViewLayout1/?rxid=ce96ef85-27bc-4c35-af05-edeeb8da91ff
# Gögn: data.ibudagist
#############
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

ibudagist_keys_response <- GET("http://px.hagstofa.is/pxis/api/v1/is/Atvinnuvegir/ferdathjonusta/Gisting/GiAnnad/SAM01400.px")
ibudagist_keys <- responseToJson(ibudagist_keys_response)

data.ibudagist <- NULL
ibudagistJson <- responseToJson(ibudagist_response)
i = 1
for (ibudagist in ibudagistJson$data)
{
  for (value in ibudagist$values)
  {
    year_value <- ibudagist_keys$variables[[2]]$valueTexts[i]
    i <- i + 1
    df.ibudagist <- data.frame(ar = year_value, naetur=value)
    data.ibudagist <- rbind(data.ibudagist, df.ibudagist)
  }
}