
library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("Gistinætur"),
  sidebarPanel(
    checkboxInput(inputId = "pageable", label = "Pageable"),
    conditionalPanel("input.pageable==true",
                     numericInput(inputId = "pagesize",
                                  label = "Countries per page",20))    
  ),
  mainPanel(
    htmlOutput("myTable")
  )
))