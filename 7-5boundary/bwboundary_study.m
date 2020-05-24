function bwboundary_study()
I = imread('rice.png');%读入图像
BW = im2bw(I, graythresh(I));%转换成2进制图像
[B,L] = bwboundaries(BW,'noholes');%寻找边缘，不包括孔
imshow(label2rgb(L, @jet, [.5 .5 .5]))%显示图像
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end%整个循环表示的是描边
end