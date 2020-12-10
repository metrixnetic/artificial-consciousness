library(Kmisc)

positive  <-  read.csv('../Datasets/sentiment-analysis/positive.csv', skipNul = TRUE)
negative  <-  read.csv('../Datasets/sentiment-analysis/negative.csv', skipNul = TRUE)

try_tolower = function(x) {
  y = NA
  # tryCatch error
  try_error = tryCatch(tolower(x), error = function(e) e)
  # if not an error
  if (!inherits(try_error, "error"))
    y = tolower(x)
  return(y)
}

clean = function(t) {
    
    i  <- 0
    while (i < length(t)) {
        
        i  <- i + 1

        t[i] = gsub('[[:punct:]]', '', t[i])
        t[i] = gsub('[[:cntrl:]]', '', t[i])
        t[i] = gsub('\\d+', '', t[i])
        t[i] = gsub('[[:digit:]]', '', t[i])
        t[i] = gsub('@\\w+', '', t[i])
        t[i] = gsub('http\\w+', '', t[i])
        t[i] = gsub("^\\s+|\\s+$", "", t[i])
        t[i] = sapply(t[i], function(x)
            try_tolower(x))
        t[i] = strsplit(t[i], " ")
        t[i] = unlist(t[i])

    }
    return(t)
               
}


positive  <- as.vector(unlist(positive, use.names=FALSE))
negative  <- as.vector(unlist(negative, use.names=FALSE))
positive  <- clean(positive)

print(head(positive))

