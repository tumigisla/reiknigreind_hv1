shinyUI(pageWithSidebar(
  headerPanel("Fasteignaverð og áhrifaþættir þess"),
  sidebarPanel(
    selectInput("xaxis", "Veldu breytu fyrir x-ás",
                choice = colnames(masterFrame)[2:length(colnames(masterFrame))]),
    selectInput("yaxis", "Veldu breytu fyrir y-ás", 
                choices = colnames(masterFrame)[2:length(colnames(masterFrame))]),
    selectInput("sizeaxis", "Veldu breytu fyrir kúlustærð",
                choice = colnames(masterFrame)[2:length(colnames(masterFrame))]),
    htmlOutput("xvar"),
    htmlOutput("yvar"),
    htmlOutput("sizevar")
  ),
  mainPanel(
    htmlOutput("view")
  )
))