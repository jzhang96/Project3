library(DT)
library(shiny)
library(dplyr)
library(ggplot2)
shinyServer(function(input, output, session) {
  bike = read.csv("C:/Users/LAILA/Desktop/project3/SeoulBikeData.csv")
  colnames(bike) <- c("Date","Rented Bike count", "Hour", "Temperature", "Humidity",
                      "Windspeed", "Visibility", "Dew point",
                      "Solar radiation", "Rainfall", "Snowfall", "Seasons", "Holiday",
                      "Functional Day")
  bike$Seasons <- as.factor(bike$Seasons)
  var <-reactive({
    value <- input$var
  })
  numdata <- reactive({
    bike[, c("Date","Seasons", "Holiday",
             "Functional Day", var()),
         drop = FALSE]
  })
  output$table <- renderDataTable({
    value <- numdata()
    tab <- aggregate(value[[var()]] ~ Date,
                     data = value, FUN = summary)
    tab <- data.frame(location=tab[[1]], tab[[2]])
    tab[,2:7] <- round(tab[,3], digits = input$rounding)
    names(tab)[1] <- "Date"
    names(tab)[2] <- paste("Summary", var())
    names(tab)[3] <- paste("First Quantile", var())
    names(tab)[4] <- paste("Median", var())
    names(tab)[5] <- paste("Average", var())
    names(tab)[6] <- paste("Third quantile", var())
    names(tab)[7] <- paste("Maximum", var())
    print(tab)
  })
  output$distPlot <- renderPlot({
    value <- numdata()
    if (input$plot == 'Seasons'){
      ggplot(value, aes(x = Seasons)) +
        geom_bar()
    } 
    else if (input$plot == 'Holiday'){
      ggplot(value, aes(x = Holiday)) +
        geom_bar()
    }
    else{
      ggplot(value, aes(x = `Functional Day`)) +
        geom_bar() 
    }
  })
  
  output$dt <- 
    DT::renderDataTable(
      datatable(bike,
                filter = "top"),
      server = FALSE
    )
  
  output$filtered_row <- 
    renderPrint({
      input[["dt_rows_all"]]
    })
  
  output$download_filtered <- 
    downloadHandler(
      filename = "Filtered Data.csv",
      content = function(file){
        write.csv(bike[input[["dt_rows_all"]], ],
                  file)
      }
    )
})