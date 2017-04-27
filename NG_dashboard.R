source(utils.R)

# Define UI
ui <- dashboardPage(
  
  # Application title 
  dashboardHeader(title = "NetGalley Dashboard"),
  
  # Sidebar
  dashboardSidebar(    
    sidebarMenu(
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
            solidHeader = TRUE
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
}

# Run the application 
shinyApp(ui = ui, server = server)

