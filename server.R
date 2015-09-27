library(googleVis)
library(shiny)
shinyServer(function(input, output) {
  datasetInput <- reactive({
    switch(input$dataset,
           "rock" = "Ár",
           "pressure" = "Ár",
           "cars" = "Ár")})
  
  output$view <- renderGvis({
    masterFrame$key <- rep(2015, 21)
    gvisBubbleChart(gistinaetur_modified, idvar="Ár", timevar = "key")
  })
})