shinyUI(pageWithSidebar(
  headerPanel("Example 1: scatter chart"),
  sidebarPanel(
    selectInput("yaxis", "Choose Variable for Y-axis:", 
                choices = colnames(masterFrame_wo_NAs)),
    selectInput("xaxis", "Choose Variable for X-axis:",
                choice = colnames(masterFrame_wo_NAs))
  ),
    mainPanel(
    htmlOutput("view")
  )
))