import numpy as np
import math as math
from skimage import data
from skimage.color import rgb2gray


def g_two_dim(x, y, sigma_x, sigma_y, mu_x, mu_y):
    """
    :param x:
    :param y:
    :param sigma_x:
    :param sigma_y:
    :param mu_x:
    :param mu_y:
    :return: Two dimension array of Gaussian function
    """
    exp = ((x-mu_x)**2)/(2*sigma_x**2) + ((y-mu_y)**2)/(2*sigma_y**2)
    const = 1/(sigma_x*sigma_y*2*math.pi)
    return const*math.pow(math.e, -exp)


def gaussian_kernel(row, col, mean_v=0, std_v=None, mean_h=0, std_h=None):
    """
    :param row: y axe length (size of the gaussian frame)
    :param col: x axe length (size of the gaussian frame)
    :param mean_v: max vertical value
    :param mean_h: max horizontal value
    :param std_v: vertical deviation
    :param std_h: horizontal deviation
    :return: Two dimension array of Gaussian kernel constructed by the parameters had been given
    """
    if std_v is None:
        std_v = row/2
    if std_v == 0:
        raise ValueError()
    if std_h is None:
        std_h = col/2
    if std_h == 0:
        raise ValueError()
    g_ker = np.zeros((row, col), dtype=float)
    for i in range(row):
        for j in range(col):
            g_ker[i, j] = g_two_dim(j-col/2, i-row/2, std_h, std_v, mean_h, mean_v)
    return g_ker



def gaussian_blur(image=None, g_ker=None):
    """
    :param image: Two dimension array of picture in gray-scale that need to be convoluted
    :param g_ker: Two dimension array of an Gaussian kernel function
    :return: An image represented by two dimension array in gray-scale, after operating the Gaussian kernel array on
    every pixel in the image (without the right ond bottom strips of the image there for it might be colored black).
    """
    if image is None or g_ker is None:
        raise ValueError
    output_image = np.zeros_like(image)
    for row in range(output_image.shape[0]):
        for col in range(output_image.shape[1]):
            # We define the max length and height that we want to operate on and that way we ensure that we do not get
            # an out of range error.
            max_row = min(row + g_ker.shape[0], image.shape[0])
            max_col = min(col + g_ker.shape[1], image.shape[1])
            # "Mirroring" the image and the gaussian and multiply the two (2 two dim arrays in the same size),
            # and then summing it up. The same sum we insert to the top left corner of the current frame.
            output_image[row, col] = np.sum((image[row:max_row, col:max_col]) * g_ker[:max_row - row, :max_col - col])
    return output_image

