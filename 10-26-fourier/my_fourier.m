function my_fourier()
%编程：
%用傅里叶变换，实现图像的平滑滤波；
%用实例验证空滤滤波可以转换到频率计算。
%傅里叶变换和反变换，可以用 MATLAB 的函数。

img=imread('lena.jpg');
x=rgb2gray(img);
y1=imnoise(x,'gaussian',0,0.02);
f=double(y1);  %数据类型转换，MATLAB不支持图像的无符号整型的计算
g=fft2(f);     %傅里叶变换
g=fftshift(g); %转换数据矩阵 
[M, N]=size(g);
nn=4;          %四阶巴特沃斯低通滤波器  
d0=50;         %截止频率为50
m=fix(M/2);
n=fix(N/2);
for i=1:M
    for j=1:N
        d=sqrt((i-m)^2+(j-n)^2);
%         if d<=d0
%             h(i,j)=1;
%         else 
%             h(i,j)=0;
%         end
%         result(i,j)=h(i,j)*g(i,j);
        h=1/(1+0.414*(d/d0)^(2*nn));   %计算低通滤波器传递函数
        result(i,j)=h*g(i,j);
    end
end

result=ifftshift(result);
y2=ifft2(result);
y3=uint8(real(y2));
subplot(1,2,1),imshow(y1),title('添加高斯噪声后的图像');
subplot(1,2,2),imshow(y3),title('四阶巴特沃斯低通滤波图像');


end