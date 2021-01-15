# TODO: egdar needed for whole internet dataser creating
library(tidyverse)
library(rvest)
library(stringr)
library(rebus)
library(lubridate)
library(rjson)


input  <- "albert einshtein"

url  <- paste0("https://api.duckduckgo.com/?q=", input, "&format=json&pretty=1")
data  <- fromJSON(file=url)

print(data$AbstractText)

if(data$AbstractText == "") {
    if(inherits(try(data$RelatedTopics[[1]]$Text), "try-error")){
        i  <- 1
        WS1  <- html_session(i)
        search_url  <- paste0("https://www.google.com/search?q", input)
        links <- search_url %>% 
            html_nodes(WS1, ".r a") %>% # get the a nodes with an r class
            html_attr("href") # get the href attributes

        links = gsub('/url\\?q=','',sapply(strsplit(links[as.vector(grep('url',links))],split='&'),'[',1))
# as a dataframe
        websites <- data.frame(links = links, stringsAsFactors = FALSE)
        print(length(websites))

#        scraping_wiki <- read_html("https://en.wikipedia.org/wiki/Web_scraping")

 #       cubik  <- scraping_wiki %>%
  #      html_text()
   #     cubik  <- gsub("\\$", "", cubik)
    #    cat(cubik)

    } else {
        print(data$RelatedTopics[[1]]$Text)
    }
}

print(paste0("if you are really intrested in the theme read that: ", data$AbstractURL, "but oke, shut up, you pice of human"))
