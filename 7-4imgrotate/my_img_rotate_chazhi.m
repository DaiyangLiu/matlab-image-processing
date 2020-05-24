function img_rotate=my_img_rotate_chazhi(img1,angle)
% 旋转后图像=my_img_rotate(原图像,旋转角度) 0<旋转角度<360
% 查找新图对应的原图像素点
% 最邻近点插值方法
[h,w,d]=size(img1);
radian=angle/180*pi;
cos_val	= cos(radian);
sin_val	= sin(radian);
w2=round(abs(cos_val)*w+h*abs(sin_val));
h2=round(abs(cos_val)*h+w*abs(sin_val));
img_rotate	= uint8(zeros(h2,w2,3));	%像素是整数
for x=1:w2
    for y=1:h2
        x0 = uint32(x*cos_val + y*sin_val -0.5*w2*cos_val-0.5*h2*sin_val+0.5*w);
        y0= uint32(y*cos_val-x*sin_val+0.5*w2*sin_val-0.5*h2*cos_val+0.5*h);    
        
        x0=round(x0);         %最邻近插值
        y0=round(y0);         %最邻近插值
        if x0>0 && y0>0&& w >= x0&& h >= y0
            img_rotate(y,x,:) = img1(y0,x0,:);
        end
    end
end
%I = imread('C:\Users\yytang\Desktop\love.jpg')
%I2=my_img_rotate_chazhi(I,30);
%figure,imshow(I2);
