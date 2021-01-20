# TODO: egdar needed for whole internet dataser creating
library(tidyverse)
library(rvest)
library(stringr)
library(rebus)
library(lubridate)
library(rjson)
library(RCurl)
library(XML)
get_first_google_link <- function(name, root = TRUE) {
  url = URLencode(paste0("https://www.google.com/search?q=",name))
  page <- xml2::read_html(url)
  # extract all links
  nodes <- rvest::html_nodes(page, "a")
  links <- rvest::html_attr(nodes,"href")
  # extract first link of the search results
  link <- links[startsWith(links, "/url?q=")][1]
  # clean it
  link <- sub("^/url\\?q\\=(.*?)\\&sa.*$","\\1", link)
  # get root if relevant
#  if(root) link <- sub("^(https?://.*?/).*$", "\\1", link)
  return(link)
}

input  <- "how to be a good guy?"

url  <- paste0("https://api.duckduckgo.com/?q=", input, "&format=json&pretty=1")
data  <- fromJSON(file=url)

print(data$AbstractText)

if(data$AbstractText == "") {
    if(inherits(try(data$RelatedTopics[[1]]$Text), "try-error")){
        first_link  <-  get_first_google_link(input)
        first_link <- read_html(first_link)

        first_link  <- first_link %>%
                        html_text()
        first_link <- sub("^/url\\?q\\=(.*?)\\&sa.*$","\\1", first_link)

        words  <- unlist(strsplit(first_link, " "))
        input  <- unlist(strsplit(input, " "))
        i  <- 0
        while (i != length(input)) {
                i  <- i + 1

                res  <- which(words == input[i])
                print(res)

        }
    } else {
        print(data$RelatedTopics[[1]]$Text)
    }
}

print(paste0("if you are really intrested in the theme read that: ", data$AbstractURL, "but oke, shut up, you pice of human"))
