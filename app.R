# Load packages ----
library(shiny)
library(maps)
library(mapproj)
library(dplyr)

# Load data ----
data <- read.csv("data/newtraindata01.csv")
dataNew <- read.csv("data/newtraindata.csv")

# User interface ----
# Define UI for dataset viewer app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Dataset"),
  
  # Sidebar layout with a input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Selector for choosing dataset ----
      selectInput(inputId = "dataset",
                  label = "Choose a dataset:",
                  choices = c("data", "new data after processing")),
      
      # Input: Numeric entry for number of obs to view ----
      selectInput(inputId = "variable",
                   label = "Variable: ",
                   multiple = TRUE,
                   choices = colnames(data),
                   selected = colnames(data)
                   ),
      
      numericInput(inputId = "obs",
                   label = "Number of observations to view (Maximum to 19158):",
                   value = 10,
                   max = 19158)
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
  # Input: Numeric entry for number of obs to view ----
  output$view <- renderTable({
    head(select(datasetInput(), input$variable), n = input$obs)
  })
  
}


# Run app ----
shinyApp(ui, server)

