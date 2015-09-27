library(googleVis)
library(shiny)
shinyServer(function(input, output) {
  yaxisVariable <- reactive({input$yaxis})
  xaxisVariable <- reactive({input$xaxis})
  
  output$view <- renderGvis({
    gvisBubbleChart(masterFrame_wo_NAs, idvar="Ár", xvar=xaxisVariable(), yvar=yaxisVariable())
  })
})