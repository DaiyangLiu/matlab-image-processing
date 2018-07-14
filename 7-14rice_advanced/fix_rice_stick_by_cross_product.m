function fix_rice_stick_by_cross_product()
I = imread('rice.png');%读入图像

%直接处理边缘吧
%不考虑用for循环判断边缘的方式了
J = edge(I,'canny');
%figure,imshow(J);
K = imfill(J,'holes');
%figure,imshow(K);
SE = strel('disk',3);%用于膨胀腐蚀及开闭运算等操作的结构元素对象
%对图像实现开运算，开运算一般能平滑图像的轮廓，消弱狭窄的部分，去掉细的突出。
L0 = imopen(K,SE);
L0=uint8(L0);
figure,imshow(L0);

BW = im2bw(L0, graythresh(L0));%转换成2进制图像

[B,L] = bwboundaries(BW,'noholes');%寻找边缘，不包括孔

imshow(label2rgb(L, @jet, [.5 .5 .5]))%显示图像
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end%整个循环表示的是描边

%遍历B
stick_tag=0;
for k = 1:length(B)
   boundary = B{k};
   [row col]=size(boundary);
   %if row<70 %观察米粒数据集可发现，正常的米粒的边界像素都小于70
    %   continue;
   %end
   %叉乘检测
   step=15;
   for i=1:row
      if (i+2*step)<=row
          %[ay,ax]=boundary(i,:); 
          ay=boundary(i,1);
          ax=boundary(i,2);
          %[by,bx]=boundary(i+step,:); 
          by=boundary(i+step,1);
          bx=boundary(i+step,2);
          %[cy,cx]=boundary(i+2*step,:); 
          cy=boundary(i+2*step,1);
          cx=boundary(i+2*step,2);
                 
          a=[bx-ax ,by-ay ];
          b=[cx-bx ,cy-by ];
          
          a=a/sqrt((bx-ax)^2+(by-ay )^2 );
          b=b/sqrt((cx-bx)^2+(cy-by )^2 );
          
          vector_k=a(1)*b(2)-b(1)*a(2);
          if vector_k < 0
              stick_tag= stick_tag+1;
              row
              break;
          end
      end
   end
   
end
stick_tag

end