#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  sliderInput(inputId='slider',
              label='I am a label',
              min=0,
              max=10,
              value=5 ) )
  
# Define server logic required to draw a histogram
server <- function(input, output, session) {

    }

# Run the application 
shinyApp(ui = ui, server = server)
