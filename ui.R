
shinyUI(pageWithSidebar(
  
  
  # Application title
  headerPanel("Motion Chart"),
  
  sidebarPanel(
    
    br(),
    p("Gögn frá hagstofunni - ",
      a("Hagstofan", href="wwfewafwafm")
    )
    
    ),
  
  
  mainPanel(
    
    tableOutput("gvMotion")
    
  )
))