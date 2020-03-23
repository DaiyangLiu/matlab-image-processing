import numpy as np 
from cv2 import cv2
from pprint import pprint
from connectedRegion import find_connect
from matplotlib import pyplot as plt
import argparse

'''
3 2 1
4 x 0
5 6 7
'''
directs = [(0, 1), (-1, 1), (-1, 0), (-1, -1),
           (0, -1), (1, -1), (1, 0), (1, 1)]



def getBoundary(graph, region_id):
    '''
    Get the boundary of connected region of region_id from graph

    Args:
        graph -- np.array 2dims
        region_id 1 - cnt
    Returns:
        chain -- list, sequence containing the coordinate of chain points with the formate (i, j)
    '''
    w, h = graph.shape
    graph = graph.tolist()
    chain = []
    # 找到第一个点
    b0 = find_first(graph, region_id)
    if b0 == (h, w):
        return chain
    dir0 = 4 # TODO too stupid
    c0 = neighbor(b0, dir0)
    b = b0
    c = c0
    dir = dir0 - 2
    # 顺时针旋转 找到下一个边节点, 加入chain 并移动到它
    while not (b == b0 and dir == dir0-1): 
        # dir == dir0 - 1的结束条件总能够保证转一圈能够停, 不然因为存在奇偶跳的不一样的问题 导致循环无法结束
        chain.append(b)
        # print(b)
        if b == b0: # 只有第一个点需要特地检查是否转到一个圈, 如果是递归写法就不需要?
            b, c, dir = traverse(graph, region_id, b, c, dir, dir0-1)
        else:
            b, c, dir = traverse(graph, region_id, b, c, dir)
    return chain


def find_first(graph, index):
    '''
    Find the first point in graph of given index.
    Args:
        graph -- list of list 2 dims.
        index -- int
    Returns:
        coor of point
    '''
    h = len(graph)
    w = len(graph[0])
    for i in range(h):
        for j in range(w):
            if graph[i][j] == index:
                return (i, j)
    return (h, w)

def traverse(graph, region_index, b, c, dir, dir_end=None):
    candidate = neighbor(b, dir)
    while candidate != c and dir != dir_end:
        if graph[candidate[0]][candidate[1]] == region_index:
            c = neighbor(b, (dir + 9) % 8)
            if dir % 2 == 0:
                dir = (dir + 1) % 8
            else:
                dir = (dir + 2) % 8
            return candidate, c, dir
        else:
            dir = (dir + 7) % 8
            candidate = neighbor(b, dir)
    
    return b, c, dir

def neighbor(index, direct):
    '''
    Return the coordinate of the neighbor of index at given direct.
    Args:
        index -- coor (i, j)
        direct -- index of directs
    Returns:
        ret -- coor
    '''
    ret = (index[0] + directs[direct][0], index[1] + directs[direct][1])
    if ret[0] < 0 or ret[1] < 0:
        raise ValueError
    return ret


def padding_graph(graph):
    '''
    Pad 0 on border of graph since the bournday need to be close (surrounding by 0)
    '''
    w, h = graph.shape
    new_graph = np.zeros((w+2, h+2), dtype=np.uint8)
    new_graph[1:-1, 1:-1] = graph
    return new_graph


def test_boundaryChain():
    graph = np.zeros((10, 10), dtype=np.int)
    graph[3:5, 3:5] = 1
    graph[2, 2:6] = 1
    graph[5, 4:6] = 1
    graph[6, 5:8] = 1
    boundaryChain = getBoundary(graph, 1)
    print(boundaryChain)


'''
## boundaryTrack.py 边界追踪

功能: 对二值化图像进行多元素边界追踪

```bash
python boundaryTrack.py -f [Image path]
python boundaryTrack.py -f ../test_images/rice-bw.png
```
'''

if __name__ == '__main__':
    parser = argparse.ArgumentParser('Multi-elements boundary track.')
    parser.add_argument('--file', '-f', required=True,
                        help='Filepath of an image which has been binarized.')
    args = parser.parse_args()
    im = cv2.imread(args.file, 0)
    _, graph = cv2.threshold(im, 127, 255, cv2.THRESH_BINARY)
    graph[graph > 0] = 1
    indices, cnt = find_connect(graph) # First find connected regions
    indices = np.array(indices)
    indices = padding_graph(indices)
    chains = []
    plt.subplot(121)
    plt.axis('equal')
    for id in range(1, cnt+1): # find boundary of connected region by index
        chain = getBoundary(indices, id)
        chains.append(chain)
    for chain in chains:
        chain = np.array(chain)
        
        plt.plot(chain[:, 1], chain[:, 0], color=np.random.rand(3))
    ax = plt.gca()
    ax.invert_yaxis()
    plt.subplot(122)
    plt.imshow(im, cmap='gray')
    plt.axis('equal')
    plt.show()

