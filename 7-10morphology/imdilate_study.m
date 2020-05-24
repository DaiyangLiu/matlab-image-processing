function imdilate_study()
%膨胀 imdilate（dilate=膨胀/扩大）
clc 
clear
A1=imread('DIP3E_CH09_Original_Images\DIP3E_Original_Images_CH09\Fig0907(a)(text_gaps_1_and_2_pixels).tif');
info=imfinfo('DIP3E_CH09_Original_Images\DIP3E_Original_Images_CH09\Fig0907(a)(text_gaps_1_and_2_pixels).tif');
B=[0 1 0
1 1 1
0 1 0];
A2=imdilate(A1,B);%图像A1被结构元素B膨胀
A3=imdilate(A2,B);
A4=imdilate(A3,B);
subplot(221),imshow(A1);
title('imdilate膨胀原始图像');
subplot(222),imshow(A2);
title('使用B后1次膨胀后的图像');
subplot(223),imshow(A3);
title('使用B后2次膨胀后的图像');
subplot(224),imshow(A4);
title('使用B后3次膨胀后的图像');
end