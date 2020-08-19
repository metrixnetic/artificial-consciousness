library(magick)
library(image.libfacedetection)
library(dygraphs)

image1 <- image_read("http://bnosac.be/images/bnosac/blog/wikipedia-25930827182-kerry-michel.jpg")

faces <- image_detect_faces(image1)

plot(faces, image1, border = "red", lwd = 7, col = "white")
