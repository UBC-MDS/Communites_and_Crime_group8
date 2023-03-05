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
library(ggcorrplot)

data <- read.csv("data/processed_communities.csv") |>
  select(c('area','type', 'state','latitude','longitude','violent_crime_rate','population', 
           'PopDens', 'racepctblack', 'racePctWhite', 'racePctAsian', 'racePctHisp', 
           'agePct12t29', 'agePct65up', 'medIncome', 'NumStreet', 'PctUnemployed'))

# Reload when saving the app
options(shiny.autoreload = TRUE)

my_theme <- bs_theme(bootswatch = "darkly",
                     base_font = font_google("Righteous"))

ui <- navbarPage('Crime Rate Finder App',
                 theme = my_theme,
                 tabPanel('Data Exploration',
                          tags$style(type = "text/css", "#map {height: calc(90vh - 80px) !important;}"),
                          sidebarLayout(column(3,selectInput(inputId = 'state',
                                                             label = 'Select State:',
                                                             choices = c('All',sort(unique(data$state))),
                                                             selected = 'All'),
                                               selectInput(inputId = 'city',
                                                           label = 'Select Community:',
                                                           choices = c())),
                                        column(9, leaflet::leafletOutput(outputId = 'map')))
                          
                 ),
                 tabPanel('Correlation',
                          sidebarLayout(
                            sidebarPanel(
                              selectInput(inputId = 'corr_plot',
                                          label = 'Select State:',
                                          choices = unique(data$state),
                                          selected = 'Alabama')
                            ),
                            mainPanel(
                              tabsetPanel(
                                tabPanel('Correlation by State',
                                         plotlyOutput(outputId = 'corrplot')
                                )
                              )))),
                 
                 tabPanel('Scatter',
                          sidebarLayout(
                            sidebarPanel(
                              selectInput(inputId = 'state_plot',
                                          label = 'Select State:',
                                          choices = unique(data$state),
                                          selected = 'Alabama'),
                              selectInput(inputId = 'var',
                                          label = 'Select Variable:',
                                          choices = c(colnames(data)[-(1:6)]),
                                          selected = 'population')
                            ),
                            mainPanel(
                              tabsetPanel(
                                tabPanel('Scatterplot',
                                         plotlyOutput(outputId = 'lineplot')
                                ),
                                tabPanel('Communities in the State',
                                         DT::DTOutput(outputId = 'table'))
                              )
                            )
                          ))

)
server <- function(input, output, session) {
  
  thematic_shiny(font = "auto")
  ggplot2::theme_set(ggplot2::theme_minimal())
  
  ##CORRELATION PLOT
  output$corrplot <- plotly::renderPlotly({ 
    filtered_data_corr <- data |> 
      dplyr::filter(state == input$corr_plot) |> 
      dplyr::select(-c('area','type', 'state','latitude','longitude')) |> 
      tidyr::drop_na()
    
    corr <- round(cor(filtered_data_corr), 1)
    
    plotly::ggplotly(
      ggcorrplot::ggcorrplot(corr, outline.col = "white",ggtheme = ggplot2::theme_gray, 
                             p.mat = NULL, insig = c("pch", "blank"), pch = 1, 
                             pch.col = "black", pch.cex =1,
                             tl.cex = 14) +
        ggplot2::theme(axis.text.x = element_text(margin=margin(-2,0,0,0), size = 8),
                       axis.text.y = element_text(margin=margin(0,-2,0,0), size = 8),
                       panel.grid.minor = element_line(size=10)) + 
        ggplot2::geom_tile(height=0.8, width=0.8)
      )
    
  })
  
  ## LINEPLOT
  
  observeEvent(input$state, {
    if (input$state == 'All'){
      citiesToShow = data %>% dplyr::pull(area)
    }else{
      #Filter countries based on current continent selection
      citiesToShow = data %>% 
        dplyr::filter(state %in% input$state) %>% dplyr::pull(area)
    }
    
    print(input$state)
    print(citiesToShow)
    
    #Update the actual input
    updateSelectInput(session, "city", choices = c('All',sort(citiesToShow)), 
                      selected = 'All')
    
  })
  filtered_data <-reactive({
    print(input$state)
    if (input$state == 'All'){
      data
    }else {
      if (input$city == 'All'){
        data |>
          dplyr::filter(state == input$state)
      }else{
        data |>
          dplyr::filter(state == input$state) |>
          dplyr::filter(area == input$city)}
    }
  })
  
  
  filtered_data_plot <-reactive({
    
    data |>
      dplyr::filter(state == input$state_plot)
    
  })
  
  output$lineplot <- plotly::renderPlotly({ 
    
    thematic_on(font = "Righteous")
  
    plotly::ggplotly(
      filtered_data_plot() |>
        ggplot2::ggplot(aes(x = .data[[input$var]],
                            y = violent_crime_rate)) +
        ggplot2::geom_point(alpha = 0.5) +
        geom_smooth(method = "lm") +
        ggplot2::scale_color_brewer(palette = "Set2") +
        ggplot2::labs(title = paste(input$var, 'vs. Crime Rate in', input$state_plot),
                      x = input$var,
                      y = 'Crime Rate') +
        ggplot2::theme(plot.title = element_text(hjust = 0.5))
    )
  })
  
  ## DT TABLE
  output$table <-  renderDT({
    
    brks <- quantile(data$testrun, probs = seq(.05, .95, .01), na.rm = TRUE) 
    clrs <- round(seq(150, 40, length.out = length(brks) + 1), 0) %>%
      {paste0("rgb(150,", ., ",", ., ")")}
    
    filtered_data_table <- filtered_data_plot()|>
      select(c('area','type',input$var,'violent_crime_rate'))

    datatable(filtered_data_table,
              caption = 'Table: Observations by Community ',
              extensions = 'Scroller',
              options=list(deferRender = TRUE,
                           scrollY = 200,
                           scroller = TRUE))  %>%
      formatStyle(colnames(filtered_data_table), 
                  color = 'black')
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
      leaflet::addProviderTiles(providers$CartoDB.Positron) %>% addTiles() %>% addMarkers(
        
        popup = paste(filtered_data()$area,
                      "in",
                      filtered_data()$state,
                      'has crime rate of',
                      filtered_data()$violent_crime_rate),
        clusterOptions = markerClusterOptions()
      )
  })
}

shinyApp(ui, server)