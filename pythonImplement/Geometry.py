#! /usr/bin/env python
import numpy as np
from cv2 import cv2
import matplotlib.pyplot as plt
import math
import argparse
import logging
import numba as nb

logging.basicConfig(level=logging.INFO)

z = np.zeros(3, dtype=np.uint8)

# @nb.jit(cache=True)
@nb.jit
def biLinear(im, xt, yt):
    xbottom = math.floor(xt)
    xtop = xbottom + 1
    ybottom = math.floor(yt)
    ytop = ybottom + 1
    
    # 超出图片范围取0
    if xbottom >= im.shape[0] or ybottom >= im.shape[1] or xbottom < 0 or ybottom < 0:
        return z

    # 如果在边界上要退化成一维线性插值
    if xtop == im.shape[0] and ytop == im.shape[1]:
        return im[xtop - 1, ytop - 1]
    if xtop == im.shape[0]:
        return ((ytop - yt) * im[xbottom, ybottom] + (yt - ybottom) * im[xbottom, ytop]).astype(np.uint8)
    if ytop == im.shape[1]:
        return ((xtop - xt) * im[xbottom, ybottom] + (xt - xbottom) * im[xtop, ybottom]).astype(np.uint8)

    # 正常情况, 双线性插值
    return ((ytop - yt) * ((xtop - xt) * im[xbottom, ybottom] + (xt - xbottom) * im[xtop, ybottom]) + (yt - ybottom) * ((xtop - xt) * im[xbottom, ytop] + (xt - xbottom) * im[xtop, ytop])).astype(np.uint8)

# @nb.jit(cache=True)
@nb.jit
def nearest(im, xt, yt):
    xn = int(round(xt))
    yn = int(round(yt))
    if xn >= im.shape[0] or yn >= im.shape[1] or xn < 0 or yn < 0:
        return np.zeros(im.shape[2])
    else: 
        return im[xn, yn]


# @nb.jit(cache=True)
@nb.jit(cache=True)
def fillImageWithIndex(indices, scr, method='linear'):
    '''
    Arguments:
        indices -- 目标图像中每个像素在原图中的坐标
        src -- 原图 , ndim == 3
        method -- 插值方法, {linear, nearest}
    Returns:
        im_ret -- shape of (indices.shape[0], indices.shape[1] [, src.shape[2]])
    '''
    methods = {'linear':biLinear, 'nearest':nearest}
    if method in methods:
        interp = methods[method]
    else:
        raise TypeError("Interpolation Method wrong.")

    tx, ty, _ = indices.shape
    c = scr.shape[2]
    ret_im = np.zeros((tx, ty, c))
    for a in range(tx):
        for b in range(ty):
            ret_im[a, b] = interp(scr, indices[a, b, 0], indices[a, b, 1])

    return ret_im.astype(int)

def scaleImage(image, x_scale: 'float', y_scale: 'float'):
    sx, sy, _ = image.shape
    tx, ty = math.floor(sx * x_scale), math.floor(sy * y_scale)
    x = np.arange(tx)
    y = np.arange(ty)
    X, Y = np.meshgrid(x, y)

    X_idx = X.T / x_scale; Y_idx = Y.T / y_scale # 计算缩放后的横纵坐标

    indices = np.concatenate((np.expand_dims(X_idx, axis=2), np.expand_dims(Y_idx, axis=2)), axis=2)
    return fillImageWithIndex(indices, image, method='linear')

