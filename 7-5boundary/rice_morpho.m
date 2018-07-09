function rice_morpho()
I=imread('rice.png');
imshow(I);
BW = im2bw(I, graythresh(I));
figure,imshow(BW);
SE = strel('disk',2);%用于膨胀腐蚀及开闭运算等操作的结构元素对象
%对图像实现开运算，开运算一般能平滑图像的轮廓，消弱狭窄的部分，去掉细的突出。
L = imopen(I,SE);
figure,imshow(L);
LBW = im2bw(L, graythresh(I));
figure,imshow(LBW);
end