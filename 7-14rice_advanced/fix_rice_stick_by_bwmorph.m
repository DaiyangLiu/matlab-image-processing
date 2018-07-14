function tag=fix_rice_stick_by_bwmorph()
I = imread('rice.png');
[width,height] = size(I);
BW=im2bw(I);


J = edge(BW,'canny');
%figure,imshow(J);
K = imfill(J,'holes');
%figure,imshow(K);
SE = strel('disk',3);%用于膨胀腐蚀及开闭运算等操作的结构元素对象
%对图像实现开运算，开运算一般能平滑图像的轮廓，消弱狭窄的部分，去掉细的突出。
BW1 = imopen(K,SE);

BW2=bwmorph(BW1,'thin',Inf);
%figure,imshow(BW2);

BW3=bwmorph(BW2,'branch');
figure,imshow(BW3);

%imtool(BW3);

%以BW3上的白点为圆心，在I（或 BW）上画圆
%figure,imshow(BW);
%annotation('doublearrow',[0.2 0.8],[0.85 0.85],'LineStyle','-','color',[1 0 0],'HeadStyle','cback3');
%绘图失败
tag=0;
for i=1:width
    for j=1:height
        if BW3(i,j)==1
           tag=tag+1;
        end
    end
end
disp('米粒的粘连个数:')
tag
end