library(googleVis)
library(shiny)
shinyServer(function(input, output) {
  yaxisVariable <- reactive({input$yaxis})
  xaxisVariable <- reactive({input$xaxis})
  sizeVariable <- reactive({input$sizeaxis})
  
  output$view <- renderGvis({
    gvisBubbleChart(masterFrame_wo_NAs, idvar="Ár", xvar=xaxisVariable(), yvar=yaxisVariable(), colorvar = sizeVariable(), sizevar = sizeVariable())
  })
  
  output$view <- renderGvis({
    gvisBubbleChart(masterFrame_wo_NAs, idvar="Ár", xvar=xaxisVariable(), yvar=yaxisVariable(), colorvar = sizeVariable(), sizevar = sizeVariable())
  })
})