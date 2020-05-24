function new_img = histspec(img,spec_img)
I_=imread(img);
J_=imread(spec_img);
I= rgb2gray(I_);
J= rgb2gray(J_);
[i_h i_w]=size(I);
[j_h j_w]=size(J);

histi=imhist(I);
histj=imhist(J);

%绘制直方图
%figure,imhist(I);
%figure,imhist(J);

%绘制概率分布图
proi=histi/(i_h*i_w);
proj=histj/(j_h*j_w);
%figure,plot(proi);
%figure,plot(proj);

%累积概率
cpi=cumsum(histi)/numel(I);
cpj=cumsum(histj)/numel(J);

%绘制这两幅图的累积概率图
figure,plot(cpi),title('原图累积概率');
figure,plot(cpj),title('标准图累积概率');

%index的下标代表原始图的灰度，值代表映射到标准图上的灰度
for m=1:256
    value{m}=abs(cpj-cpi(m));
    %存下标
    [temp,index(m)]=min(value{m});
    
end


new_img=uint8(zeros(i_h, i_w));

for i =1:i_h
    for j=1:i_w
        new_img(i,j)=index(I(i,j)+1)-1;
    end
end


figure
% 显示图像
subplot(2,3,1);imshow(I);title('原图');
subplot(2,3,2);imshow(J);title('标准图');
subplot(2,3,3);imshow(new_img);title('匹配到标准图');

% 显示灰度直方图
subplot(2,3,4);imhist(I);title('原图');
subplot(2,3,5);imhist(J);title('标准图');
subplot(2,3,6);imhist(new_img);title('直方图匹配到标准图');

end