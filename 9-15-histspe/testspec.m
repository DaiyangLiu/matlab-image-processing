% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % 直方图规定化（直方图匹配）的具体代码
% % % 
%     [value,index] = min(x) min返回最小值及其对应的下标
% % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
clc;
clear;
close all;
% % % % % % % % % %读入原始图 % % % % % % % % % % % % % % 
orgin = imread('Boston.jpg');
orgin=rgb2gray(orgin);           
[m_o,n_o]=size(orgin);

% imshit函数返回的是灰度图的各灰度出现的次数组成的矩阵是num*1的矩阵
% 在除以像素总数之后就变成各灰度的出现【频率】
orgin_hist=imhist(orgin)/(m_o*n_o);

% % % % % % % % % % 读入标准图% % % % % % % % % % % % % % % % % % 
standard = imread('Boston2.jpg');
% standard=rgb2gray(standard);  
[m_s,n_s]=size(standard);
standard_hist=imhist(standard)/(m_s*n_s);

% 求累计频率
startdard_value = cumsum(standard_hist)';
orgin_value = cumsum(orgin_hist)';

% 下面的for循环主要是将原始图像中灰度映射到标准图的灰度上去
% index的下标代表的是原始图的灰度，值代表映射到标准图上的灰度
for i=1:256
%     将原始图中的各累积频率匹配到标准图中最接近的累积频率上去
% 标准图直方图累积频率同时减去原始图中一个累积频率
% 每个cell内容纳一个矩阵同orgin_value一样尺寸
    value{i}=startdard_value-orgin_value(i);
    value{i}=abs(value{i});

% 找到原始图中累积频率最接近标准图的累积频率的值和下标
% 并将下标i存到矩阵index中即index(i)
    [temp, index(i)]=min(value{i});
end

newimg=zeros(m_o,n_o);
% 因为index元素下标从1始
for i=1:m_o
    for j=1:n_o
        newimg(i,j)=index(orgin(i,j)+1)-1;
    end
end

newimg=uint8(newimg);
% 显示图像
subplot(2,3,1);imshow(orgin);title('原图');
subplot(2,3,2);imshow(standard);title('标准图');
subplot(2,3,3);imshow(newimg);title('myself匹配到标准图');

% 显示灰度直方图
subplot(2,3,4);imhist(orgin);title('原图');
subplot(2,3,5);imhist(standard);title('标准图');
subplot(2,3,6);imhist(newimg);title('直方图匹配到标准图');
