function bwboundary_study()
I = imread('rice.png');%����ͼ��
BW = im2bw(I, graythresh(I));%ת����2����ͼ��
[B,L] = bwboundaries(BW,'noholes');%Ѱ�ұ�Ե����������
imshow(label2rgb(L, @jet, [.5 .5 .5]))%��ʾͼ��
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end%����ѭ����ʾ�������
end