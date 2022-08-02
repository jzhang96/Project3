# Project3
This app is for you to explore and fit model for the Seoul Bike Sharing Demand from the UCI machine learninng repository.
The dataset contains count of public bikes rented at each hour in Seoul Bike haring System with the corresponding Weather data and Holidays information.

# Packages
You will need `DT`, `shiny`, `shinydashboard`, `shinycssloaders`, `dplyr`, `ggplot2` packages.

# Install
```{r}
install.package(c("DT", "shiny", "shinydashboard", "shinycssloaders", "dplyr", "ggplot2"))
```

# Run App
```{r}
shiny::runGitHub(repo = "Project3", username = "jzhang96")
```