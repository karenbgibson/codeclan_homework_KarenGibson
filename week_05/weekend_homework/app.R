library(shiny)
library(tidyverse)
library(bslib)
library(plotly)

game_sales <- CodeClanData::game_sales

## finding the average rating of a game genre based on both the user score and 
## critic score

avg_ratings <- game_sales %>% 
  group_by(genre) %>% 
  mutate(genre_avg_critic_score = mean(critic_score)) %>% 
  mutate(genre_avg_user_score = mean(user_score*10)) %>% 
  pivot_longer(c("critic_score", "user_score"),
               names_to = "score_type",
               values_to = "score") %>%
  pivot_longer(c("genre_avg_critic_score", "genre_avg_user_score"),
               names_to = "genre_avg_score_type",
               values_to = "genre_avg_score_percent") %>% 
  mutate(genre_avg_score_type = case_when(
    genre_avg_score_type == "genre_avg_critic_score" ~ "Critic",
    genre_avg_score_type == "genre_avg_user_score" ~ "User")) %>% 
  arrange(genre_avg_score_percent) %>% 
  ungroup()

score_type_list <- avg_ratings %>% 
  distinct(genre_avg_score_type) %>% 
  pull()

## finding the total sales performance for each developer from the years 
## 2000 - 2016.

sales_performance_from_2000 <- game_sales %>% 
  filter(year_of_release %in% c(2000:2016)) %>% 
  group_by(developer, year_of_release) %>% 
  mutate(total_sales = sum(sales)) %>% 
  select(year_of_release, developer, total_sales) %>% 
  distinct(year_of_release, developer, .keep_all = TRUE) %>% 
  arrange(year_of_release, developer) %>% 
  ungroup()


year_choice <- sales_performance_from_2000 %>% 
  distinct(year_of_release) %>% 
  pull()

## finding thge games that are unique to specific gaming platforms. 

exclusive_games <- game_sales %>%
  select(name, platform) %>% 
  mutate(platform = case_when(
    platform == "Wii" ~ "Nintendo Wii",
    platform == "DS" ~ "Nintendo DS",
    platform == "3DS" ~ "Nintendo 3DS",
    platform == "PS4" ~ "PlayStation 4",
    platform == "PS3" ~ "PlayStation 3",
    platform == "X360" ~ "Xbox 360",
    platform == "PS2" ~ "Playstation 2",
    platform == "PS" ~ "PlayStation",
    platform == "WiiU" ~ "Nintendo Wii U",
    platform == "GC" ~ "Google Cloud",
    platform == "GBA" ~ "Nintendo Game Boy Advance",
    platform == "PSP" ~ "PlayStation Portable (PSP)",
    platform == "XOne" ~ "Xbox One",
    platform == "XB" ~ "Xbox",
    platform == "PSV" ~ "PlayStation Vita"
  )) %>% 
  group_by(name) %>%
  mutate(name_count = n()) %>% 
  filter(name_count == 1) %>% 
  select(platform, name) %>% 
  arrange(platform, name) %>% 
  ungroup()

game_choice <- exclusive_games %>% 
  distinct(name) %>% 
  pull()

platform_choice <- exclusive_games %>% 
  distinct(platform) %>% 
  pull()

ui <- fluidPage(
  
  titlePanel(tags$h4(tags$b("Insights: Video Games"))),
  theme = bs_theme(bootswatch = "solar"),
  
  fluidRow( ## adding radio buttons for user to compare average ratings by genre
    column(
      width = 3,
      radioButtons(inputId = "score_type", 
                   label = h3("Scored by:"),
                   choices = score_type_list
      )
    ),
    
    column(
      width = 6,
      plotOutput("avg_ratings_plot")
    )
    ),
  
  tags$br(),
    
    fluidRow( ## adding drop down for user to select particular year for sales comparison
      column(
        width = 3,
        
        selectInput(inputId = "year", 
                    label = h3("Select year:"),
                    choices = year_choice
        )
      ),
      
      column(
        width = 6,
        plotOutput("sales_performance_plot")
      )
    ),
    
    
    fluidRow(
      selectInput(## adding drop down for user to view exclusive games by platform 
        inputId = "platform", 
        label = (tags$i("Platform:")),
        choices = platform_choice
      )
    ),
    
    DT::dataTableOutput("exclusive_games")
  )

server <- function(input, output, session) {
  
  ## the ratings plot gives the user opportunity to see the best performing
  ## game genres based on user reviews and critics reviews. This will give the
  ## user the opportunity to assess which type of game might be most enjoayable
  ## to play.
  
  output$avg_ratings_plot <- renderPlot(expr = {
    avg_ratings %>%
      filter(genre_avg_score_type == input$score_type) %>% 
      ggplot() +
      aes(x = reorder(genre, -genre_avg_score_percent),
          y = genre_avg_score_percent, 
          fill = genre) +
      geom_col() +
      geom_text(aes(label = round(genre_avg_score_percent,2)),
                vjust = -1,
                size = 3) +
      labs(title = "Average video game ratings by genre\n",
           x = "\nGenre",
           y = "Genre Average Rating (%)\n") +
      scale_y_continuous(limits = c(0, 100),
                         expand = c(0,0),
                         breaks = seq(0, 100, 10)) +
      scale_fill_discrete(guide = FALSE) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, 
                                       hjust = 1))
    
  }
  )
  
  ## the sales performance plot allows the user to look at the sales performance
  ## of each developer, based on the input year selected. For example, this could
  ## allow the user to see which developer was most successful in one particular
  ## year - suggesting they had the most popular games in this year - which 
  ## could influence which games the user plays based on the success of sales. 
  
  output$sales_performance_plot <- renderPlot(expr = {
    sales_performance_from_2000 %>%
      filter(year_of_release == input$year) %>% 
      ggplot() +
      aes(x = reorder(developer, total_sales),
          y = total_sales, 
          fill = developer) +
      geom_col() +
      geom_text(aes(label = total_sales),
                hjust = -0.25,
                size = 3) +
      labs(title = "Annual sales by developer\n",
           x = "",
           y = "Total sales (millions)") +
      scale_y_continuous(limits = c(0, 160),
                         expand = c(0,0),
                         breaks = seq(0, 160, 25)) +
      scale_fill_discrete(guide = FALSE) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, 
                                       hjust = 1)) +
      coord_flip()
  }
  )
  
  ## the data table provides the user information as to what games are exclusive
  ## to each platform. This gives the user the opportunity to find what console 
  ## they need to have for any particular exclusive game they would like to play
  
  output$exclusive_games <- DT::renderDataTable({
    exclusive_games %>%
      filter(platform == input$platform)
    
  }
  )
}

shinyApp(ui, server)