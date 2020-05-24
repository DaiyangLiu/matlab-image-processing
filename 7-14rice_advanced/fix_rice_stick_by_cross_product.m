function fix_rice_stick_by_cross_product()
I = imread('rice.png');%����ͼ��

%ֱ�Ӵ����Ե��
%��������forѭ���жϱ�Ե�ķ�ʽ��
J = edge(I,'canny');
%figure,imshow(J);
K = imfill(J,'holes');
%figure,imshow(K);
SE = strel('disk',3);%�������͸�ʴ����������Ȳ����ĽṹԪ�ض���
%��ͼ��ʵ�ֿ����㣬������һ����ƽ��ͼ���������������խ�Ĳ��֣�ȥ��ϸ��ͻ����
L0 = imopen(K,SE);
L0=uint8(L0);
figure,imshow(L0);

BW = im2bw(L0, graythresh(L0));%ת����2����ͼ��

[B,L] = bwboundaries(BW,'noholes');%Ѱ�ұ�Ե����������

imshow(label2rgb(L, @jet, [.5 .5 .5]))%��ʾͼ��
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end%����ѭ����ʾ�������

%����B
stick_tag=0;
for k = 1:length(B)
   boundary = B{k};
   [row col]=size(boundary);
   %if row<70 %�۲��������ݼ��ɷ��֣������������ı߽����ض�С��70
    %   continue;
   %end
   %��˼��
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