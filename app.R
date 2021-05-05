# Load packages ----
library(shiny)
library(maps)
library(mapproj)
library(dplyr)

# Load data ----
data <- read.csv("data/newtraindata01.csv")
dataNew <- read.csv("data/newtraindata.csv")
# Source helper functions -----
source("helpers.R")

# User interface ----
# Define UI for dataset viewer app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Shiny Text"),
  
  # Sidebar layout with a input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Selector for choosing dataset ----
      selectInput(inputId = "dataset",
                  label = "Choose a dataset:",
                  choices = c("data", "new data after processing")),
      
      # Input: Numeric entry for number of obs to view ----
      varSelectInput(inputId = "variable",
                   label = "Variable: ",
                   multiple = TRUE
                   )
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      # Output: HTML table with requested number of observations ----
      tableOutput("view")
      
    )
  )
)

# Define server logic to summarize and view selected dataset ----
server <- function(input, output) {
  
  # Return the requested dataset ----
  datasetInput <- reactive({
    switch(input$dataset,
           "data" = data,
           "new data after processing" = dataNew
           )
  })
  
  output$view <- renderTable({
    select(datasetInput, input$variable)
  })
  
}


# Run app ----
shinyApp(ui, server)
