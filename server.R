
shinyServer(function(input, output) {
  
    # use the new renderGvis
    output$gvMotion <- renderGvis({
      
      # subset <- skuldir_eignir_eiginfjarstada, idvar="Eignir alls", timevar="Ár")
      newFrame <- data.frame(subset)
      
    # produce chart
      gvisMotionChart(gistinaetur_modified, idvar="Alls", timevar="Ár")
  })
  
})