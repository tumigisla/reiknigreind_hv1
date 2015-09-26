library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
  datasetInput <- reactive({
    switch(input$dataset,
           "Vísitala kaupmáttar launa" = visitala_kaupmattar_launa,
           "Bygging íbúðarhúsnæða" = ygging_ibudarhusnaeda,
           "Launakostnaðarvísitala" = launakostnadarvisitala)
  })
  

  
  output$view <- renderGvis({
    gvisMotionChart(datasetInput(), idvar="Eignir alls", timevar="Ár", options=list(width=400, height=450))
  })
  
})