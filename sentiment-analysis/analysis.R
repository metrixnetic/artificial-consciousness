l:qbrary('twitteR')
library('wordcloud')
library('tau')
library('RWeka')
library('tm')
library('tm.plugin.webmining')
library('stringr')
library('dplyr')
library('ggplot2')


#setwd('../Datasets/sentiment-analysis/')

# словари позитивных и негативных слов
positive = scan('positive-words.txt',
                what = 'character',
                comment.char = ';')

negative = scan('negative-words.txt',
                what = 'character',
                comment.char = ';')


rt = readLines('original_rt_snippets.txt')


# выровнять регистр
tryTolower = function(x) {
  
  y = NA
  
  try_error = tryCatch(
    
    tolower(x),
    error = function(e)
      e
    
  )
  
  if (!inherits(try_error, "error"))
    y = tolower(x)
  
  return(y)
  
}
# чистка от знаков

clean = function(t) {
  
    t = gsub('[[:punct:]]', '', t)
    t = gsub('[[:cntrl:]]', '', t)
    t = gsub('\\d+', '', t)
    t = gsub('[[:digit:]]', '', t)
    t = gsub('@\\w+', '', t)
    t = gsub('http\\w+', '', t)
    t = gsub("^\\s+|\\s+$", "", t)
    t = sapply(t, function(x)
      tryTolower(x))
    t = str_split(t, " ")
    t = unlist(t)
               
    return(t)
               
}
               
rt = lapply(rt, function(x)
    clean(x))
            
head(rt, 5)

returnpscore = function(rt) {
  
    # подсчет позитивных совпадений
    pos.match = match(rt, positive)
    pos.match = !is.na(pos.match)
    pos.score = sum(pos.match)
    return(pos.score)
}

positive.score = lapply(rt, function(x)
    returnpscore(x))

pcount = 0

for (i in 1:length(positive.score)) {
    pcount = pcount + positive.score[[i]]
}

pcount

poswords = function(rt) {
  # позитивные вхождения
    pmatch = match(t, positive)
    posw = positive[pmatch]
    posw = posw[!is.na(posw)]
    return(posw)
}

words = NULL

pdatamart = data.frame(words)

for (t in rt) {

    pdatamart = c(poswords(t), pdatamart)

}

head(pdatamart, 10)

returnpscore = function(rt) {
  
  # подсчета позитивных совпадений
    neg.match = match(rt, negative)
    neg.match = !is.na(neg.match)
    neg.score = sum(neg.match)
  
    return(neg.score)
  
}
                        
negative.score = lapply(rt, function(x)
    returnpscore(x))
                        
ncount = 0
                        
for (i in 1:length(negative.score)) {
  
    ncount = ncount + negative.score[[i]]
  
}
                        
ncount
                        
negwords = function(rt) {
  
  # негативные вхождения
    pmatch = match(t, negative)
    negw = negative[pmatch]
    negw = negw[!is.na(negw)]
  
    return(negw)
}
words = NULL
                        
ndatamart = data.frame(words)
                        
for (t in rt) {
  
    ndatamart = c(negwords(t), ndatamart)
  
}
                        
head(ndatamart, 10)

dpwords = data.frame(table(positive))
dnwords = data.frame(table(negative))
                        
dpwords = dpwords %>%
    mutate(positive = as.character(positive)) %>%
    filter(Freq > 15)
                        
dnwords = dnwords %>%
    mutate(negative = as.character(negative)) %>%
    filter(Freq > 15)

ggplot(pdatamart, aes(positive, Freq)) + geom_bar(stat = "identity", fill =
                                                    "lightblue") + theme_bw() +
    geom_text(aes(positive, Freq, label = Freq), size = 4) +
    labs(
      
      x = "Major Positive Words",
      y = "Frequency of Occurence",
      
      title = paste(
        "Major Positive Words and Occurence in \n RT reviews, n =",
        length(rt)
      )
    ) +
    geom_text(aes(1, 5, label = paste("Total Positive Words :", pcount)), size =
              4, hjust = 0) + theme(axis.text.x = element_text(angle = 45))

wordcloud(
  
    negative,
    colors = 'brown',
    scale = c(1.25, 1.25),
    max.words = 80
  
)
                        
wordcloud(
  
    positive,
    colors = 'darkkhaki',
    scale = c(1.25, 1.25),
    max.words = 80
  
)

dptm = DocumentTermMatrix(positive)