@nb.jit
# @nb.jit(nopython=True)
def rotateImage(image, theta):
    sx, sy, _ = image.shape
    # logging.debug('source image size {:d} * {:d}'.format(sx, sy))
    theta1 = theta / 180. * np.pi
    W = np.array([[np.cos(theta1), -np.sin(theta1)],
              [np.sin(theta1), np.cos(theta1)]]) # 旋转矩阵
    
    # 确定新图尺寸
    corners = np.array([[0, 0, sx, sx],
            [0, sy, 0, sy]], dtype=np.float64) # 原始角点坐标

    rCorner = W.dot(corners) # 旋转后的角点坐标 matrix
    tSize = np.around(np.max(rCorner, axis=1) - np.min(rCorner, axis=1)).astype(int) # 确定新图尺寸
    # logging.debug('target image size {} * {}'.format(tSize[0,0], tSize[1,0]))
    x = np.arange(tSize[0])
    y = np.arange(tSize[1])
    X, Y = np.meshgrid(x, y) # 注意meshgrid得到的(X, Y)的顺序

    # 坐标反向旋转
    indices = np.vstack((X.flatten(), Y.flatten())) # 构造index矩阵, 原点坐标
    indices = indices - tSize[:,np.newaxis] /2 # 中心坐标
    indices = np.linalg.inv(W).dot(indices)  # 反向旋转, 中心坐标
    indices = indices + np.array([[sx], [sy]]) / 2 # 原点坐标

    indices = np.reshape(indices.T, (tSize[0], tSize[1], -1), 'F') # 采用Fortran格式的reshape是由于meshgrid得到的结果是按列遍历的
    # logging.debug("Indices shape: {}".format(indices.shape))
    
    return fillImageWithIndex(indices, image, method='linear')


def plotRGBChannel(src):
    plt.figure()
    plt.subplot(131)
    plt.imshow(src[:, :, 0])
    plt.subplot(132)
    plt.imshow(src[:, :, 1])
    plt.subplot(133)
    plt.imshow(src[:, :, 2])


def testRotateImage():
    im = np.ones((5,10)).reshape(5, 10, 1)
    im_op = rotateImage(im, 0)
    plt.figure()
    plt.imshow(im_op)
    im_op = rotateImage(im, 30)
    plt.imshow(im_op)
    im_op = rotateImage(im, 45)
    plt.imshow(im_op)
    im_op = rotateImage(im, 90)
    plt.imshow(im_op)
    im_op = rotateImage(im, 180)
    plt.imshow(im_op)
    im_op = rotateImage(im, -60)
    plt.imshow(im_op)
    plt.show()

def testScaleImage():
    im = np.array([[1, 2], [3, 4]]).reshape(2, 2, 1)
    im_scale = scaleImage(im, 2, 2)
    print(im_scale.squeeze())

def testbiLinear():
    im = np.array([[10,50],[100, 150]])
    print(biLinear(im, 0, 0))
    print(biLinear(im, 1, 1))
    print(biLinear(im, 0, 1))
    print(biLinear(im, 1, 0))
    print(biLinear(im, 0.5, 0))
    print(biLinear(im, 0.5, 0.5))
    print(biLinear(im, 0, 0.5))


'''
## Geometry.py 几何变换

功能: 对图像进行旋转, 缩放

使用方法
```bash
python Geometry.py -f [Image path] -t rotate --theta [angle]
python Geometry.py -f [Image path] -t scale --xscale [scale] --yscale [scale]

# 旋转
python Geometry.py -f ../test_images/camera.tiff -t 'rotate' --theta 45
# 缩放
python Geometry.py -f ../test_images/camera.tiff -t scale --xscale 1.5 --yscale 2
```
'''

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-f", "--file", required=True,
                        help="Image File to operate.")
    parser.add_argument("-t", "--task", choices=['rotate', 'scale'], required=True, help="Task to do on Image.")
    parser.add_argument("--theta", type=float, help="Angle to rotate.[0, 360]")
    parser.add_argument("--xscale", type=float, help="Scale of X axis.")
    parser.add_argument("--yscale", type=float, help="Scale of Y axis.")
    args = parser.parse_args()

    if args.task == 'rotate':
        if args.theta is None:
            raise Exception("Angle is not given in Rotate task.")
    else:
        if args.xscale is None or args.yscale is None:
            raise Exception("scale Argument aren't given in Scale task.")

    im = cv2.imread(args.file)
    im = cv2.cvtColor(im,cv2.COLOR_BGR2RGB)
    if im.ndim == 2:
        im = np.expand_dims(im, 2)
    if args.task == 'rotate':
        im_op = rotateImage(im, args.theta)
    else:
        im_op = scaleImage(im, args.xscale, args.yscale)

    plt.figure()
    plt.imshow(im_op)
    plt.show()
