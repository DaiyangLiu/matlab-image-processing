function imerode_study()
%��ʴ imerode(erode=��ʴ����ʴ)
clc
clear
A1=imread('DIP3E_CH09_Original_Images\DIP3E_Original_Images_CH09\Fig0905(a)(wirebond-mask).tif');
subplot(221),imshow(A1);
title('��ʴԭʼͼ��');

%strel�����Ĺ��������ø�����״�ʹ�С����ṹԪ��
se1=strel('disk',5);%�����Ǵ���һ���뾶Ϊ5��ƽ̹��Բ�̽ṹԪ��
A2=imerode(A1,se1);
subplot(222),imshow(A2);
title('ʹ�ýṹԭʼdisk(5)��ʴ���ͼ��');
se2=strel('disk',10);
A3=imerode(A1,se2);
subplot(223),imshow(A3);
title('ʹ�ýṹԭʼdisk(10)��ʴ���ͼ��');
se3=strel('disk',20);
A4=imerode(A1,se3);
subplot(224),imshow(A4);
title('ʹ�ýṹԭʼdisk(20)��ʴ���ͼ��');
end