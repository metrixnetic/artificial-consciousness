library(tidyverse)
library(tidytext)
library(stringr)

tx  <- "i trust you"
textInp <- gsub("\\$", "", tx)

# tokenize
tokens <- data_frame(text = textInp) %>% unnest_tokens(word, text)

res  <- tokens %>%
  inner_join(get_sentiments("nrc")) %>% 
  count(sentiment) %>% 
  spread(sentiment, n, fill = 0) %>%
  mutate(1)

res  <- c(unlist(res[1:length(unlist(res))]), 1)

if (max(res) == 1) { 
    res  <- names(res[1:(length(names(res)) - 2)])
} else {
    res  <- names(which.max(res))
}

print(res)
