require(shiny)
require(ggplot2)

shinyUI(fluidPage(
  title = "Prototype City transit system welfare analysis",
  
  fluidRow(
    column(4,
           h3('MC vs MB', align = "center"),
           plotOutput('MBMC')
    ),
    column(4, 
           h3('Absolute cost vs benefit', align = "center"),
           plotOutput('absBC')
    ),
    column(4, 
           h3('Data Table', align = "center"),
           tableOutput('datatable')
    )
  ),

  fluidRow(
    column(9,
           p('Graph recalculates automatically when parameters change.'),
           p('Dotted line is benefit')
    ),
    column(3,
           p('Showing the first 12 rows')
           )
  ),
  
  hr(),
  
  fluidRow(
    column(4,
           h3('City Distribution'),
           p('The prototype city population and employment density is controlled by four parameters.'),
           em('Parameter a and b controls the employment concentration in the center and subcenter; similarly, c and d are the same for population'),
           p('Please reset before switching parameters of interest.'),
           uiOutput('Rstb_input_abcd'),
           actionButton("reset_abcd", "Reset distribution")
    ),
    column(4,
           h3('Cost Function'),
           p('The following parameters controls the cost function:'),
           uiOutput('Rstb_input_cost'),
           actionButton("reset_cost", "Reset cost")
    ),
    column(4,
           h4('Notes:'),
           p("Note that when a, b, c, or d go pass certain value (e.g. a or c pass 20,
             b or d pass 36) the benefit curve would look squiggly and then seem to bounce
             back to the baseline for some unknown reason"),
           p("Value of cost and benefit rescaled to million $"),           
           p("Population density, employment density, and rail length has been logged
             and rescaled to zero mean following 'B2-ConstCost_v4_Gabriel'.  The normalizations are:
             	local llength =  2.0214461
	            local lpopdens =  9.0395026
	            local lempdens =  9.2180281
	            local ltotaldens =  9.9639803"),
           p("The reaction to concentration looks very good if speed coefficient = 0.06")
    )
  ),
  br()
))
