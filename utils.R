# NG_dashboard utils

library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(dplyr)
library(RSQLite)
library(reshape2)

# open connection to database
con <- dbConnect(SQLite(), dbname = "dashboard_data/app_data.db")

# pull out publisherCounts
counts <- dbGetQuery(con, 'select * from publisherCounts' )
days <- dbGetQuery(con, 'select * from days' )


counts <- counts %>% 
  select(-index, -account_id, -primary_market)

counts$median_amazon_reviews_on_ng[which(is.na(counts$median_amazon_reviews_on_ng))] <- 0
counts$title_count_on_ng[which(is.na(counts$title_count_on_ng))] <- 0


# read in new data
df <- read.csv("dashboard_data/ML_data.csv", stringsAsFactors = FALSE)
pub_info <- read.csv("dashboard_data/NetGalley Active Publishers providing ONIX - 20170213.csv", stringsAsFactors = FALSE)

df <- df %>% left_join(pub_info[,c("billing_name", "id")], by = c("account_id" = "id"))
days <- days %>% left_join(pub_info, by = c("account_id" = "id"))
