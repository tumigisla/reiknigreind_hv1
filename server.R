library(googleVis)
library(shiny)
shinyServer(function(input, output) {
  datasetInput <- reactive({
    switch(input$dataset,
           "rock" = masterFrame,
           "pressure" = pressure,
           "cars" = cars)})
  
  output$view <- renderGvis({
    masterFrame$key <- rep(2015, 21)
    gvisBubbleChart(gistinaetur_modified, idvar="Ár", timevar = "key")
  })
})