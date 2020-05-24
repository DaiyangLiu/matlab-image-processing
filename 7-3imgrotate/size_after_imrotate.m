function new_size=size_after_imrotate(a,b,theta)
%function [new_a,new_b]=size_after_imrotate(a,b,theta) 
%始终不能返回多个值

%函数功能：返回旋转后图像的大小,经过了四舍五入
%输入：a  宽, b 长， theta 旋转角度 

%输入提醒：a,b的顺序按照工作区显示的矩阵顺序输入
%theta是旋转角度，没有考虑输入角度为负的情况
theta = mod(theta,360);
c=length_diagonale(a,b);
alpha1 = angle_diagonale(a,b);
alpha2 = angle_diagonale(b,a);

%计算水平方向对角线的旋转角度
if theta<=alpha1
    beta1 = alpha1-theta;
elseif theta>alpha1 && theta<=(alpha1+90)
    beta1 = theta - alpha1;
elseif theta>(alpha1+90) && theta<=(alpha1+180)
    beta1 = 180 - (theta - alpha1);
elseif theta>(alpha1+180) && theta<=(alpha1+270)
    beta1 = theta - (alpha1 + 180);
elseif theta>(alpha1+270) && theta<=(alpha1+360)
    beta1 = 360 - theta + alpha1;
end

%计算垂直方向对角线的旋转角度
if theta<=alpha2
    beta2 = alpha2-theta;
elseif theta>alpha2 && theta<=(alpha2+90)
    beta2 = theta - alpha2;
elseif theta>(alpha2+90) && theta<=(alpha2+180)
    beta2 = 180 - (theta - alpha2);
elseif theta>(alpha2+180) && theta<=(alpha2+270)
    beta2 = theta - (alpha2 + 180);
elseif theta>(alpha2+270) && theta<=(alpha2+360)
    beta2 = 360 - theta + alpha2;
end

new_a=(c/2)*cosd(beta1)*2; 
new_b=(c/2)*cosd(beta2)*2;
new_size=[round(new_a) round(new_b)];
end
