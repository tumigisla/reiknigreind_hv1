library(shiny)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
  
  myOptions <- reactive({
    list(
      page=ifelse(input$pageable==TRUE,'enable','disable'),
      pageSize=input$pagesize,
      width=550
    )
  })
  output$myTable <- renderGvis({
    gvisTable(gistinaetur,options=myOptions())         
  })
  
})
