#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Import libraries
library(readr)
library(shiny)
library(bslib)
library(leaflet)
library(DT)
library(ggplot2)
library(plotly)
library(thematic)
library(ggcorrplot)

# Load data
data <- readr::read_csv("data/processed_communities.csv", 
                        col_types = cols_only(
                          area = col_character(),
                          type = col_character(),
                          state = col_character(),
                          latitude = col_double(),
                          longitude = col_double(),
                          violent_crime_rate = col_double(),
                          population = col_double(),
                          PopDens = col_double(),
                          racepctblack = col_double(),
                          racePctWhite = col_double(),
                          racePctAsian = col_double(),
                          racePctHisp = col_double(),
                          agePct12t29 = col_double(),
                          agePct65up = col_double(),
                          medIncome = col_double(),
                          NumStreet = col_double(),
                          PctUnemployed = col_double()
                        )) |>
  select(area, type, state, latitude, longitude, violent_crime_rate, 
         population, PopDens, racepctblack, racePctWhite, racePctAsian, 
         racePctHisp, agePct12t29, agePct65up, medIncome, NumStreet, 
         PctUnemployed)
names(data)[-(1:6)] <- c('Population', 
                        'Population Density', 
                        'Black Race Percentage', 
                        'White Rate Percentage', 
                        'Asian Race Percentage', 
                        'Hispanic Race Percentage',
                        'Age Range Percentage (12-29)', 
                        'Age Range Percentage (65+)', 
                        'Median Income', 
                        'Number of Streets',
                        'Unemployed Percentage')
names(data)[6] <- 'Violent Crime Rate'
# Reload when saving the app
options(shiny.autoreload = TRUE)

# Set theme and font style
my_theme <- bs_theme(bootswatch = "darkly",
                     base_font = font_google("Righteous"))

