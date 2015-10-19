#UI hluti af Shiny app.

shinyUI(fluidPage(
  
  h1("Fasteignaverð og áhrifaþættir þess", align='center'),

  hr(),
  
  fluidRow(
    column(4,
           wellPanel(
             h3("Eftirfarandi gögn eru sett fram í þeim tilgangi að megi rýna og
               bera saman fjárhagslega stöðu almennings við fasteignaverð."),
             h4("Gögnin gilda fyrir allt landið nema annað sé tekið fram."),
             h4("HBSV: Höfuðborgarsvæðið.")
           ),
           wellPanel(
              h4('Stýringar fyrir graf', align='center'),
              hr(),
              selectInput("xaxis", "Veldu breytu fyrir x-ás",
                       choice = c("Byggingarvísitala")),
              selectInput("yaxis", "Veldu breytu fyrir y-ás", 
                       choices = c("Byggingarvísitala")),
              selectInput("sizeaxis", "Veldu breytu fyrir kúlustærð",
                       choice = c("Byggingarvísitala"))
           ),
           wellPanel(
              h4('Útskýringar á breytum', align='center'),
              hr(),
              tags$b(htmlOutput('xvar')), 
              htmlOutput('xvarUtskyring'),
              br(),
              tags$b(htmlOutput('yvar')), 
              htmlOutput('yvarUtskyring'),
              br(),
              tags$b(htmlOutput('sizevar')),
              htmlOutput('sizevarUtskyring')
           )
    ),
    column(6,
           htmlOutput('view')
           )
  )
))
