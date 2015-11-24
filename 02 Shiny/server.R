# server.R
require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
require(shiny)
require(shinydashboard)
require(leaflet)

shinyServer(function(input, output) {


# Begin code for Second Tab:

      df2 <- eventReactive(input$clicks2, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
            "select YEAR, ITEM, SPENDING from MELTEDDATA"
            ')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_riw223', PASS='orcl_riw223', 
            MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
      })

      output$distPlot2 <- renderPlot(height=1000, width=2000, {
            plot1 <- ggplot () + 
              coord_cartesian() +
              scale_x_discrete() +
              scale_y_continuous() +
              labs(title = 'Annual Healthcare Expenditure in Texas by Service Type',x='Year',y='Spending') +
              layer(data = df2(), 
                    mapping = aes(x = YEAR, y =SPENDING, fill = ITEM), 
                    stat = 'identity',
                    geom = 'bar') + 
              theme(axis.text.x = element_text(angle = 45,size = 10))
              plot1
      })
})
