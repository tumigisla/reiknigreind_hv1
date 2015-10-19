library(googleVis)
library(shiny)

# Backend fyrir Shiny App.

shinyServer(function(input, output, session) {
  
  # Les in gögnin fyrir síðunni frá vefsíðu hagstofunnar og
  # frá csv skrám frá þjóðskránni.
  source('data/read_csv.R', local=TRUE, chdir=T, encoding = 'UTF-8')
  source('data/gognHagstofa.R', local=TRUE, chdir=T, encoding = 'UTF-8')
  
  # Set inn lista af breytum í val á síðunni.
  updateSelectInput(session, "xaxis", choices=colnames(masterFrame)[2:length(colnames(masterFrame))])
  updateSelectInput(session, "yaxis", choices=colnames(masterFrame)[2:length(colnames(masterFrame))])
  updateSelectInput(session, "sizeaxis", choices=colnames(masterFrame)[2:length(colnames(masterFrame))])
  
  yaxisVariable <- reactive({input$yaxis})
  xaxisVariable <- reactive({input$xaxis})
  sizeVariable <- reactive({input$sizeaxis})
  
  # Útskýringar fyrir breytunnar.
  output$xvar <- xaxisVariable
  output$xvarUtskyring <- reactive(toString(breyturUtskyringar[xaxisVariable()]))
  output$yvar <- yaxisVariable
  output$yvarUtskyring <- reactive(toString(breyturUtskyringar[yaxisVariable()]))
  output$sizevar <- sizeVariable
  output$sizevarUtskyring <- reactive(toString(breyturUtskyringar[sizeVariable()]))
  
  # Bubble Chart með x-, y- og stærðarása sem valdnir voru af notenda.
  output$view <- renderGvis({
    options = list(width=1000, height=1000, hAxis=paste0('{title: "', xaxisVariable(),'"}'), vAxis = paste0('{title: "', yaxisVariable(), '"}'),
                   colorAxis = '{legend: {position: "none"} }')
    gvisBubbleChart(masterFrame, idvar="Ár", xvar=xaxisVariable(), yvar=yaxisVariable(), colorvar = "Ár", sizevar = sizeVariable(), options=options)
  })
})