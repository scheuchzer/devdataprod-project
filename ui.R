library(shiny)
library(markdown)

shinyUI(pageWithSidebar(
  headerPanel(title='Developing Data Products', windowTitle='Movie information and user ratings from IMDB.com'),
  sidebarPanel(
    h2('Movie information and user ratings from IMDB.com'),
    p('This page provides information about movie details like rating or budget.'),
    p('You\'ll get a distribution for the choosen variable of interest as well as a top 5 list of the \'winning\' movies'),
    h3('Your Selection'),
    htmlOutput("selectUI"),
    includeMarkdown("data.md"),
    includeMarkdown("author.md")
),
  mainPanel(
    htmlOutput('hist'),
    plotOutput('moviesPlot'),
    htmlOutput('top5Heading'),
    dataTableOutput('top5')
    
  )
))