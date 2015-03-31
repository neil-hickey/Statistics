## server.R ##
library(shiny)
library(shinydashboard)
library(ggplot2)
library(gridExtra)
library(devtools)
library(rCharts)
library(boot) # load boot library

#We need to write a function to obtain mean
corboot <-function (x,indices) {
  cor(x[,1][indices],x[,2][indices])
}

shinyServer(function(input, output, session) {
  
  filedata <- reactive({
    infile <- input$file1
    if (is.null(infile)) {
      # User has not uploaded a file yet
      return(NULL)
    }
    read.csv(infile$datapath, header=input$header,
            sep=input$sep, quote=input$quote)
  })
    
  output$plot1 <- renderPlot({  
    f <- filedata()
    
    if(!is.null(f)) {
      ggplot(f, aes_string(x=names(f)[1],y=names(f)[2])) + geom_point(color="red") +
        geom_smooth(method = "lm", se = TRUE)  #add regression line
    }

  })
  
  output$correlationBox <- renderValueBox({
    f <- filedata()
    
      if(!is.null(f)) {
        correl <- cor(f[,1],f[,2])
        correl <- format(round(correl, 2), nsmall = 2)
        valueBox(
          paste0(correl, ""), "Correlation",
          color = "navy"
        )
      }
      else {
        valueBox(
          "", "Correlation Value", color = "navy"
        )
      }
  })
    
  output$CI <- renderValueBox({
    f <- filedata()
    
    if(!is.null(f)) {
      bootres<-boot(data=f,statistic=corboot,R=1000)
      a <- boot.ci(bootres, type="perc")
      lower_ci <- format(round(a$percent[4], 2), nsmall = 2)
      upper_ci <- format(round(a$percent[5], 2), nsmall = 2)
      ci <- paste(lower_ci," to ",upper_ci)
      
      valueBox(
        paste0(ci), "Confidence Interval - for Correlation",
        color = "navy"
      )
    }
    else {
      valueBox(
        "", "Confidence Interval", color = "navy"
      )
    }
  })
  
  output$CIGraph <- renderPlot({
    f <- filedata()
    
    if(!is.null(f)) {
      bootres<-boot(data=f,statistic=corboot,R=2000)
      plot(bootres)
    }
  })
 
  

})