import numpy as np
from PIL import Image, ImageOps, ImageDraw, ImageFont
import os


PER_PIXEL_LINE_BOUNDARY = 9999

# Load the image and convert the image to GrayScale
def RGB_to_Gray(img_src, img_dst):
    coloured_img = Image.open(img_src)
    grayed_image = ImageOps.grayscale(coloured_img)
    grayed_image.save(img_dst)

# Resize the image to a 100 x 1OO pixels
def ImgResize(img_dim:tuple, img_src):
    img = Image.open(img_src)
    res = img.resize(img_dim)
    return res


# Extract the 8-bit integer value(0-255) for each pixel.
def Extract_PixelVal(img):
    # convert image to 8-bit grayscale
    img = img.convert('L')
    # convert image data to a list of integers
    data = list(img.get_flattened_data()) 
    return data

# Convert each integer into an 8-bit binary string.

# Save these strings to imagesrc.txt in row-wise manner,strictly formatting it as one pixelper line (10,000 linestotal).
def Save_PixelasString(pixel_values: str):
    with open("imagesrc.txt", "w") as file:

        for index, pixel in enumerate(pixel_values):
            print(index)
            if (index != PER_PIXEL_LINE_BOUNDARY):
                file.write(str(pixel))
                file.write('\n')
            else:
                file.write(str(pixel))

def main():

    # convert the image to greyscale
    RGB_to_Gray("imagesrcfile.jpg", "grayed_image.png")

    # Resize the image
    resized_img = ImgResize((100, 100), "grayed_image.png")
    resized_img.save("grayed_image_resized.png")

    # Get grayscaled pixel values
    pixel_val = Extract_PixelVal(resized_img)

    # Save the pixel values strings to imagesrc.txt 
    Save_PixelasString(pixel_val)
    


if __name__ == "__main__":
    main()