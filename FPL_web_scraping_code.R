## Web Scraping FPL Data ##

# Website was loaded using JavaScript, so required packages
# RSelenium, tidyverse, rvest, data.table, and netstat

library(tidyverse)
library(RSelenium)
library(rvest)
library(netstat)
library(data.table)

# Using RSelenium to open a Chrome browser:
  # Haven't exactly figured out how to un-occupy the port
  # after using it :/ so basically if it says something
  # like "port is occupied" just change it to some other
  # random integer and it usually works
rs_driver_object = rsDriver(browser = "chrome", 
                            chromever = "107.0.5304.62", 
                            verbose = F, 
                            port = 18284L)

remDr = rs_driver_object$client

# Opening the browser page
remDr$open() 

# Navigating to given url
remDr$navigate("https://fantasy.premierleague.com/player-list") 

# obtaining the table using its html tag name
data_table = remDr$findElement(using = "tag name", value = "td")

data_table_html = data_table$getPageSource()

page = read_html(data_table_html %>% unlist())

# Combining the matrix of tibbles into a single one
fpl = rbindlist(html_table(page))

remDr$close()

# Saving it ot CSV file locally - this is in the Github repository
write.csv(fpl, "C:\\Users\\jasmi\\OneDrive\\Documents\\UT\\SDS 313\\fpl_table_GW14.csv", row.names = FALSE)
