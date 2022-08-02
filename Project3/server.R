library(DT)
library(shiny)
library(dplyr)
library(ggplot2)
shinyServer(function(input, output, session) {
  bike = read.csv("C:/Users/LAILA/Desktop/project3/SeoulBikeData.csv")
  colnames(bike) <- c("Date","Rented_Bike_count", "Hour", "Temperature", "Humidity",
                      "Windspeed", "Visibility", "Dew_point_temperature",
                      "Solar_radiation", "Rainfall", "Snowfall", "Seasons", "Holiday",
                      "Functional_Day")
  var <-reactive({
    value <- input$var
  })
  numdata <- reactive({
    bike[, c("Date","Seasons", "Holiday",
             "Functional_Day", var()),
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
      ggplot(value, aes(x = `Functional_Day`)) +
        geom_bar() 
    }
  })
  
  InputDataset <- reactive({
    bike
  })
  
  InputDataset_model <- reactive({
    if (is.null(input$SelectX)) {
      dt <- bike
    }
    else{
      dt <- bike[, c(input$SelectX)]
    }
    
  })
  
  splitSlider <- reactive({
    input$Slider1 / 100
  })
  
  set.seed(100)  # setting seed to reproduce results of random sampling
  trainingRowIndex <-
    reactive({
      sample(1:nrow(InputDataset_model()),
             splitSlider() * nrow(InputDataset_model()))
    })# row indices for training data
  
  trainingData <- reactive({
    tmptraindt <- InputDataset_model()
    tmptraindt[trainingRowIndex(), ]
  })
  
  testData <- reactive({
    tmptestdt <- InputDataset_model()
    tmptestdt[-trainingRowIndex(),]
  })
  
  output$cntTrain <-
    renderText(paste("Train Data:", NROW(trainingData()), "records"))
  output$cntTest <-
    renderText(paste("Test Data:", NROW(testData()), "records"))
  
  output$Data <- renderDT(InputDataset())
  
  f <- reactive({
    as.formula(paste(input$SelectY, "~."))
  })
  Linear_Model <- reactive({
    lm(f(), data = trainingData())
  })
  output$Model <- renderPrint(summary(Linear_Model()))
  output$Model_new <-
    renderPrint(
      stargazer(
        Linear_Model(),
        type = "text",
        title = "Model Results",
        digits = 1,
        out = "table1.txt"
      )
    )
  
  price_predict <- reactive({
    predict(Linear_Model(), testData())
  })
  
  tmp <- reactive({
    tmp1 <- testData()
    tmp1[, c(input$SelectY)]
  })
  
  actuals_preds <-
    reactive({
      data.frame(cbind(actuals = tmp(), predicted = price_predict()))
    })
  
  Fit <-
    reactive({
      (
        plot(
          actuals_preds()$actuals,
          actuals_preds()$predicted,
          pch = 16,
          cex = 1.3,
          col = "blue",
          main = "Best Fit Line",
          xlab = "Actual",
          ylab = "Predicted"
        )
      )
    })
  
  output$Prediction <- renderPlot(Fit())
  
  output$residualPlots <- renderPlot({
    par(mfrow = c(2, 2)) # Change the panel layout to 2 x 2
    plot(Linear_Model())
    par(mfrow = c(1, 1)) # Change back to 1 x 1
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