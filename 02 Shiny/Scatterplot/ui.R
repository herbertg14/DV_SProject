#ui.R 

library(shiny)

navbarPage(
  title = "Data Visualization",
  tabPanel( title = "Scatterplot",
    sidebarPanel(
      actionButton(inputId = "clicks3", label = "Click Me")
      ),
      mainPanel(plotOutput("distplot3")
      )
    )
  )
