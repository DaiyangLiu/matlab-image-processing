function coordinate=point_rotate(x,y,w,h,theta)
%���룺x ����ĺ������꣬ y ������������꣬ w ͼ�εĺ��򳤶ȣ� h ͼ�ε����򳤶ȣ�theta ��ת�ĽǶ�
cor=[1,0,-0.5*w;0,-1,0.5*h;0,0,1]*[x;y;1];
coordinate=[cor(1)*cosd(theta)-cor(2)*sind(theta), cor(1)*sind(theta)+cor(2)*cosd(theta) ];
end
