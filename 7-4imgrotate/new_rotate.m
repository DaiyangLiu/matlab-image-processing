function [new_img1 new_img2]=new_rotate(img,angle)
I=imread(img);

[h w d]=size(I);
%������ת��ͼ��Ĵ�С
new_h=round( w*abs(sind(angle))+h*abs(cosd(angle)) );
new_w=round( w*abs(cosd(angle))+h*abs(sind(angle)) );

new_img1=uint8(zeros(new_h,new_w,d));%uint8�Ǳ����
new_img2=uint8(zeros(new_h,new_w,d));

for x=1:new_h
    for y=1:new_w
        x0=x*cosd(angle) + y*sind(angle) -0.5*new_w*cosd(angle) -0.5*new_h*sind(angle) +0.5*w;
        y0=-x*sind(angle) + y*cosd(angle) + 0.5*new_w*sind(angle) - 0.5*new_h*cosd(angle)+0.5*h;
        
        %���ڽ���ֵ
        x00=round(x0);
        y00=round(y0);
        if x00>1 && y00>1 &&x00<w && y00<h
           %���ڽ���ֵ
            new_img1(y,x,:)=I(y00,x00,:);
            
            x_small=floor(x0);
            x_large=ceil(x0);
            y_small=floor(y0);
            y_large=ceil(y0);
           %˫���Բ�ֵ
           point1=I(y_small,x_small,:) + ( I(y_small,x_large,:) - I(y_small,x_small,:) ) * ( x0 - x_small );
           point2=I(y_large,x_small,:) + ( I(y_large,x_large,:) - I(y_large,x_small,:) ) * ( x0 - x_small );

           point3=point1 + ( point2 - point1 ) * ( y0 - y_small );

           new_img2(y,x,:)=point3;
        end
    end
end

end