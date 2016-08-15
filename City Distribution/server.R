# Set working directory
setwd("D:/Mapping/Prototype/")
# Current directory: setwd("D:/Mapping/Prototype/Maps")

# Load shiny library
library(shiny)
library(ggplot2)

shinyServer(
  function(input,output) {
    mydata <- function(){
      distroFile <- paste('CityDistro/ProtoCensus-e', input$aVal,'_', input$bVal,
                          '-p', input$cVal,'_', input$dVal,'.csv', sep='')
      datafile <- read.csv(file=distroFile, head=TRUE, sep=",")[,c("lon","lat","liv_pop", "liv_emp")]
      return(datafile)
    }
    
    output$resetable_input <- renderUI({
      times <- input$reset_input
      div(id=letters[(times %% length(letters)) + 1],
          sliderInput('aVal', 'a', min=1, max=25, value=10),
          sliderInput('bVal', 'b', min=10, max=50, value=10),
          sliderInput('cVal', 'a', min=1, max=25, value=10),
          sliderInput('dVal', 'd', min=10, max=50, value=10)
      )
    })
    
    #plot
    output$popplot <- renderPlot({
      ggplot(data=mydata(), aes(x=lon, y=lat, fill=liv_pop)) + 
        geom_tile()
    })
    output$empplot <- renderPlot({
      ggplot(data=mydata(), aes(x=lon, y=lat, fill=liv_emp)) + 
        geom_tile()
    })
  }
)
