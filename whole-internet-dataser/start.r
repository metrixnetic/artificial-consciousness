# TODO: egdar needed for whole internet dataser creating
library(tidyverse)
library(rvest)
library(stringr)
library(rebus)
library(lubridate)
library(rjson)

#scraping_wiki <- read_html("https://en.wikipedia.org/wiki/Web_scraping")

#cubik  <- scraping_wiki %>%
 #           html_text()
#cubik  <- gsub("\\$", "", cubik)
#cat(cubik)

input  <- "who is vikings"
url  <- paste0("https://api.duckduckgo.com/?q=", input, "&format=json&pretty=1")
data  <- fromJSON(file=url)
print(data)

