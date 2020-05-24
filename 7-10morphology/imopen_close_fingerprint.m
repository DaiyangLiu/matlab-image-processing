function imopen_close_fingerprint()
%腐蚀与开闭运算在指纹图像上的应用对比
clc
clear
f=imread('DIP3E_CH09_Original_Images\DIP3E_Original_Images_CH09\Fig0911(a)(noisy_fingerprint).tif');

subplot(121),imshow(f);
title('指纹原始图像');

se=strel('square',3);%边长为3的方形结构元素
A=imerode(f,se);%腐蚀
subplot(122),imshow(A);
title('腐蚀后的指纹原始图像');


fo=imopen(f,se);
figure,subplot(221),imshow(fo);
title('使用square(3)开操作后的图像');


fc=imclose(f,se);
subplot(222),imshow(fc);
title('使用square闭操作后的图像');

foc=imclose(fo,se);
subplot(223),imshow(foc);
title('使用square(3)先开后闭操作后的图像')

fco=imopen(fc,se);
subplot(224),imshow(fco);
title('使用square(3)先闭后开操作后的图像');
end