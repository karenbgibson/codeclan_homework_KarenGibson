library(shiny)
library(tidyverse)
library(bslib)

nyc_dogs <- CodeClanData::nyc_dogs

breed_choice <- nyc_dogs %>% 
  distinct(breed) %>% 
  pull()

gender_choice <- nyc_dogs %>% 
  distinct(gender) %>% 
  pull()

ui <- fluidPage(
  
  titlePanel(tags$h4(tags$b("NYC Dog Breeds by Borough"))),
  theme = bs_theme(bootswatch = "lux"),
  fluidRow(    
    column(
      width = 12,
      plotOutput("dogs_plot")
    )
  ),
  tags$br(),
  tags$br(),
  fluidRow(
    column(
      4,
      offset = 4,
      selectInput(
        inputId = "breed_choice", 
        label = (tags$i("Dog breed:")),
        choices = breed_choice
      )
    )
  ),
  tags$br(),
  tags$br(),
  fluidRow(
    column(
    4,
      offset = 4,
      selectInput(
        inputId = "gender_choice", 
        label = (tags$i("Gender:")),
        choices = gender_choice
      )
    )
  )
)

server <- function(input, output, session) {
  
  output$dogs_plot <- renderPlot(expr = {
    nyc_dogs %>% 
      filter(breed == input$breed_choice,
             gender == input$gender_choice) %>%
      ggplot() +
      aes(x = borough,
          fill = borough) +
      geom_bar() +
      labs(x = "",
           y = "") +
      theme_minimal() +
      theme(legend.position = "none")
}
)
}

shinyApp(ui, server)