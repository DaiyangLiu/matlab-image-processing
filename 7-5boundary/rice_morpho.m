function rice_morpho()
I=imread('rice.png');
imshow(I);
BW = im2bw(I, graythresh(I));
figure,imshow(BW);
SE = strel('disk',2);%�������͸�ʴ����������Ȳ����ĽṹԪ�ض���
%��ͼ��ʵ�ֿ����㣬������һ����ƽ��ͼ���������������խ�Ĳ��֣�ȥ��ϸ��ͻ����
L = imopen(I,SE);
figure,imshow(L);
LBW = im2bw(L, graythresh(I));
figure,imshow(LBW);
end