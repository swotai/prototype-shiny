#Libraries
library(shiny)
require(readstata13)

#Load Data
mydata <- data.frame(cbind(x = 1, y = 1:10))
data1 <- read.dta13("testoutWelfareV.dta")

# Define server logic
shinyServer(function(input, output) {
  output$Rstb_input_cost <- renderUI({
    times1 <- input$reset_cost
    div(id=letters[(times1 %% length(letters)) + 1],
        textInput('b_s', label=p('Speed'),     value=0.0193),
        textInput('b_l', label=p('Length'),    value=-0.8113),
        textInput('b_p', label=p('Population'),value=0.5276),
        textInput('b_e', label=p('Employment'),value=0.1902),
        textInput('b_y', label=p('Year'),      value=0.0314),
        textInput('b_c', label=p('Constant'),  value=4.1784),
        h4('Constant terms'),
        textInput('c_l', label=p('Rail Length'),    value=54),
        textInput('c_y', label=p('Year since 2012'),value=0)
    )
  })
  
  newdata <- reactive({
    mydata$z[mydata$y >= 5] <- mydata$y[mydata$y >= 5] + input$value
    mydata$z[mydata$y < 5] <- mydata$y[mydata$y < 5] - input$value
    return(mydata)
  })
  
  plotdata <- reactive({
    thisdata <- subset(data1, a==10 & b==10 & c == 10 & d == input$dVal)[c('d','lcost','speed','lpopden','lempden','mb','mc')]
    value <- as.double(input$testAdd)
    b_speed  <- as.double(input$b_s)
    b_length <- as.double(input$b_l)
    b_pop    <- as.double(input$b_p)
    b_emp    <- as.double(input$b_e)
    b_year   <- as.double(input$b_y)
    b_cons   <- as.double(input$b_c)
    c_length <- as.double(input$c_l)
    c_year   <- as.double(input$c_y)
    
    costFunc <- function(s, l, p, e, y){
      lcost <- b_cons + b_speed*s + b_length*l + b_pop*p + b_emp*e + b_year*y
      cost  <- 1000000*exp(lcost)
      return(cost)
    }
    
    testFunc <- function(a,b,c){
      outvalue = a+b+c
      return(outvalue)
    }
    
    thisdata$cost2 <- apply(thisdata, 1, 
                             function(x) costFunc(x['speed'],c_length,x['lpopden'],x['lempden'],c_year))
    thisdata$mc1     <- append(diff(thisdata$cost2),NA,0)
    return(thisdata)
  })
  
  output$table <- renderTable({
    newdata()
  })
  output$table1 <- renderTable({
    plotdata()
  })
})
