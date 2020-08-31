library(jpeg)
library(image.libfacedetection)
library(magick)
library(opencv)
library(utils)
library(pracma)

image1 <- image_read("https://3dnews.ru/assets/external/illustrations/2019/04/04/985331/sm.LinusTorvalds_2016-embed.750.jpg")

faces  <- image_detect_faces(image1)

face <- head(faces$detections, 1)
image_crop(image1, geometry_area(x = face$x, y = face$y, 
                            width = face$width, height = face$height))

boxcontent <- lapply(seq_len(faces$nr), FUN=function(i){

  face <- faces$detections[i, ]

  image_crop(image1, geometry_area(x = face$x, y = face$y, 
                              width = face$width, height = face$height))
})

boxcontent <- do.call(c, boxcontent)

emotion_dict  <- list('Angry' = 0, 'Sad' = 5, 'Neutral' = 4, 'Disgust' = 1, 'Surprise' = 6, 'Fear' = 2, 'Happy' = 3)

#boxcontent  <- image(matrix(boxcontent))
#face_image  <- ocv_read(boxcontent)
boxcontent  <- boxcontent %>%
        image_scale("48x48!") %>%
        image_quantize(colorspace = 'gray')

boxcontent  <- Reshape(boxcontent[[1]], dim(boxcontent[[1]])[2], dim(boxcontent[[1]])[3])
#face_image = ocv_resize(face_image, width = 48, height = 48)
#boxcontent
print(dim(boxcontent))
plot(boxcontent)
