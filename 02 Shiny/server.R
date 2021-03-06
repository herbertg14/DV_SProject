# server.R
require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
require(shiny)
require(shinydashboard)
require(leaflet)

shinyServer(function(input, output) {
        
      KPI_Low_Max_value <- reactive({input$KPI1})     
      KPI_Medium_Max_value <- reactive({input$KPI2})
      rv <- reactiveValues(alpha = 0.50)
      observeEvent(input$light, { rv$alpha <- 0.50 })
      observeEvent(input$dark, { rv$alpha <- 0.75 })
    
      df1 <- eventReactive(input$clicks1, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query="select CODE, ITEM, STATE_NAME, AVERAGE_ANNUAL_PERCENT_GROWTH, KPI as ratio,case when KPI < "p1" then \\\'03 Low\\\' when KPI < "p2" then \\\'02 Med\\\' else \\\'01 High\\\' end KPI from (select CODE, ITEM, STATE_NAME, AVERAGE_ANNUAL_PERCENT_GROWTH, AVERAGE_ANNUAL_PERCENT_GROWTH as KPI from NHCE where ITEM != \\\'Total State Spending\\\' AND STATE_NAME != \\\'null\\\')"')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_riw223', PASS='orcl_riw223', 
                 MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON', p1=KPI_Low_Max_value(), p2=KPI_Medium_Max_value()), verbose = TRUE)))
      })

      output$distPlot1 <- renderPlot({             
            plot <- ggplot() + 
                  coord_cartesian() + 
                  scale_x_discrete() +
                  scale_y_discrete() +
                  labs(title=isolate(input$title)) +
                  labs(x=paste("ITEM"), y=paste("STATE")) +
                  layer(data=df1(), 
                        mapping=aes(x=ITEM, y=STATE_NAME, label=round(AVERAGE_ANNUAL_PERCENT_GROWTH,2)), 
                        stat="identity", 
                        stat_params=list(), 
                        geom="text",
                        geom_params=list(colour="black"), 
                        position=position_identity()
                  ) +
                  layer(data=df1(), 
                        mapping=aes(x=ITEM, y=STATE_NAME, fill=KPI), 
                        stat="identity", 
                        stat_params=list(), 
                        geom="tile",
                        geom_params=list(alpha=rv$alpha), 
                        position=position_identity()
                  )
            plot
      }) 

      observeEvent(input$clicks, {
            print(as.numeric(input$clicks))
      })

      df2 <- eventReactive(input$clicks2, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query="select YEAR, ITEM, SPENDING from MELTEDDATA"')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_riw223', PASS='orcl_riw223', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
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
      
      df3 <- eventReactive(input$clicks3, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query="select * from SCATTER"')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_riw223', PASS='orcl_riw223', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
      })
      
      output$distPlot3 <- renderPlot(height=1000, width=2000, {
        plot3 <- ggplot() + 
          coord_cartesian() + 
          scale_x_continuous() +
          scale_y_continuous() +
          labs(title= 'Correlation between Spending on Hospital Care and Deaths caused by Diseases of the Heart', x= 'Deaths',y='Spending in 1999') +
          layer(data=df3(), 
                mapping=aes(x=DEATHS, y=SPENDING), 
                stat="identity", 
                stat_params=list(), 
                geom="point"
          ) 
        plot3
      })
      
})
