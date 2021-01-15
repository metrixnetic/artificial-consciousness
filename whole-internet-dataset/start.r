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

input  <- "albert einstein"

url  <- paste0("https://api.duckduckgo.com/?q=", input, "&format=json&pretty=1")
data  <- fromJSON(file=url)

print(data$AbstractText)

if(data$AbstractText == "") {
    if(inherits(try(data$RelatedTopics[[1]]$Text), "try-error")){
        print("got that")
    } else {
        print(data$RelatedTopics[[1]]$Text)
    }
}

print(paste0("if you are really intrested in the theme read that: ", data$AbstractURL, "but oke, shut up, you pice of human"))
