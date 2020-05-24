% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % ֱ��ͼ�涨����ֱ��ͼƥ�䣩�ľ������
% % % 
%     [value,index] = min(x) min������Сֵ�����Ӧ���±�
% % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
clc;
clear;
close all;
% % % % % % % % % %����ԭʼͼ % % % % % % % % % % % % % % 
orgin = imread('Boston.jpg');
orgin=rgb2gray(orgin);           
[m_o,n_o]=size(orgin);

% imshit�������ص��ǻҶ�ͼ�ĸ��Ҷȳ��ֵĴ�����ɵľ�����num*1�ľ���
% �ڳ�����������֮��ͱ�ɸ��Ҷȵĳ��֡�Ƶ�ʡ�
orgin_hist=imhist(orgin)/(m_o*n_o);

% % % % % % % % % % �����׼ͼ% % % % % % % % % % % % % % % % % % 
standard = imread('Boston2.jpg');
% standard=rgb2gray(standard);  
[m_s,n_s]=size(standard);
standard_hist=imhist(standard)/(m_s*n_s);

% ���ۼ�Ƶ��
startdard_value = cumsum(standard_hist)';
orgin_value = cumsum(orgin_hist)';

% �����forѭ����Ҫ�ǽ�ԭʼͼ���лҶ�ӳ�䵽��׼ͼ�ĻҶ���ȥ
% index���±�������ԭʼͼ�ĻҶȣ�ֵ����ӳ�䵽��׼ͼ�ϵĻҶ�
for i=1:256
%     ��ԭʼͼ�еĸ��ۻ�Ƶ��ƥ�䵽��׼ͼ����ӽ����ۻ�Ƶ����ȥ
% ��׼ͼֱ��ͼ�ۻ�Ƶ��ͬʱ��ȥԭʼͼ��һ���ۻ�Ƶ��
% ÿ��cell������һ������ͬorgin_valueһ���ߴ�
    value{i}=startdard_value-orgin_value(i);
    value{i}=abs(value{i});

% �ҵ�ԭʼͼ���ۻ�Ƶ����ӽ���׼ͼ���ۻ�Ƶ�ʵ�ֵ���±�
% �����±�i�浽����index�м�index(i)
    [temp, index(i)]=min(value{i});
end

newimg=zeros(m_o,n_o);
% ��ΪindexԪ���±��1ʼ
for i=1:m_o
    for j=1:n_o
        newimg(i,j)=index(orgin(i,j)+1)-1;
    end
end

newimg=uint8(newimg);
% ��ʾͼ��
subplot(2,3,1);imshow(orgin);title('ԭͼ');
subplot(2,3,2);imshow(standard);title('��׼ͼ');
subplot(2,3,3);imshow(newimg);title('myselfƥ�䵽��׼ͼ');

% ��ʾ�Ҷ�ֱ��ͼ
subplot(2,3,4);imhist(orgin);title('ԭͼ');
subplot(2,3,5);imhist(standard);title('��׼ͼ');
subplot(2,3,6);imhist(newimg);title('ֱ��ͼƥ�䵽��׼ͼ');
