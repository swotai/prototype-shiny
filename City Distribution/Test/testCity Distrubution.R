
distroFile <- paste('CityDistro/ProtoCensus-e', input$aVal,'_', input$bVal,
                    '-p', input$cVal,'_', input$dVal,'.csv', sep='')
datafile <- read.csv(file=distroFile, head=TRUE, sep=",")[,c("lon","lat","liv_pop", "liv_emp")]