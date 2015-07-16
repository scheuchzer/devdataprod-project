library(shiny)
library(ggplot2)

data(movies)

movies$budget <- movies$budget / 1000000
movies$length <- movies$length / 60

columnMapping <- list(
  'Rating' = 'rating',
  'Budget in million dollars' = 'budget',
  'Year' = 'year',
  'Length in hours' = 'length',
  'Votes' = 'votes'
)

shinyServer(
  function(input, output) {
    output$selectUI <- renderUI({ 
      selectInput('selectedColumn', 'Variable of interrest', columnMapping)
    })
    
    output$moviesPlot <- renderPlot({
      selectedColumn <- input$selectedColumn
      xlab <- names(columnMapping)[which(columnMapping==selectedColumn)]
      newData <- movies[!is.na(movies[selectedColumn]),]

      dataRange <- range(newData[selectedColumn]);
      binwidth <- (dataRange[2]-dataRange[1])/20
      m <- ggplot(newData, aes_string(x=selectedColumn))
      m <- m + geom_histogram(binwidth = binwidth, aes(fill = ..count..))
      #m <- m + scale_fill_gradient("Count", low = "red",high = "green")
      m <- m + xlab(xlab) + ylab('Number of films') + stat_bin(binwidth = binwidth, geom="text", aes(label=..count.., vjust=0, angle = 90))
      print(m)
      
    })
    
    output$top5 <- renderDataTable({
      selectedColumn <- input$selectedColumn
      newData <- movies[!is.na(movies[selectedColumn]), 1:6]
      newData <- newData[order(newData[selectedColumn], decreasing = TRUE),]
      return(newData)
    }, 
    options = list(
      pageLength = 5,
      columnDefs = list(list(targets = c(3:6)-1, searchable = FALSE)),
      lengthChange = FALSE,
      info = FALSE,
      pagingType = 'simple_numbers',
      searching = FALSE
    ))
    
    output$top5Heading <- renderUI({ 
      selectedColumn <- input$selectedColumn
      heading <- sprintf('Top movies when we have a look at the %s', selectedColumn)
      h3(heading)
      
    })
    
    output$hist <- renderUI({ 
      selectedColumn <- input$selectedColumn
      heading <- sprintf('Distribution when it comes to %s', selectedColumn)
      h3(heading)
      
    })
  }
)