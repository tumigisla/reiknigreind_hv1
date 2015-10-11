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

  output$view2 <- renderGvis({
    gvisScatterChart(skuldir_eignir_eiginfjarstada, options=list(
      legend="none",
      lineWidth=2, pointSize=0,
      title="Skuldir, eignir og eiginfjárstaða heimila á HBS", vAxis="{title:'þús. kr.'}",
      hAxis="{title:'ár'}", 
      width=600, height=600))
  })
})