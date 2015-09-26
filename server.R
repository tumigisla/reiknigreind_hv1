
shinyServer(function(input, output) {
  
    # use the new renderGvis
    output$gvMotion <- renderGvis({
      
      subset <- subset(bygging_ibudarhusnaeda, select=c("Ár","Fullgert á árinu Fjöldi íbúða"))
      newFrame <- data.frame(subset)
      
    # produce chart
      gvisScatterChart(newFrame, 
                       options=list(
                         legend="none",
                         lineWidth=2, pointSize=0,
                         title="Bygging íbúðarhúsnæða", vAxis="{title:'fjöldi íbúða'}",
                         hAxis="{title:'ár'}", 
                         width=800, height=800))
           
  })
  
})