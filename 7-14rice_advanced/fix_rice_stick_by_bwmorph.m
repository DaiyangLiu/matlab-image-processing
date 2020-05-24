function tag=fix_rice_stick_by_bwmorph()
I = imread('rice.png');
[width,height] = size(I);
BW=im2bw(I);


J = edge(BW,'canny');
%figure,imshow(J);
K = imfill(J,'holes');
%figure,imshow(K);
SE = strel('disk',3);%�������͸�ʴ����������Ȳ����ĽṹԪ�ض���
%��ͼ��ʵ�ֿ����㣬������һ����ƽ��ͼ���������������խ�Ĳ��֣�ȥ��ϸ��ͻ����
BW1 = imopen(K,SE);

BW2=bwmorph(BW1,'thin',Inf);
%figure,imshow(BW2);

BW3=bwmorph(BW2,'branch');
figure,imshow(BW3);

%imtool(BW3);

%��BW3�ϵİ׵�ΪԲ�ģ���I���� BW���ϻ�Բ
%figure,imshow(BW);
%annotation('doublearrow',[0.2 0.8],[0.85 0.85],'LineStyle','-','color',[1 0 0],'HeadStyle','cback3');
%��ͼʧ��
tag=0;
for i=1:width
    for j=1:height
        if BW3(i,j)==1
           tag=tag+1;
        end
    end
end
disp('������ճ������:')
tag
end