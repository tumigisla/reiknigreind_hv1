library(googleVis)
library(shiny)
shinyServer(function(input, output) {
  yaxisVariable <- reactive({input$yaxis})
  xaxisVariable <- reactive({input$xaxis})
  sizeVariable <- reactive({input$sizeaxis})
  
  output$view <- renderGvis({
    options = list(width=1000, height=1000, hAxis=paste0('{title: "', xaxisVariable(),'"}'), vAxis = paste0('{title: "', yaxisVariable(), '"}'),
                   colorAxis = '{legend: {position: "none"} }')
    gvisBubbleChart(masterFrame, idvar="Ár", xvar=xaxisVariable(), yvar=yaxisVariable(), colorvar = "Ár", sizevar = sizeVariable(), options=options)
  })
})