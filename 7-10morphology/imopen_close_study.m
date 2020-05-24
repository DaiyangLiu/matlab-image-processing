function imopen_close_study()
%开运算和闭运算
clc
clear
f=imread('DIP3E_CH09_Original_Images\DIP3E_Original_Images_CH09\FigP0917(noisy_rectangle).tif');
%se=strel('square',10');%方型结构元素
se=strel('disk',20');%圆盘型结构元素
imshow(f);%原图像
title('开闭运算原始图像');


%开运算数学上是先腐蚀后膨胀的结果 %开运算的物理结果为完全删除了不能包含结构元素的对象区域，平滑
%了对象的轮廓，断开了狭窄的连接，去掉了细小的突出部分
fo=imopen(f,se);%直接开运算
figure,subplot(221),imshow(fo);
title('直接开运算');



%闭运算在数学上是先膨胀再腐蚀的结果
%闭运算的物理结果也是会平滑对象的轮廓，但是与开运算不同的是，闭运算
%一般会将狭窄的缺口连接起来形成细长的弯口，并填充比结构元素小的洞
fc=imclose(f,se);%直接闭运算
subplot(222),imshow(fc);
title('直接闭运算');

foc=imclose(fo,se);%先开后闭运算
subplot(223),imshow(foc);
title('先开后闭运算');
fco=imopen(fc,se);%先闭后开运算
subplot(224),imshow(fco);
title('先闭后开运算');
end