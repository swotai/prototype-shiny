#Library
library("shiny")

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Test"),
  
  sidebarPanel(
    numericInput("value", "Enter Value:", 10),
    p('if y < 5, then minus input value, else add'),
    sliderInput('dVal', 'D value', min=20, max=40, value=20),
    textInput('testAdd', 'Value to add to lcost', value=10),
    uiOutput('Rstb_input_cost'),
    actionButton("reset_cost", "Reset cost")
  ),
  
  mainPanel(
    tableOutput("table"),
    tableOutput('table1')
  )
)
)