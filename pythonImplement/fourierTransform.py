'''
## FourierTransform.py 傅里叶滤波
功能: 对图像在频域进行滤波
使用方法:

```
python fourierTransform.py -f [ImagePath] --filter [filterType]
# High Pass
python fourierTransform.py -f ../test_images/camera.tiff --filter simpleHighPass
python fourierTransform.py -f ../test_images/camera.tiff --filter laplacian
# Low Pass
python fourierTransform.py -f ../test_images/camera.tiff --filter simpleLowPass
python fourierTransform.py -f ../test_images/camera.tiff --filter guassian
python fourierTransform.py -f ../test_images/camera.tiff --filter mean
python 
```
'''

import cv2.cv2 as cv2
import numpy as np
from matplotlib import pyplot as plt
from functools import partial
import argparse

def magnitudeSpectrum(img):
    '''
    Get the magnituded Spectrum to plot.
    '''
    f = np.fft.fft2(img)
    fshift = np.fft.fftshift(f)
    magnitude_spectrum = 20 * np.log(np.abs(fshift))
    return magnitude_spectrum


def simpleHighPassFilter(img, width=30):
    '''
    Simple hight pass filer drops the low frequency part at center with a square of width*2 * width*2.

    Returns:
        img_back -- The img processed by filter.
        fshift -- the modified spectrum. !! magnitude manually before plot
    '''
    f = np.fft.fft2(img)
    fshift = np.fft.fftshift(f)
    rows, cols = img.shape
    crow, ccol = int(rows/2), int(cols/2)  # get center coord
    fshift[crow-width:crow+width, ccol-width:ccol+width] = 0
    f_ishift = np.fft.ifftshift(fshift)
    img_back = np.fft.ifft2(f_ishift)
    img_back = np.abs(img_back)
    return img_back, fshift


def simpleLowPassFilter(img, width=30):
    '''
    Simple low pass filer remains the low frequency part at center with a square of width*2 * width*2.

    Returns:
        img_back -- The img processed by filter.
        fshift -- the modified spectrum. !! magnitude manually before plot
    '''
    f = np.fft.fft2(img)
    fshift = np.fft.fftshift(f)
    rows, cols = img.shape
    crow, ccol = int(rows/2), int(cols/2)
    # 低通需要通过mask取中心值
    mask = np.zeros((rows, cols), np.uint8)
    mask[crow-30:crow+30, ccol-30:ccol+30] = 1
    # apply mask
    fshift = fshift * mask
    f_ishift = np.fft.ifftshift(fshift)
    img_back = np.fft.ifft2(f_ishift)
    img_back = np.abs(img_back)
    return img_back, fshift


def specturmFiltering(img, filterName):
    '''
    Do specturm filtering on img choosing filter by filterName.
    '''
    im_size = img.shape
    f = np.fft.fft2(img)
    otf = psf2otf(getSpaceFilter(filterName), (im_size[0], im_size[1]))
    result = f * otf # convert to multiple in specturm
    img_back = np.fft.ifft2(result)
    img_back = np.abs(img_back)
    return img_back, np.fft.fftshift(otf)


gaussianSpecturmFilter = partial(specturmFiltering, filterName='gaussian')
meanSpecturmFilter = partial(specturmFiltering, filterName='mean')
laplacianSpecturmFilter = partial(specturmFiltering, filterName='laplacian')

def getSpaceFilter(filterName):
    '''
    Return a np.array of space filter by name.
    '''
    gaussianKernel = cv2.getGaussianKernel(5, 1)
    filters = {
        'gaussian': gaussianKernel * gaussianKernel.T,
        'mean': np.ones((3, 3)),
        'laplacian': np.array([[0, 1, 0],
                               [1, -4, 1],
                               [0, 1, 0]]),
    }
    if not filterName in filters:
        raise NotImplementedError(
            '{} filter not supported yet.'.format(filterName))
    return filters[filterName]


