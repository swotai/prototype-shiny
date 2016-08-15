library(shiny)

shinyUI(pageWithSidebar(
  # Application title
  headerPanel("Prototype City population and employment density heatmap"),
  
  # control panel
  sidebarPanel(
    h1('Parameters'),
    p('The prototype city population and employment density is controlled
       by four parameters.  Parameter a and b controls the employment 
      concentration in the center and subcenter; similarly, c and d
      are the same for population'),
    p('The baseline case is when all parameters has a value of 10.  
      When changing one parementers all other values must be reset to 10.'),
    uiOutput('resetable_input'),
    actionButton("reset_input", "Reset")
  ),
  mainPanel(
    h2('Employment Density'),
    plotOutput("empplot"),
    h2('Population Density'),
    plotOutput("popplot")
  )
))
