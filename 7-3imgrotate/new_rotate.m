function output=new_rotate(image,angle)
I=imread(image);
%angle=30
%判断是否是灰度图像
if ndims(I)~=2
    I=rgb2gray(I);
end

a=size(I,1);
b=size(I,2);
new_size=size_after_imrotate(a, b, angle);%【76 57】 

%生成全0画布
output = zeros(new_size(2),new_size(1));

for i=1:a
    for j=1:b
        coor=point_rotate(i,j,b,a,angle);
        coorO2=[1,0,0.5*new_size(1); 0,-1,0.5*new_size(2); 0,0,1]*[coor(1);coor(2);1];
       [ round(coorO2(1)) round(coorO2(2))]
       if round(coorO2(1))<=0 || round(coorO2(2))<=0
           continue;
       end
       output( round(coorO2(1)) , round(coorO2(2)) )= I(i,j);
    end
end


%imtool(I)
%imtool(output)
output
end