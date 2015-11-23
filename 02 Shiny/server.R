# server.R
require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
require(shiny)
require(shinydashboard)
require(leaflet)

shinyServer(function(input, output) {
  
  df3 <- eventReactive(input$clicks3, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
        """select CAUSE_NAME, STATE, YEAR, DEATHS, AADR 
          from COD c join NHCE n
          on c.STATE = n.STATE_NAME;"""
        ')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_riw223', PASS='orcl_riw223', 
        MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
  })
  
  output$distPlot3 <- renderPlot(height=1000, width=2000, {
    plot3 <- ggplot(aes(x = DEATHS, y = Y1999)) +
      geom_point() + geom_smooth(method = lm) + 
      labs(title= 'Correlation between Spending on Hospital Care and Deaths caused by Diseases of the Heart', x= 'Deaths',y='Spending in 1999')
    plot3
  })
  
})