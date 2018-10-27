function new_img = histspec(img,spec_img)
I_=imread(img);
J_=imread(spec_img);
I= rgb2gray(I_);
J= rgb2gray(J_);
[i_h i_w]=size(I);
[j_h j_w]=size(J);

histi=imhist(I);
histj=imhist(J);

%����ֱ��ͼ
%figure,imhist(I);
%figure,imhist(J);

%���Ƹ��ʷֲ�ͼ
proi=histi/(i_h*i_w);
proj=histj/(j_h*j_w);
%figure,plot(proi);
%figure,plot(proj);

%�ۻ�����
cpi=cumsum(histi)/numel(I);
cpj=cumsum(histj)/numel(J);

%����������ͼ���ۻ�����ͼ
figure,plot(cpi),title('ԭͼ�ۻ�����');
figure,plot(cpj),title('��׼ͼ�ۻ�����');

%index���±����ԭʼͼ�ĻҶȣ�ֵ����ӳ�䵽��׼ͼ�ϵĻҶ�
for m=1:256
    value{m}=abs(cpj-cpi(m));
    %���±�
    [temp,index(m)]=min(value{m});
    
end


new_img=uint8(zeros(i_h, i_w));

for i =1:i_h
    for j=1:i_w
        new_img(i,j)=index(I(i,j)+1)-1;
    end
end


figure
% ��ʾͼ��
subplot(2,3,1);imshow(I);title('ԭͼ');
subplot(2,3,2);imshow(J);title('��׼ͼ');
subplot(2,3,3);imshow(new_img);title('ƥ�䵽��׼ͼ');

% ��ʾ�Ҷ�ֱ��ͼ
subplot(2,3,4);imhist(I);title('ԭͼ');
subplot(2,3,5);imhist(J);title('��׼ͼ');
subplot(2,3,6);imhist(new_img);title('ֱ��ͼƥ�䵽��׼ͼ');

end