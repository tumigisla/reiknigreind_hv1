library(googleVis)
library(shiny)
shinyServer(function(input, output) {
  datasetInput <- reactive({
    switch(input$dataset,
           "rock" = hbsv_eftir_ar_all,
           "pressure" = pressure,
           "cars" = cars)})
  
  output$view <- renderGvis({
    gvisBubbleChart(datasetInput(), idvar="Ár", xvar="Meðaltals.flatarmál.mengis..m2.", yvar="Kaupverð.á.fermeter..krónur.", sizevar="Fjöldi.mengis", options=list(width=1000, height=1000))
  })
})