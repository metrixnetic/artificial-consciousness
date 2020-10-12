library(tfhub)
library(tensorflow)
library(keras)
library(magick)

classifier_url  <- "https://tfhub.dev/google/tf2-preview/mobilenet_v2/classification/4"

mobil_layer  <- layer_hub(handle = classifier_url)

input <- layer_input(shape = c(224, 224, 3))

output <- input %>%
  mobil_layer()


model <- keras_model(input, output)

img <- image_read('https://cdn.pixabay.com/photo/2018/12/06/21/14/flower-gerbel-3860634_960_720.jpg') %>%
  image_resize(geometry = "224x224x3!") %>% 
  image_data() %>% 
  as.numeric() %>% 
  abind::abind(along = 0)

result <- predict(model, img)
print(mobilenet_decode_predictions(result[,-1, drop = FALSE]))

