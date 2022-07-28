library(shiny)
ui <- fluidPage(
  titlePanel("Seoul Bike Sharing Demand"),
  
  navlistPanel(
    tabPanel(
      h4("About"),
      h5("This app is for you to explore the", a(href = "https://archive.ics.uci.edu/ml/datasets/Seoul+Bike+Sharing+Demand", target = "_blank", "Seoul Bike Sharing Demand dataset"), "- originally from the UCI machine learninng repository"),
      h5("The dataset contains count of public bikes rented at each hour in Seoul Bike haring System with the corresponding Weather data and Holidays information"),
      h5("There are another three pages."), 
      h5("In the", strong("Data"), "Exploration page, you can do some numerical and graphical summaries about the dataset."),
      h5("In the", strong("Modeling"), "page, you can fit three model for the dataset and you will get detailed information about modeling in the Modeling page."),
      h5("In the", strong("Data"), "page, you can check, subset and download the data.")),
    
    tabPanel(
      h4("Data Exploration"),
      h4("You can create a few bar plots using radio buttons below."),
      radioButtons(inputId = "plot",
                   label = h5(strong("Select the Plot Type")),
                   choices = c("Seasons", "Holiday", 
                               "Functional Day"),
                   selected = "Seasons"),
      br(),
      h4("You can find the", strong("basic numeric summarise"), "for all numeric variables below:"),
      selectInput(inputId =  "var",
                  label =  h5(strong("Varibles to Summarize")),
                  choices = c("Rented Bike count", "Hour", 
                              "Temperature", "Humidity",
                              "Windspeed", "Visibility", 
                              "Dew point temperature",
                              "Solar radiation", 
                              "Rainfall", "Snowfall" ),
                  selected = "Rented Bike count"),
      numericInput(inputId = "rounding",
                   label =   h5(strong("Select the number of digits for rounding")),
                   value = 2,
                   min = 0,
                   max = 5,
                   step = 1),
      mainPanel(
        plotOutput("distPlot"),
        dataTableOutput("table")
      )),
    tabPanel("Modeling "),
    tabPanel("Data")
  ))