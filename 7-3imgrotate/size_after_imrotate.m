function new_size=size_after_imrotate(a,b,theta)
%function [new_a,new_b]=size_after_imrotate(a,b,theta) 
%ʼ�ղ��ܷ��ض��ֵ

%�������ܣ�������ת��ͼ��Ĵ�С,��������������
%���룺a  ��, b ���� theta ��ת�Ƕ� 

%�������ѣ�a,b��˳���չ�������ʾ�ľ���˳������
%theta����ת�Ƕȣ�û�п�������Ƕ�Ϊ�������
theta = mod(theta,360);
c=length_diagonale(a,b);
alpha1 = angle_diagonale(a,b);
alpha2 = angle_diagonale(b,a);

%����ˮƽ����Խ��ߵ���ת�Ƕ�
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

%���㴹ֱ����Խ��ߵ���ת�Ƕ�
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
