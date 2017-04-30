source("utils.R")

# Define UI
ui <- dashboardPage(
  
  # Application title 
  dashboardHeader(title = "NetGalley Dashboard"),
  
  # Sidebar
  dashboardSidebar(    
    sidebarMenu(
      
      selectInput("pub_list",
                  label = "Publisher:",
                  choices = sort(unique(counts$billing_name))),
      
      menuItem("Tab 1", 
               tabName = "tab1", 
               icon = icon("bar-chart"))
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "tab1",
        fluidRow(
          box(
            title = "plot 1",
            solidHeader = TRUE,
            plotlyOutput("plot1")
          )
        ),
        fluidRow(
          box(
            title = "plot2",
            solidHeader = TRUE,
            plotlyOutput("plot2")
          )
        ),
        fluidRow(
          box(
            title = "plot3",
            solidHeader = TRUE,
            plotlyOutput("plot3")
          )
        ),
        fluidRow(
          box(
            title = "plot4",
            solidHeader = TRUE,
            plotlyOutput("plot4")
          )
        ),
        fluidRow(
          box(
            title = "plot5",
            solidHeader = TRUE,
            plotlyOutput("plot5")
          )
        )
      )
    )
  )
)

# Define server logic required
server <- function(input, output) {
   
   output$plot1 <- renderPlotly({
     p <- counts %>% 
       ggplot(aes(y = median_amazon_reviews_on_ng,
                  x = median_amazon_reviews_off_ng, 
                  size = n_contracted_titles,
                  text = paste0("Publisher: ", billing_name))) +
       geom_jitter(alpha = .5) +
       geom_abline(aes(intercept = 0, slope = 1), colour = "red") +
       theme_minimal() +
       labs(y = "Median Amz Reviews On NG",
            x = "Median Amz Reviews Off NG") +
       theme(legend.position = "none")
     
     ggplotly(p)
   })
   
   output$plot2 <- renderPlotly({
     x <- list(
       title = "Number of Days on NetGalley"
    )
     y <- list(
       title = "Number of Titles"
    )
     p <- plot_ly(x = ~days[which(days$billing_name == input$pub_list), "n_days_on_netgalley"], type = "histogram") %>%
       layout(xaxis = x, yaxis = y)
   })
   
   output$plot3 <- renderPlotly({
     p <- df %>% 
       filter(billing_name == input$pub_list) %>%
       select(auto_approved_pct, 
              declined_pct, 
              granted_by_wish_pct, 
              invited_pct, 
              new_pct, 
              read_now_pct, 
              manual_approved_pct) %>% 
       melt() %>% 
       ggplot(aes(x = variable, y = value)) + 
       geom_boxplot() + 
       scale_x_discrete(labels = c("Manual", "Read Now", "New", "Invited", "Granted by Wish", "Declined", "Auto Approved")) +
       coord_flip() +
       theme_minimal() +
       labs(x = NULL, y = NULL, title = "Approval Methods")
     
     ggplotly(p)
   })
   
   output$plot4 <- renderPlotly({
     p <- df %>%
       filter(billing_name == input$pub_list) %>%
       select(kindle_pct,
              open_pct,
              permanent_drm_pct,
              social_drm_pct,
              temporary_drm_pct) %>%
       melt() %>%
       ggplot(aes(x = variable, y = value)) +
       geom_boxplot() +
       scale_x_discrete(labels = c("Kindle", "Open", "Permanent DRM", "Social DRM", "Temporary DRM")) +
       coord_flip() +
       theme_minimal() +
       labs(x = NULL, y = NULL, title = "Download Methods")

     ggplotly(p)
   })
  
   output$plot5 <- renderPlotly({
     p <- df %>%
       filter(billing_name == input$pub_list) %>%
       filter(social_shares > 0) %>%
       ggplot(aes(y = social_views, x = social_shares)) +
       geom_jitter(alpha = .5) +
       theme_minimal() +
       labs(x = "Social Shares",
            y = "Social Views",
            title = "Social Activity")

     ggplotly(p)
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

