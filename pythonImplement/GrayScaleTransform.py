#! /usr/bin/env python
'''
## GrayScaleTranform.py 灰度变换
功能: 图像均衡化, 规定化
使用方法:
**均衡化**
```
python GrayScaleTransform.py -t equal -f [Image path]
python GrayScaleTransform.py -t equal -f ../test_images/camera.tiff
```

**规定化**
```
python GrayScaleTransform.py -t normal -f [Source Image path] --file_tar [Target Image path]
python GrayScaleTransform.py -t normal -f ../test_images/lax.tiff --file_tar ../test_images/camera.tiff
```

'''

import matplotlib as mpl
from cv2 import cv2
import argparse
import os
import numpy as np
import matplotlib.pyplot as plt
import numba as nb

# 解决mpl中文乱码, 首先在site-package/matplotlib/mlp-data/fonts/ttf/ 添加字体文件
plt.rcParams['font.sans-serif'] = ['SimHei']
plt.rcParams['font.serif'] = ['SimHei']
plt.rcParams['axes.unicode_minus'] = False


@nb.jit
def img2hist(image:np.ndarray) -> np.ndarray:
    '''
    Generate histogram of image.
    Return:
        grayScaleHist -- A np.array of (256, channels)
    '''
    w, h, c = image.shape
    grayScaleHist = np.zeros((256,c))
    image = image.reshape(w*h,c) 
    for k in range(c):
        for i in image[:, k]:
            grayScaleHist[i, k] += 1
    return grayScaleHist


def plotHist(grayHist:np.ndarray, title=None):
    '''
    Plot histogram from the hist array.
    '''
    assert(grayHist.shape[1]==3)
    plt.figure()
    plt.bar(np.arange(256), grayHist[:,0], color='r', width=1)
    plt.bar(np.arange(256), grayHist[:,1], color='g', width=1)
    plt.bar(np.arange(256), grayHist[:,2], color='b', width=1)
    plt.axis([0, 255, 0, np.max(grayHist)])
    if not title is None:
        plt.title(title)


def grayMap(hist:np.ndarray) -> np.ndarray:
    '''
    Generate a map from grayscale to grayscale with the following function.
    f(g) -> P(g)*255
    Returns:
        grayMap -- np.array of the same shape with hist
    TODO: 彩色图像做grapMap后不会失真么
    '''
    cumsum = np.cumsum(hist, 0)
    grayMap = cumsum / cumsum[-1, :]
    grayMap = (grayMap * 255).round().astype(int)
    return grayMap

def equalization(img: np.ndarray) -> np.ndarray:
    '''
    Do equalization on image.
    '''
    hist = img2hist(img)
    gmap = grayMap(hist)
    img2 = applyGrayMap(gmap, img)
    return img2
    

@nb.jit(nopython=False, forceobj=True)
def normalization(img_src, img_tar):
    '''
    Do normalization on img_tar with the grayMap generated from img_src.
    '''
    hist_src = img2hist(img_src)
    hist_tar = img2hist(img_tar)
    gm_src = grayMap(hist_src)
    gm_tar = grayMap(hist_tar)
    diff = np.zeros((256,256, 3))
    for i in range(256):
        for j in range(256):
            diff[i][j] = np.abs(gm_tar[j] - gm_src[i]) # diff[i][j] 是src中i灰度值的累计概率与tar中i灰度值累计概率的差值
    gmap = np.argmin(diff, axis=0) # 查找累计概率相差最小的灰度值作为映射结果
    return applyGrayMap(gmap, img_tar)

    
@nb.jit
def applyGrayMap(gmap, img):
    '''
    Apply a grayMap on the img.
    '''
    img2 = np.zeros(img.shape, dtype=np.uint8)
    w, h, c = img.shape
    for i in range(w):
        for j in range(h):
            for k in range(c):
                img2[i, j, k] = gmap[img[i, j, k], k]
    return img2


def testGrayMap(im):
    hist = img2hist(im)
    gmap = grayMap(hist)
    plt.figure()
    plt.plot(np.arange(256), gmap[:, 0])


def testNormalization():
    im_src = cv2.imread('../test_images/lax.tiff')
    im_src = cv2.cvtColor(im_src, cv2.COLOR_BGR2RGB)
    im_tar = cv2.imread('../test_images/camera.tiff')
    im_tar = cv2.cvtColor(im_tar, cv2.COLOR_BGR2RGB)
    im_out = normalization(im_src, im_tar)
    plt.figure()
    plt.imshow(im_src)
    plt.figure()
    plt.imshow(im_out)
    hist_src = img2hist(im_src)
    hist_out = img2hist(im_out)
    plotHist(hist_src)
    plotHist(hist_out)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--task', '-t', choices=['equal', 'normal'], required=True, help='Task to do on image.')
    parser.add_argument('--file_src', '-f', required=True, help='File to operate in equal or File to generate Map in normal')
    parser.add_argument('--file_tar', help='Needed in normal task. File to apply.')
    args = parser.parse_args()
    if not os.path.exists(args.file_src):
        raise FileNotFoundError('{} not find.'.format(args.file_src))
    im_src = cv2.imread(args.file_src)
    im_src = cv2.cvtColor(im_src, cv2.COLOR_BGR2RGB)
    if args.task == 'equal':
        im_out = equalization(im_src)
        hist1 = img2hist(im_src)
        hist2 = img2hist(im_out)
        plotHist(hist1, '原图')
        plotHist(hist2, '均衡化后')
        plt.figure()
        plt.imshow(im_out)
    else:
        if not os.path.exists(args.file_tar):
            raise FileNotFoundError('{} not find.'.format(args.file_tar))
        im_tar = cv2.imread(args.file_tar)
        im_tar = cv2.cvtColor(im_tar, cv2.COLOR_BGR2RGB)
        hist_src = img2hist(im_src)
        hist = img2hist(im_tar)
        im_out = normalization(im_src, im_tar)
        hist_out = img2hist(im_out)
        plotHist(hist, '原图')
        plotHist(hist_out, '规定化后')
        plotHist(hist_src, '用于规定化的source image')
        plt.figure()
        plt.imshow(im_tar)
        plt.figure()
        plt.imshow(im_out)
    plt.show()
