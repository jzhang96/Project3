library(DT)
library(shiny)
library(shinydashboard)
library(shinycssloaders)

bike = read.csv("C:/Users/LAILA/Desktop/project3/SeoulBikeData.csv")
colnames(bike) <- c("Date","Rented_Bike_count", "Hour", "Temperature", "Humidity",
                    "Windspeed", "Visibility", "Dew_point_temperature",
                    "Solar_radiation", "Rainfall", "Snowfall", "Seasons", "Holiday",
                    "Functional_Day")

ui <- fluidPage(
  titlePanel("Seoul Bike Sharing Demand"),
  
  navlistPanel(
    tabPanel(
      h4("About"),
      mainPanel(
        h5("This app is for you to explore the", a(href = "https://archive.ics.uci.edu/ml/datasets/Seoul+Bike+Sharing+Demand", target = "_blank", "Seoul Bike Sharing Demand dataset"), "- originally from the UCI machine learninng repository"),
        h5("The dataset contains count of public bikes rented at each hour in Seoul Bike haring System with the corresponding Weather data and Holidays information"),
        h5("There are another three pages."), 
        h5("In the", strong("Data Exploration"), "page, you can do some numerical and graphical summaries about the dataset."),
        h5("In the", strong("Modeling info"), "page, you can find the detailed information for three models."),
        h5("In the", strong("Modeling Fitting"), "page, you can fit these three models"),
        h5("In the", strong("Prediction"), "page, you can do the prediction base on one of the three models"),
        h5("In the", strong("Data"), "page, you can check, subset and download the data."),
        tags$img(src='bike.png', width='300px',height='200px')
      )),
    tabPanel(
      h4("Data Exploration"),
      h4("You can create a few bar plots using radio buttons below."),
      radioButtons(inputId = "plot",
                   label = h5(strong("Select the Plot Type")),
                   choices = c("Seasons", "Holiday", 
                               "Functional_Day"),
                   selected = "Seasons"),
      br(),
      h4("You can find the", strong("basic numeric summarise"), "for all numeric variables below:"),
      selectInput(inputId =  "var",
                  label =  h5(strong("Varibles to Summarize")),
                  choices = c("Rented_Bike_count", "Hour", 
                              "Temperature", "Humidity",
                              "Windspeed", "Visibility", 
                              "Dew_point_temperature",
                              "Solar_radiation", 
                              "Rainfall", "Snowfall" ),
                  selected = "Rented_Bike_count"),
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
    tabPanel(
      h4("Modeling Info"),
      strong(h4("Multiple Linear Regression Model")),
      h5("Multiple linear regression is a regression model that estimates the relationship between a quantitative dependent variable and two or more independent variables using a straight line."),
      withMathJax(),
      helpText('The example equation for the Multiple Linear Regression model is
               $$Y_i = \\beta_0\\ + \\beta_1X_{1i}\\ + \\beta_2X_{2i}\\ + \\beta_3X_{1i}^2\\ + \\beta_4X_{2i}^2\\ + \\beta_5X_{1i}X_{2i}\\ + E_i$$'),
      helpText('Compare with the simple linear Regression, Multiplt liner regression can have more than one independent variables. And despite the 
               quadratic term \\(\\beta_3X_{1i}^2\\), we can also include the interaction term \\(\\beta_5X_{1i}X_{2i}\\) in the model.'),
      strong("Pros"),
      h5("Multiple linear regression allows the investigator to account for all of these potentially important factors in one model. The advantages of this approach are that this may lead to a more accurate and precise understanding of the association of each individual factor with the outcome."),
      strong("Cons"),
      h5("The assumption of linearity between the dependent variable and the independent variables is the main disadvantage since we may falsely concluding that a correlation is a causation"),
      br(),
      strong(h4("Classification Trees Model")),
      h5("A classification tree is a structural mapping of binary decisions that lead to a decision about the class (interpretation) of an object "),
      h5("The method of this model is Split up predictor space into regions, different predictions for each regioni. For a given region, usually use most prevalent class as prediction"),
      strong("Pros"),
      h5("This model is Easy to read and interpret and less data cleaning required."),
      strong("Cons"),
      h5("This model has a unstable nature compare to other decision predictors and less effective in predicting the outcome of continuous variable"),
      br(),
      strong(h4("Random Forest Model")),
      h5("Random forest is a type of supervised learning algorithm that uses ensemble methods (bagging) to solve both regression and classification problems. The algorithm operates by constructing a multitude of decision trees at training time and outputting the mean/mode of prediction of the individual trees."),
      h5("By randomly selecting a subset of predictors, a good predictor or two won't
dominate the tree fits"),
      helpText("Usually use \\(m = \\sqrt{p}\\) or \\(m = \\frac{p}{3}\\) randomly selected
predictors"),
      strong("Pros"),
      h5("It can robust to outliers, works well with non-linear data, lower risk of overfitting,
      runs efficiently on a large dataset and better accuracy than other classification algorithms."),
      strong("Cons"),
      h5("It can be quite large, thus making pruning necessary, can't guarantee optimal trees,
      it gives low prediction accuracy for a dataset as compared to other machine learning algorithms,
      and calculations can become complex when there are many class variables.")
    ),
    tabPanel(
      h4("Model Fitting & Prediction"),
      box(
        selectInput(
          "SelectX",
          label = "Select variables:",
          choices = names(bike),
          multiple = TRUE,
          selected = names(bike)
        ),
        solidHeader = TRUE,
        width = "3",
        status = "primary",
        title = "X variable"
      ),
      box(
        selectInput("SelectY", label = "Select variable to predict:", choices = c("Rented_Bike_count", "Hour", "Temperature", "Humidity",
                                                                                  "Windspeed", "Visibility", "Dew_point_temperature",
                                                                                  "Solar_radiation", "Rainfall", "Snowfall")),
        solidHeader = TRUE,
        width = "3",
        status = "primary",
        title = "Y variable"
      ),
      dashboardSidebar(
        sliderInput(
          "Slider1",
          label = h3("Train/Test Split %"),
          min = 0,
          max = 100,
          value = 75
        ),
        textOutput("cntTrain"),
        textOutput("cntTest")
      ),
      tabBox(
        id = "tabset1",
        height = "1000px",
        width = 12,
        tabPanel(
          "Model",
          box(
            withSpinner(verbatimTextOutput("Model")),
            width = 6,
            title = "Model Summary"
          )
        ),
        tabPanel(
          "Prediction",
          box(withSpinner(plotOutput("Prediction")), width = 6, title = "Best Fit Line"),
          box(withSpinner(plotOutput("residualPlots")), width = 6, title = "Diagnostic Plots")
        ))),
    tabPanel(
      h4("Data"),
      DT::dataTableOutput("dt"),
      
      p("Notice that the 'rows_all' attribute grabs the row indices of the data."),
      verbatimTextOutput("filtered_row"),
      
      
      downloadButton(outputId = "download_filtered",
                     label = "Download Filtered Data")
    )
  )
)

