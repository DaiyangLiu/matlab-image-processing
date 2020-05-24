function coordinate=point_rotate(x,y,w,h,theta)
%输入：x 矩阵的横向坐标， y 矩阵的纵向坐标， w 图形的横向长度， h 图形的纵向长度，theta 旋转的角度
cor=[1,0,-0.5*w;0,-1,0.5*h;0,0,1]*[x;y;1];
coordinate=[cor(1)*cosd(theta)-cor(2)*sind(theta), cor(1)*sind(theta)+cor(2)*cosd(theta) ];
end