# Define UI
ui <- navbarPage('Crime Rate Finder App',
                 id = 'main_page', 
                 theme = my_theme,
                 
                 # First tab - Data Exploration
                 tabPanel('Data Exploration',
                          # Set height of map to 90% of viewport height minus 80px
                          tags$style(type = "text/css", "#map {height: calc(90vh - 80px) !important;}"),
                          sidebarLayout(
                            # Sidebar with state and community select inputs
                            column(3,
                                   selectInput(inputId = 'state',
                                               label = 'Select State:',
                                               choices = c('All', sort(unique(data$state))),
                                               selected = 'All',
                                               multiple = TRUE),
                                   selectInput(inputId = 'city',
                                               label = 'Select Community:',
                                               choices = c())
                            ),
                            # Main panel with leaflet map output
                            column(9,
                                   leaflet::leafletOutput(outputId = 'map'))
                          )
                 ),
                 
                 # Second tab - Correlation
                 tabPanel('Correlation',
                          sidebarLayout(
                            # Sidebar with state select input
                            sidebarPanel(
                              selectInput(inputId = 'corr_plot',
                                          label = 'Select State:',
                                          choices = unique(data$state),
                                          selected = 'Alabama')
                            ),
                            # Main panel with correlation plot output
                            mainPanel(
                              tabsetPanel(
                                tabPanel('Correlation by State',
                                         plotlyOutput(outputId = 'corrplot')
                                ),
                                
                                id = 'corr_panel'
                              )
                            )
                          )
                 ),
                 
                 # Third tab - Scatter
                 tabPanel('Scatter',
                          sidebarLayout(
                            # Sidebar with state and variable select inputs
                            sidebarPanel(
                              selectInput(inputId = 'state_plot',
                                          label = 'Select State:',
                                          choices = unique(data$state),
                                          selected = 'Alabama'),
                              selectInput(inputId = 'var',
                                          label = 'Select Variable:',
                                          choices = c(colnames(data)[-(1:6)]),
                                          selected = 'Population')
                            ),
                            # Main panel with catter plot and DT table outputs
                            mainPanel(
                              tabsetPanel(
                                id = 'scatter_panel',
                                tabPanel('Scatterplot',
                                         plotlyOutput(outputId = 'lineplot')
                                ),
                                tabPanel('Communities in the State',
                                         DT::DTOutput(outputId = 'table'),
                                         downloadButton("download", "Download .tsv"))
                              )
                            )
                          )
                 ),
                 
                 # Fourth Tab - More Information
                 tabPanel('More Information',
                          br(),
                          p('Thank you for using our app!'),
                          br(),
                          p('If you want to know more about our app, 
                            please visit our GitHub repository:'),
                          tags$a(href = 'https://github.com/UBC-MDS/Communites_and_Crime_group8', 
                                 'GitHub'),
                          br(),
                          br(),
                          p('You can find some useful links here:'),
                          tags$a(href = 'https://ucr.fbi.gov/crime-in-the-u.s', 
                                 'FBI Crime Report'),
                          br(),
                          tags$a(href = 'https://cde.ucr.cjis.gov/LATEST/webapp/#/pages/explorer/crime/crime-trend',
                                 'FBI Crime Data Explorer'),
                          br(),
                          tags$a(href = 'https://archive.ics.uci.edu/ml/datasets/communities+and+crime',
                                 'UCI Communities and Crime Data Set'),
                          br(),
                          tags$a(href = 'https://en.wikipedia.org/wiki/Crime_in_the_United_States',
                                 'Crime in the United States -- Wikipedia')
                 )
)

# Define the server function of the Shiny app.
# This function contains the server-side logic of the Shiny app, 
# which is responsible for rendering the UI and handling user input. 
# It takes three arguments: `input`, `output`, and `session`.
server <- function(input, output, session) {
  
  thematic_shiny(font = "auto")
  ggplot2::theme_set(ggplot2::theme_minimal())
  
  ## CORRELATION PLOT
  output$corrplot <- plotly::renderPlotly({
    # Filter the selected state, and remove unnecessary columns and NAs
    filtered_data_corr <- data |> 
      dplyr::filter(state == input$corr_plot) |> 
      dplyr::select(-c('area','type', 'state','latitude','longitude')) |> 
      tidyr::drop_na()
    
    # Compute the correlation matrix, and round it up to one decimal
    corr <- round(cor(filtered_data_corr), 1)
    
    # Create the correlation plot
    plotly::ggplotly(
      ggcorrplot::ggcorrplot(corr, 
                             outline.col = "white",
                             ggtheme = ggplot2::theme_gray, 
                             p.mat = NULL, 
                             insig = c("pch", "blank"), 
                             pch = 1, 
                             pch.col = "black", 
                             pch.cex =1,
                             tl.cex = 14) +
        # Customize the plot by changing the size and color of the axis text
        ggplot2::theme(axis.text.x = element_text(margin=margin(-2,0,0,0), size = 8),
                       axis.text.y = element_text(margin=margin(0,-2,0,0), size = 8),
                       panel.grid.minor = element_line(size=10)) + 
        # Add tiles to customize the plot
        ggplot2::geom_tile(height=0.8, width=0.8)
    )
    
  })
  
  ## LINE PLOT
  # This code generates a line plot displaying crime rates by community
  
  observeEvent(input$state, {
    
    if ("All" %in% input$state){
      citiesToShow = data %>% dplyr::pull(area)
    }else{
      # Filter countries based on current continent selection
      citiesToShow = data %>% 
        dplyr::filter(state %in% input$state) %>% dplyr::pull(area)
    }
    
    # Update the actual input
    updateSelectInput(session, "city", choices = c('All', sort(citiesToShow)), 
                      selected = 'All')
    
  })
  filtered_data <-reactive({
    temp <- data
    if ('All' %in% input$state){
      temp
    }else {
        temp <- data |>
          dplyr::filter(state %in% input$state) 
  }
  
  if ('All' %in% input$city){
    temp
  }else{data |>
      dplyr::filter(area %in% input$city)
  }})
  
  
  filtered_data_plot <-reactive({
    
    data |>
      dplyr::filter(state %in% input$state_plot)
    
  })
  
  output$lineplot <- plotly::renderPlotly({ 
    
    thematic_on(font = "Righteous")
    
    plotly::ggplotly(
      filtered_data_plot() |>
        ggplot2::ggplot(aes(x = .data[[input$var]],
                            y = `Violent Crime Rate`)) +
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
  # This code generates a table displaying crime rates by community
  
  output$table <-  renderDT({
    
    # Select columns to display
    filtered_data_table <- filtered_data_plot() |>
      select(c('area','type',input$var,`Violent Crime Rate`))
    
    # Render the table
    datatable(filtered_data_table,
              caption = 'Table: Observations by Community',
              extensions = 'Scroller',
              options=list(deferRender = TRUE,
                           scrollY = 200,
                           scroller = TRUE)) |>
      # Format column styles
      formatStyle(colnames(filtered_data_table), 
                  color = 'black')
  })
  
  # output for downloading filtered dataset
  output$download <- downloadHandler(
    filename = 'filtered_data.tsv',
    content = function(file) {
      write_tsv(filtered_data_plot(), file)
    }
  )
  ## LEAFLET MAP
  # This code generates a leaflet map displaying crime rates by community
  
  output$map <- leaflet::renderLeaflet({
    
    # Color palette
    pal <- leaflet::colorNumeric('viridis', 
                                 domain = data$`Violent Crime Rate`)
    
    # Add map tiles and markers
    filtered_data() |> 
      leaflet::leaflet() |> 
      addTiles() |>
      addMarkers(
        popup = paste(filtered_data()$area,
                      "in",
                      filtered_data()$state,
                      'has crime rate of',
                      filtered_data()$`Violent Crime Rate`),
        clusterOptions = markerClusterOptions()
      ) |>
      addTiles(group = "Neighbourhood") |>  
      addProviderTiles(providers$CartoDB.VoyagerLabelsUnder,
                       group = "Basemap") |> 
      addProviderTiles(providers$Esri.WorldImagery,
                       group = "Satellite") |>
      addLayersControl(
        baseGroups = c("Basemap","Neighbourhood", "Satellite"),
        options = layersControlOptions(collapsed = FALSE) )
    
  })
}

# Creates Shiny Aapp
shinyApp(ui, server)