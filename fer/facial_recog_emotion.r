library(jpeg)
library(magick)

image1 <- image_read("https://3dnews.ru/assets/external/illustrations/2019/04/04/985331/sm.LinusTorvalds_2016-embed.750.jpg")

image1_matrix  <- readJPEG("../Datasets/fer/750.jpg")

detect_faces <- function(x, width, height, step) {

    .Call('_image_libfacedetection_detect_faces', PACKAGE = 'image.libfacedetection', x, width, height, step)

}

image_detect_faces <- function(x) {

  if(inherits(x, "magick-image")) {

    if(!requireNamespace("magick", quietly = TRUE)) {

      stop("image_detect_faces requires the magick package, which you can install from cran with install.packages('magick')")

    }

    meta <- magick::image_info(x)

    if(nrow(meta) != 1) {

      stop("image_detect_faces requires a magick-image containing 1 image only")

    }
    w <- meta$width
    h <- meta$height
    
    x <- magick::image_data(x, channels = "rgb")

    x <- as.integer(x)

    x <- aperm(x, c(3, 2, 1))

    faces <- detect_faces(x, width = w, height = h, step = 1*w*3)

  } else if(inherits(x, "array")) {

    w <- ncol(x)
    h <- nrow(x)

    stopifnot(length(dim(x)) == 3 && dim(x)[3] == 3)

    x <- aperm(x, c(3, 2, 1))

    faces <- detect_faces(x, width = w, height = h, step = 1*w*3)

  } else {

    stop("x is not an array nor a magick-image")

  }

  class(faces) <- "libfacedetection"

  return(faces)

}

faces  <- image_detect_faces(image1)

#faces_image1  <- 

#plot(faces)
