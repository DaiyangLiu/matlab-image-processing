'''
## connectedRegion.py

功能: 对二值化图片进行联通区域标记
```bash
python connectedRegion.py -f [Image Path] -n [neighborhood Size]
python connectedRegion.py -f ../test_images/rice-bw.png -n 4
```
'''

import cv2.cv2 as cv2
from matplotlib import pyplot as plt
from collections import deque
import numpy as np
from pprint import pprint
import argparse
def find_connect(graph, bigger_neighborhood=False):
    region_cnt = 0 # increase when encounter a 1 pixel
    w, h = graph.shape
    graph = graph.tolist()
    visited = [False for i in range(w * h)]
    indices = [[0 for i in range(w)] for j in range(h)]
    ptr = 0
    for ptr in range(w * h):
        if not visited[ptr]:
            visited[ptr] = True
            if graph[ptr//w][ptr%w] == 1: # Find new connection
                region_cnt += 1
                queue = deque([ptr])
                while len(queue) != 0: # bfs
                    index = queue.pop()
                    indices[index//w][index%w] = region_cnt
                    neighbors = collect_neighbors(index, w, h, bigger_neighborhood)
                    for neighbor in neighbors:
                        if not visited[neighbor]:
                            visited[neighbor] = True
                            if graph[neighbor//w][neighbor%w] == 1:
                                queue.appendleft(neighbor)
    return indices, region_cnt

                    

def collect_neighbors(index, width, height, bigger_neighborhood):
    size = width * height
    neighbors = []
    if index - width >= 0:
        up = True
        neighbors.append(index-width)
    if index + width < size:
        down = True
        neighbors.append(index+width)
    if index % width > 0:
        left = True
        neighbors.append(index-1)
    if index % width < width - 1:
        right = True
        neighbors.append(index+1)
    if bigger_neighborhood:
        if up and left: neighbors.append(index - width - 1)
        if up and right: neighbors.append(index - width + 1)
        if down and left: neighbors.append(index + width - 1)
        if down and right: neighbors.append(index + width + 1)
    return neighbors

def test_find_connect():
    graph = np.zeros((10, 10), dtype=np.int)
    graph[3:5, 3:5] = 1
    graph[7:8, 3:9] = 1
    graph[4:7, 0] = 1
    indices = find_connect(graph)
    pprint(indices)


def get_colormap(count):
    colormap = {}
    colormap[0] = np.zeros((3), dtype=np.int)
    for i in range(count):
        colormap[i+1] = np.random.randint(256, size=3)
    return colormap


def rend_result(indices, cnt):
    colormap = get_colormap(cnt)
    w, h = indices.shape
    img = np.zeros((w, h, 3), dtype=np.uint8)
    for i in range(w):
        for j in range(h):
            img[i, j] = colormap[indices[i, j]]
    return img


if __name__ == '__main__':
    parser = argparse.ArgumentParser('Mark connected regions.')
    parser.add_argument('--file', '-f', required=True, help='Filepath of an image which has been binarized.')
    parser.add_argument('-n', choices=['8', '4'], default='4')
    args = parser.parse_args()
    im = cv2.imread(args.file, 0)
    _, graph = cv2.threshold(im, 127, 255, cv2.THRESH_BINARY)
    graph[graph > 0] = 1
    bigger_neighborhood = True if args.n == '8' else False
    indices, cnt= find_connect(graph, bigger_neighborhood) # neighbor is 4 if False and is 8 if True
    indices = np.array(indices)
    img_result = rend_result(indices, cnt)
    plt.imshow(img_result)
    plt.title('count = {}'.format(cnt))
    plt.show()
