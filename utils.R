# NG_dashboard utils

library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(dplyr)
library(RSQLite)

# open connection to database
con <- dbConnect(SQLite(), dbname = "dashboard_data/app_data.db")

# pull out publisherCounts
counts <- dbGetQuery(con, 'select * from publisherCounts' )
days <- dbGetQuery(con, 'select * from days' )


counts <- counts %>% 
  select(-index, -account_id, -primary_market)

counts$median_amazon_reviews_on_ng[which(is.na(counts$median_amazon_reviews_on_ng))] <- 0
counts$title_count_on_ng[which(is.na(counts$title_count_on_ng))] <- 0