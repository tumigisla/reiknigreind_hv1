shinyUI(fluidPage(
  
  h1("Fasteignaverð og áhrifaþættir þess", align='center'),
  
  
  
  hr(),
  
  fluidRow(
    column(4,
           wellPanel(
              h4('Graph Controls', align='center'),
              hr(),
              selectInput("xaxis", "Veldu breytu fyrir x-ás",
                       choice = colnames(masterFrame)[2:length(colnames(masterFrame))]),
              selectInput("yaxis", "Veldu breytu fyrir y-ás", 
                       choices = colnames(masterFrame)[2:length(colnames(masterFrame))]),
              selectInput("sizeaxis", "Veldu breytu fyrir kúlustærð",
                       choice = colnames(masterFrame)[2:length(colnames(masterFrame))])
           ),
           tags$b(htmlOutput('xvar')), 
           htmlOutput('xvarUtskyring'),
           htmlOutput('yvar'), 
           htmlOutput('yvarUtskyring'),
           htmlOutput('sizevar'),
           htmlOutput('sizevarUtskyring')
    ),
    column(6,
           htmlOutput('view')
           )
  )
))
