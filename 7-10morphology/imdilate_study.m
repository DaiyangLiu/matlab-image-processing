function imdilate_study()
%���� imdilate��dilate=����/����
clc 
clear
A1=imread('DIP3E_CH09_Original_Images\DIP3E_Original_Images_CH09\Fig0907(a)(text_gaps_1_and_2_pixels).tif');
info=imfinfo('DIP3E_CH09_Original_Images\DIP3E_Original_Images_CH09\Fig0907(a)(text_gaps_1_and_2_pixels).tif');
B=[0 1 0
1 1 1
0 1 0];
A2=imdilate(A1,B);%ͼ��A1���ṹԪ��B����
A3=imdilate(A2,B);
A4=imdilate(A3,B);
subplot(221),imshow(A1);
title('imdilate����ԭʼͼ��');
subplot(222),imshow(A2);
title('ʹ��B��1�����ͺ��ͼ��');
subplot(223),imshow(A3);
title('ʹ��B��2�����ͺ��ͼ��');
subplot(224),imshow(A4);
title('ʹ��B��3�����ͺ��ͼ��');
end