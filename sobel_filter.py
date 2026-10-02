

# Implement the Sobel filter entirely in software.

# Apply the 3 ×3 𝐾𝑥 and 𝐾𝑦 convolution kernels to the grayscale version of the image.

# Calculate the precise edge magnitude using the Euclidean distance : 𝐺 = √︃𝐺2 𝑥 + 𝐺2 𝑦

# Save the resulting edgemap as edges_python.png and export the raw float values to 
# python_ref.txt for your final error analysis

import numpy as np
from PIL import Image, ImageOps

# 𝐾𝑥 convolution kernel
Kx = np.array([
    [-1, 0, 1], 
    [-2, 0, 2], 
    [-1, 0, 1]
    ])

# 𝐾𝑦 convolution kernel
Ky = np.array([
    [-1, -2, -1], 
    [0,   0,  0], 
    [1,   2,  1]
    ])


# Load the image and convert the image to GrayScale
def RGB_to_Gray(img_src, img_dst):
    coloured_img = Image.open(img_src)
    grayed_image = ImageOps.grayscale(coloured_img)
    grayed_image.save(img_dst)

# Extract the 8-bit integer value(0-255) for each pixel.
def Extract_PixelVal(img):
    # convert image to 8-bit grayscale
    img = img.convert('L')
    # convert image data to a list of integers
    data = list(img.get_flattened_data()) 
    return data

# Resize the image to a 100 x 1OO pixels
def ImgResize(img_dim:tuple, img_src):
    img = Image.open(img_src)
    res = img.resize(img_dim)
    return res

# Multiplies the Pixel window (3x3) using 
def convolve(image, kernel):
    height, width = image.shape
    output = np.zeros((height - 2, width - 2), dtype=np.float32)
    
    # Loop over each pixel, skipping the 1-pixel border
    for y in range(1, height - 1):
        for x in range(1, width - 1):
            # Grab the 3x3 neighbourhood around (y, x)
            window = image[y-1:y+2, x-1:x+2]
            
            # Element-wise multiply with kernel and sum
            total = 0.0
            for ky in range(3):
                for kx in range(3):
                    total += window[ky, kx] * kernel[ky, kx]
            
            output[y-1, x-1] = total
    
    return output

def main():
# convert the image to greyscale
    RGB_to_Gray("imagesrcfile.jpg", "grayed_image.png")

    # Resize the image
    resized_img = ImgResize((100, 100), "grayed_image.png")
    resized_img.save("grayed_image_resized.png")

    # Get grayscaled pixel values
    pixel_val = Extract_PixelVal(resized_img)

    # Turn the flat list into a 2D numpy array of shape (height, width)
    img_array = np.array(pixel_val).reshape(100, 100).astype(np.float32)

    
    # Derive Gx and Gy
    Gx = convolve(img_array, Kx)
    Gy = convolve(img_array, Ky)
    
    # Edge magnitude (Euclidean distance): G = sqrt(Gx^2 + Gy^2)
    G = np.sqrt(Gx**2 + Gy**2)

    print( G )
    print("...............")
    print(G.max())
    print("...............")
    print( G / G.max())

    # Normalize to 0-255 so it can be displayed/saved properly
    G_normalized = G / G.max() * 255.0
    edge_img = Image.fromarray(G_normalized.astype(np.uint8))
    edge_img.save("edges_python.png")

    # Save raw float values for error analysis 
    np.savetxt("python_ref.txt", G, fmt="%.6f")

if __name__ == "__main__":
    main()