#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(bslib)
library(leaflet)
library(DT)
library(ggplot2)
library(plotly)
library(thematic)
library(forcats)

data <- read.csv("data/processed_communities.csv") |>
  select(c('area','type', 'state','latitude','longitude','violent_crime_rate','population', 
           'PopDens', 'racepctblack', 'racePctWhite', 'racePctAsian', 'racePctHisp', 
           'agePct12t29', 'agePct65up', 'medIncome', 'NumStreet', 'PctUnemployed', 
           'LemasSwornFT', 'LemasSwFTFieldOps', 'LemasPctPolicOnPatr', 'LemasTotalReq', 
           'PolicCars', 'PolicOperBudg', 'NumKindsDrugsSeiz'))

# Reload when saving the app
options(shiny.autoreload = TRUE)

ui <- navbarPage('Crime Rate Finder App',
                 theme = bs_theme(bootswatch = 'lux'),
                 tabPanel('Data Exploration',
                          sidebarLayout(column(3,selectInput(inputId = 'state',
                                               label = 'Select State:',
                                               choices = unique(data$state),
                                               selected = 'California'),
                                   selectInput(inputId = 'type',
                                               label = 'Select Community Type:',
                                               choices = unique(data$type),
                                               selected = 'city')),
                          column(9, leaflet::leafletOutput(outputId = 'map')))
                          
                 ),
                 tabPanel('Correlation',
                          sidebarLayout(
                            sidebarPanel(
                              selectInput(inputId = 'state_plot',
                                          label = 'Select State:',
                                          choices = unique(data$state),
                                          selected = 'California')
                            ),
                            mainPanel(
                              tabsetPanel(
                                tabPanel('Population Correlation',
                                         plotlyOutput(outputId = 'lineplot')
                                ),
                                tabPanel('Communities in the State',
                                         DT::DTOutput(outputId = 'table'))
                              )
                            )
                          ))
                 
)

server <- function(input, output, session) {
  
  ## LINEPLOT
  
  
  filtered_data <-reactive({

    data |>
      dplyr::filter(state == input$state) |>
      dplyr::filter(type == input$type)

  })
  
  filtered_data_plot <-reactive({
    
    data |>
      dplyr::filter(state == input$state_plot)
    
  })
  
  output$lineplot <- plotly::renderPlotly({ 
    
    thematic::thematic_shiny()
    
    plotly::ggplotly(
      filtered_data_plot() |>
        ggplot2::ggplot(aes(x = population,
                            y = violent_crime_rate,)) +
        ggplot2::geom_point(alpha = 0.5) +
        geom_smooth(method = "lm") +
        ggplot2::scale_color_brewer(palette = "Set2") +
        ggplot2::labs(title = paste('Population vs. Crime Rate in',input$state_plot),
                      x = 'Population',
                      y = 'Crime Rate') 
    )
  })
  
  ## DT TABLE
  
  output$table <-  renderDT({
    
    # read the documentation for the arguments  
    datatable(filtered_data_plot()|>
                select(c('area','type','population','violent_crime_rate')),
              caption = 'Table: Observations by location.',
              extensions = 'Scroller',
              options=list(deferRender = TRUE,
                           scrollY = 200,
                           scroller = TRUE))
    
  })
  
  
  ## LEAFLET MAP
  
  output$map <- leaflet::renderLeaflet({
    
    # print(input$daterange)
    # str(input$daterange)
    # print(input$table_rows_selected)
    
    ## color palette
    pal <- leaflet::colorNumeric('viridis', 
                                 domain = data$violent_crime_rate)
    
    filtered_data() |> 
      leaflet::leaflet() |> 
      leaflet::addProviderTiles(providers$CartoDB.Positron) |> 
      leaflet::addCircleMarkers(
        lat = ~latitude,
        lng = ~longitude,
        radius = ~violent_crime_rate*20,
        popup = paste(filtered_data()$area,
                      "in",
                      filtered_data()$state,
                      'has crime rate of',
                      filtered_data()$violent_crime_rate),
        color = ~pal(violent_crime_rate),
        options = popupOptions(closeButton = FALSE))
  })
}

shinyApp(ui, server)