def psf2otf(psf, outputSize):
    '''
    Similar to psf2otf in Matlab.
    '''
    output = np.zeros(outputSize)
    w, h = psf.shape
    c_w, c_h = int(outputSize[0]/2), int(outputSize[1]/2)
    assert w <= outputSize[0] and h <= outputSize[1]
    output[c_w - w//2: c_w - w//2 + w, c_h - h//2: c_h - h//2 + h] = psf
    output = np.fft.fftshift(output)
    otf = np.fft.fft2(output)
    return otf


def test_magnitudeSpectrum(img):
    magnitude_spectrum = magnitudeSpectrum(img)
    plt.subplot(121), plt.imshow(img, cmap='gray')
    plt.title('Input_Image'), plt.xticks([]), plt.yticks([])
    plt.subplot(122), plt.imshow(magnitude_spectrum, cmap='gray')
    plt.title('Magnitude_Spectrum'), plt.xticks([]), plt.yticks([])


def test_simpleHighPassFilter(img):
    img_back, fshift = simpleHighPassFilter(img, width=30)
    plt.subplot(131)
    plt.imshow(img, cmap='gray')
    plt.title('Input_Image'), plt.xticks([]), plt.yticks([])
    plt.subplot(132)
    plt.imshow(img_back, cmap='gray')
    plt.title('Output_Image'), plt.xticks([]), plt.yticks([])
    plt.subplot(133)
    plt.imshow(20 * np.log(np.abs(fshift) + 1), cmap='gray')
    plt.title('modified spectrum'), plt.xticks([]), plt.yticks([])


def test_simpleLowPassFilter(img):
    img_back, fshift = simpleLowPassFilter(img, width=30)
    plt.subplot(131)
    plt.imshow(img, cmap='gray')
    plt.title('Input_Image'), plt.xticks([]), plt.yticks([])
    plt.subplot(132)
    plt.imshow(img_back, cmap='gray')
    plt.title('Output_Image'), plt.xticks([]), plt.yticks([])
    plt.subplot(133)
    plt.imshow(20 * np.log(np.abs(fshift) + 1), cmap='gray')
    plt.title('modified spectrum'), plt.xticks([]), plt.yticks([])




def test_general_filters(img, filter_func, figure_title=None):
    img_back, fshift = filter_func(img)
    plt.figure()
    if not figure_title is None:
        plt.suptitle(figure_title)
    plt.subplot(131)
    plt.imshow(img, cmap='gray')
    plt.title('Input_Image'), plt.xticks([]), plt.yticks([])
    plt.subplot(132)
    plt.imshow(img_back, cmap='gray')
    plt.title('Output_Image'), plt.xticks([]), plt.yticks([])
    plt.subplot(133)
    plt.imshow(20 * np.log(np.abs(fshift) + 1), cmap='gray')
    plt.title('modified spectrum'), plt.xticks([]), plt.yticks([])



def test_psf2otf():
    otf1 = psf2otf(getSpaceFilter('gaussian'), (50, 50))
    otf2 = psf2otf(getSpaceFilter('mean'), (50, 50))
    otf3 = psf2otf(getSpaceFilter('laplacian'), (50, 50))
    otf1 = np.fft.fftshift(otf1)
    otf2 = np.fft.fftshift(otf2)
    otf3 = np.fft.fftshift(otf3)
    plt.subplot(131)
    plt.imshow(np.abs(otf1), cmap='gray')
    plt.subplot(132)
    plt.imshow(np.abs(otf2), cmap='gray')
    plt.subplot(133)
    plt.imshow(np.abs(otf3), cmap='gray')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Specturm filter tool')
    parser.add_argument('--filepath', '-f', required=True, help='Img input.')
    parser.add_argument('--filter', choices=['simpleLowPass', 'simpleHighPass', 'guassian', 'mean', 'laplacian'], help='Specturm filter type')
    args = parser.parse_args()
    img = cv2.imread(args.filepath, 0)
    if args.filter == 'simpleLowPass':
        test_simpleLowPassFilter(img)
    elif args.filter == 'simpleHighPass':
        test_simpleHighPassFilter(img)
    else:
        filters = {'guassian': gaussianSpecturmFilter, 'mean':meanSpecturmFilter, 'laplacian':laplacianSpecturmFilter}
        test_general_filters(img, filters[args.filter], args.filter.upper())
    plt.show()
