# Libraries
require(readstata13)
require(shiny)
require(ggplot2)

# Load Data
mydata <- read.dta13("outWelfareVis.dta")

# Define server
shinyServer(
  function(input,output) {
    output$Rstb_input_abcd <- renderUI({
      times <- input$reset_abcd
      div(id=letters[(times %% length(letters)) + 1],
          sliderInput('aVal', label=p('a: employment at center'), min=1, max=25, value=10),
          sliderInput('bVal', label=p('b: employment at subcenter'), min=10, max=50, value=10),
          sliderInput('cVal', label=p('c: population at center'), min=1, max=25, value=10),
          sliderInput('dVal', label=p('d: population at subcenter'), min=10, max=50, value=10)
      )
    })
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
    
    plotdata <- reactive({
      thisData <- subset(mydata, a==input$aVal & b==input$bVal & c == input$cVal & d == input$dVal)
      
      # Recalculate cost
      b_speed  <- as.double(input$b_s)
      b_length <- as.double(input$b_l)
      b_pop    <- as.double(input$b_p)
      b_emp    <- as.double(input$b_e)
      b_year   <- as.double(input$b_y)
      b_cons   <- as.double(input$b_c)
      c_length <- as.double(input$c_l)
      c_year   <- as.double(input$c_y)
      
      # Note: Gabriel's regression's yvar is lcostpermile = log(costpermile)
      costFunc <- function(s, l, p, e, y) {
        lcost <- b_cons + b_speed*s + b_length*l + b_pop*p + b_emp*e + b_year*y
        #cost  <- exp(lcost)
        return(lcost)
      }
      
      # estimate cost
      thisData$lcost  <- apply(thisData, 1, 
                               function(x) costFunc(x['speed'],x['llength'],x['lpopden'],x['lempden'],c_year))
      thisData$cost   <- exp(thisData$lcost)*thisData$length
      
      # Cost with O&M, lower and upper
      thisData$cost_L   <- thisData$cost + thisData$cost*.02/.04
      thisData$cost_U   <- thisData$cost + thisData$cost*.04/.04
      thisData$costpm   <- thisData$cost/thisData$length
      
      # benefits, upper and lowerbound
      thisData$lifetime_b_U <- thisData$lifetime_b_U/1000000
      thisData$lifetime_b_L <- thisData$lifetime_b_L/1000000
      
      # Recalculate MC and MB (upper and lower)
      thisData$mc_U  <- append(diff(thisData$cost_U),NA,0)
      thisData$mc_L  <- append(diff(thisData$cost_L),NA,0)
      thisData$mb_U  <- append(diff(thisData$lifetime_b_U),NA,0)
      thisData$mb_L  <- append(diff(thisData$lifetime_b_L),NA,0)
      
      return(thisData)
    })
    
    ymax <- reactive({
      max(plotdata()$mb, na.rm=T)
    })
    
    ymax1 <- reactive({
      max(plotdata()$lifetime_b, na.rm=T)
    })
    
    output$MBMC <- renderPlot({
      # q <- ggplot(data=plotdata(), aes_string(x="speed")) +
      #   geom_line(aes_string(y="mb")) +
      #   geom_point(aes_string(y="mb")) +
      #   geom_line(aes_string(y="mc")) +
      #   scale_color_manual("",
      #                      values=c("blue","red")) +
      #   coord_cartesian(xlim=c(10,50), ylim=c(0,ymax())) +
      #   labs(title="Marginal Cost vs Marginal Benefits", 
      #        x="Transit Speed (mph)",
      #        y="MC, MB in Million $")
      p <- ggplot(data=plotdata(), aes_string(x="speed")) +
          geom_line(aes_string(y="mc_U")) +
          geom_line(aes_string(y="mc_L")) +
          geom_ribbon(aes_string(ymax="mb_U",ymin="mb_L"), fill="blue", colour="black", alpha=0.25) +
          geom_ribbon(aes_string(ymax="mc_U",ymin="mc_L"), fill="red" , colour="black", alpha=0.25)
      print(p)
    })#, width=800)
    
    output$absBC <- renderPlot({
      p <- ggplot(data=plotdata(), aes_string(x="speed")) +
        geom_line(aes_string(y="lifetime_b")) +
        geom_point(aes_string(y="lifetime_b")) +
        geom_line(aes_string(y="cost")) +
        scale_color_manual("",
                           values=c("blue","red")) +
        coord_cartesian(xlim=c(10,50), ylim=c(0,ymax1())) +
        labs(title="Cost vs Benefits", 
             x="Transit Speed (mph)",
             y="Cost, Benefit in Million $")
      print(p)
    })#, width=800) << comment out this line so that graph can have dynamic shape
    
    output$datatable <- renderTable({
      plotdata()[c('speed','llength','lpopden','lempden','mc_U','mc_L','cost')][1:12,]
    })
  }
)
