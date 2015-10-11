library(googleVis)
library(shiny)
shinyServer(function(input, output) {
  yaxisVariable <- reactive({input$yaxis})
  xaxisVariable <- reactive({input$xaxis})
  sizeVariable <- reactive({input$sizeaxis})
  colorVariable <- reactive({input$coloraxis})
  
  output$view <- renderGvis({
    options = list(width=1000, heighxt=1000)
    gvisBubbleChart(masterFrame_wo_NAs, idvar="Ár", xvar=xaxisVariable(), yvar=yaxisVariable(), colorvar = "Ár", sizevar = sizeVariable(), options=options)
  })
})