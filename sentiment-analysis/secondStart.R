library(tidyverse)
library(tm)
list.files(path = "../input")
options(repr.plot.width = 10, repr.plot.height = 8)

df_train <- read_csv("../input/train.csv")
# read test
df_test <- read_csv("../input/train.csv")
# read sample submission
sample_submission <- read_csv("../input/sample_submission.csv")

#print(ggplot(data = df_train,aes(sentiment,fill=sentiment))+geom_bar(aes(y=(..count..)/sum(..count..)))+
#    geom_text(stat='count', aes(y=(..count..)/sum(..count..),label=round((..count..)/sum(..count..),2)), vjust=-1)+
#    ggtitle(str_wrap("Tweets General Sentiment in Training Data",30)))

# If you want see data | 


removeHtmlTags <- function(x)
    (gsub("<.*?>", "", x))
removeHashTags <- function(x)
    gsub("#\\S+", " ", x)
removeTwitterHandles <- function(x)
    gsub("@\\S+", " ", x)
removeURL <- function(x)
    gsub("http:[[:alnum:]]*", " ", x)
removeApostrophe <- function(x)
    gsub("'", "", x)
removeNonLetters <- function(x)
    gsub("[^a-zA-Z\\s]", " ", x)
removeSingleChar <- function(x)
    gsub("\\s\\S\\s", " ", x)
    # function to clean corpus
cleanCorpus <- function(reviews){
    # create the corpus
    corpus <- VCorpus(VectorSource(reviews))
    # remove reviews
    rm(reviews)
    # remove twitter handles and hashtags
    corpus <- tm_map(corpus, content_transformer(removeHtmlTags))
    corpus <- tm_map(corpus,content_transformer(removeHashTags))
    corpus <- tm_map(corpus,content_transformer(removeTwitterHandles))
    # other cleaning transformations
    corpus <- tm_map(corpus, content_transformer(removeURL))
    corpus <- tm_map(corpus, content_transformer(removeApostrophe))
    corpus <- tm_map(corpus, content_transformer(removeNonLetters))
    corpus <- tm_map(corpus, removeNumbers)
    corpus <- tm_map(corpus, content_transformer(tolower))
    corpus <- tm_map(corpus, removeWords, c(stopwords("english")))
    corpus <- tm_map(corpus, content_transformer(removeSingleChar))
    # Remove punctuations
    corpus <- tm_map(corpus, removePunctuation)
    # Eliminate extra white spaces
    corpus <- tm_map(corpus, stripWhitespace)    
    # stem document
    corpuse <- tm_map(corpus, stemDocument)
    return(corpuse)
}

# function get word frequency
wordFrequency <- function(corpus){
    dtm <- TermDocumentMatrix(corpus)
    rm(corpus)
    # convert to matrix
    m <- as.matrix(dtm)
    rm(dtm)
    # sort by word frequency
    v <- sort(rowSums(m),decreasing=TRUE)
    rm(m)
    # calculate word frequency
    word_frequencies <- data.frame(word = names(v),freq=v)
    return(word_frequencies)
}

reviews <- df_train$text
corpus_train <- cleanCorpus(reviews)

reviews_selected_text <- df_train$selected_text
corpus_selected_text <- cleanCorpus(reviews_selected_text)

df_pos_train <- df_train[df_train$sentiment == "positive",]
df_neg_train <- df_train[df_train$sentiment == "negative",]
df_neu_train <- df_train[df_train$sentiment == "neutral",]

corpus_train_pos <- cleanCorpus(df_pos_train$text)
corpus_train_neg <- cleanCorpus(df_neg_train$text)
corpus_train_neu <- cleanCorpus(df_neu_train$text)

word_frequencies_train <- wordFrequency(corpus_train)
# print top 10 word frequencies
print(ggplot(data = word_frequencies_train[1:10,], aes(reorder(word, order(freq, decreasing = TRUE)), freq))+geom_col()+
ggtitle("Top 10 most Frequent Words in Training Data")+xlab("Words")+ylab("Frequencies")+thm+theme(
  plot.title = element_text(size = 16,hjust = 0.5),
  axis.text = element_text(size =14),
  axis.title = element_text(size = 14)
))



