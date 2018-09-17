function [new_img1 new_img2]=new_rotate(img,angle)
% 输入：图片地址，旋转角度（角度制）
%输出：最邻近插值结果，双线性插值结果
% 运行示例：[I1,I2]=new_rotate('mountain.png',60);

I=imread(img);
[h w d]=size(I);
%计算旋转后图像的大小
new_h=round( w*abs(sind(angle))+h*abs(cosd(angle)) );
new_w=round( w*abs(cosd(angle))+h*abs(sind(angle)) );

new_img1=uint8(zeros(new_h,new_w,d));%uint8是必须的
new_img2=uint8(zeros(new_h,new_w,d));

for x=1:new_w
    for y=1:new_h
        x0=x*cosd(angle) + y*sind(angle) -0.5*new_w*cosd(angle) -0.5*new_h*sind(angle) +0.5*w;        
        y0=-x*sind(angle) + y*cosd(angle) + 0.5*new_w*sind(angle) - 0.5*new_h*cosd(angle)+0.5*h;

        x00=round(x0);
        y00=round(y0);
        if x00>0 && y00>0 &&x00<=w && y00<=h
           %最邻近插值
             new_img1(y,x,:)=I(y00,x00,:);
        end
        
        if x00>1 && y00>1 &&x00<w && y00<h           
            x_small=floor(x0);
            x_large=ceil(x0);
            y_small=floor(y0);
            y_large=ceil(y0);
           %双线性插值
           point1=I(y_small,x_small,:) + ( I(y_small,x_large,:) - I(y_small,x_small,:) ) * ( x0 - x_small );
           point2=I(y_large,x_small,:) + ( I(y_large,x_large,:) - I(y_large,x_small,:) ) * ( x0 - x_small );

           point3=point1 + ( point2 - point1 ) * ( y0 - y_small );

           new_img2(y,x,:)=point3;
        end       
    end
end

figure,imshow(new_img1),title("最邻近插值");
figure,imshow(new_img2),title("双线性插值");

end