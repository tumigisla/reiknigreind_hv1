library(googleVis)
library(shiny)
shinyServer(function(input, output) {
  yaxisVariable <- reactive({input$yaxis})
  xaxisVariable <- reactive({input$xaxis})
  sizeVariable <- reactive({input$sizeaxis})
  
  output$view <- renderGvis({
    options = list(width=1000, height=1000)
    gvisBubbleChart(masterFrame, 
                    idvar="Ár", 
                    xvar=xaxisVariable(), 
                    yvar=yaxisVariable(),
                    sizevar = sizeVariable(),
                    options=options)
  })
})