function imerode_study()
%腐蚀 imerode(erode=腐蚀、侵蚀)
clc
clear
A1=imread('DIP3E_CH09_Original_Images\DIP3E_Original_Images_CH09\Fig0905(a)(wirebond-mask).tif');
subplot(221),imshow(A1);
title('腐蚀原始图像');

%strel函数的功能是运用各种形状和大小构造结构元素
se1=strel('disk',5);%这里是创建一个半径为5的平坦型圆盘结构元素
A2=imerode(A1,se1);
subplot(222),imshow(A2);
title('使用结构原始disk(5)腐蚀后的图像');
se2=strel('disk',10);
A3=imerode(A1,se2);
subplot(223),imshow(A3);
title('使用结构原始disk(10)腐蚀后的图像');
se3=strel('disk',20);
A4=imerode(A1,se3);
subplot(224),imshow(A4);
title('使用结构原始disk(20)腐蚀后的图像');
end