function hit_miss_study()
%���л����б任
%�����ԭ��Ϊ��(����XΪԭ��ֵ��ͼ������ؼ��ϣ���Xȡ�����~X(��X�� Y��ʾ), ѡ
%��ĽṹԪΪs1, �ԽṹԪs1ȡ���ĽṹԪΪs2)
%���ȶ���s1��X���и�ʴ�õ�A1,�� ��s2��Y(��~X)���и�ʴ�õ�A2��
%���ս��C = A1 & A2��
clc
clear
f=imread('DIP3E_CH09_Original_Images\DIP3E_Original_Images_CH09\FigP0918(left).tif');
imshow(f);
title('���л򲻻���ԭʼͼ��');
B1=strel([0 0 0;0 1 1;0 1 0]);%���У�Ҫ���������1��λ��
B2=strel([1 1 1;1 0 0;1 0 0]);%�����У�Ҫ�����������1��λ��
B3=strel([0 1 0;1 1 1;0 1 0]);%����
B4=strel([1 0 1;0 0 0;0 0 0]);%������
B5=strel([0 0 0;0 1 0;0 0 0]);%����
B6=strel([1 1 1;1 0 0;1 0 0]);%������
g=imerode(f,B1)&imerode(~f,B2)%���ö�����ʵ�ֻ��л������
figure,subplot(221),imshow(g);
title('����ʵ����1���л�����ͼ��');
g1=bwhitmiss(f,B1,B2);
subplot(222),imshow(g1);
title('�ṹ����1���л����к��ͼ��');
g2=bwhitmiss(f,B3,B4);
subplot(223),imshow(g2);
title('�ṹ����2���л����е�ͼ��');
g3=bwhitmiss(f,B5,B6);
subplot(224),imshow(g3);
title('�ṹ����3���л����е�ͼ��');
end