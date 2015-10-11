library(googleVis)
library(shiny)
shinyServer(function(input, output) {
  yaxisVariable <- reactive({input$yaxis})
  xaxisVariable <- reactive({input$xaxis})
  sizeVariable <- reactive({input$sizeaxis})
  
  output$view <- renderGvis({
    gvisBubbleChart(masterFrame_wo_NAs, idvar="Ár", xvar=xaxisVariable(), yvar=yaxisVariable(), colorvar = sizeVariable(), sizevar = sizeVariable())
  })

  output$view2 <- renderGvis({
    gvisScatterChart(skuldir_eignir_eiginfjarstada, options=list(
      legend="none",
      lineWidth=2, pointSize=0,
      title="Skuldir, eignir og eiginfjárstaða heimila á HBS", vAxis="{title:'þús. kr.'}",
      hAxis="{title:'ár'}", 
      width=600, height=600))
  })
})