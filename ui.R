
library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("Example 1: scatter chart"),
  sidebarPanel(
    selectInput("dataset", "Choose a dataset:", 
                choices = c("Vísitala kaupmáttar launa", "Bygging íbúðarhúsnæða", "Launakostnaðarvísitala"))
  ),
  mainPanel(
    htmlOutput("view")
  )
))