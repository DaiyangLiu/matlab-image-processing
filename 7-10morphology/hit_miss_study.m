function hit_miss_study()
%击中击不中变换
%其基本原理为：(集合X为原二值化图像的像素集合，对X取反求得~X(非X， Y表示), 选
%择的结构元为s1, 对结构元s1取反的结构元为s2)
%首先对用s1对X进行腐蚀得到A1,， 用s2对Y(即~X)进行腐蚀得到A2。
%最终结果C = A1 & A2。
clc
clear
f=imread('DIP3E_CH09_Original_Images\DIP3E_Original_Images_CH09\FigP0918(left).tif');
imshow(f);
title('击中或不击中原始图像');
B1=strel([0 0 0;0 1 1;0 1 0]);%击中：要求击中所有1的位置
B2=strel([1 1 1;1 0 0;1 0 0]);%击不中，要求击不中所有1的位置
B3=strel([0 1 0;1 1 1;0 1 0]);%击中
B4=strel([1 0 1;0 0 0;0 0 0]);%击不中
B5=strel([0 0 0;0 1 0;0 0 0]);%击中
B6=strel([1 1 1;1 0 0;1 0 0]);%击不中
g=imerode(f,B1)&imerode(~f,B2)%利用定义来实现击中或击不中
figure,subplot(221),imshow(g);
title('定义实现组1击中击不中图像');
g1=bwhitmiss(f,B1,B2);
subplot(222),imshow(g1);
title('结构数组1击中击不中后的图像');
g2=bwhitmiss(f,B3,B4);
subplot(223),imshow(g2);
title('结构数组2击中击不中的图像');
g3=bwhitmiss(f,B5,B6);
subplot(224),imshow(g3);
title('结构数组3击中击不中的图像');
end