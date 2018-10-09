function [ m, theta, sector, canny1,  canny2, bin] = canny1step( src,  lowTh)
%canny函数第一步，求去x，y方向的偏导，模板如下：
% Gx
% 1  -1
% 1  -1
% Gy
% -1  -1
%  1    1
%------------------------------------
% 输入：
% src：图像，如果不是灰度图转成灰度图
% lowTh：低阈值
% 输出：
% m： 两个偏导的平方差，反映了边缘的强度
% theta：反映了边缘的方向
% sector：将方向分为3个区域，具体如下
% 2 1 0
% 3 X 3
% 0 1 2
% canny1：非极大值
% canny2：双阈值抑制
% bin ：     二值化
%--------------------------------------- 


[Ay Ax dim ] = size(src);
%转换为灰度图
if dim>1
    src = rgb2gray(src);
end


src = double(src);
m = zeros(Ay, Ax); 
theta = zeros(Ay, Ax);
sector = zeros(Ay, Ax);
canny1 = zeros(Ay, Ax);%非极大值抑制
canny2 = zeros(Ay, Ax);%双阈值检测和连接
bin = zeros(Ay, Ax);
for y = 1:(Ay-1)
    for x = 1:(Ax-1)
        gx =  src(y, x) + src(y+1, x) - src(y, x+1)  - src(y+1, x+1);
        gy = -src(y, x) + src(y+1, x) - src(y, x+1) + src(y+1, x+1);
        m(y,x) = (gx^2+gy^2)^0.5 ;
        %--------------------------------
        theta(y,x) = atand(gx/gy)  ;
        tem = theta(y,x);
        %--------------------------------
        if (tem<67.5)&&(tem>22.5)
            sector(y,x) =  0;    
        elseif (tem<22.5)&&(tem>-22.5)
            sector(y,x) =  3;    
        elseif (tem<-22.5)&&(tem>-67.5)
            sector(y,x) =   2;    
        else
            sector(y,x) =   1;    
        end
        %--------------------------------        
    end    
end
%-------------------------
%非极大值抑制
%------> x
%   2 1 0
%   3 X 3
%y  0 1 2
for y = 2:(Ay-1)
    for x = 2:(Ax-1)        
        if 0 == sector(y,x) %右上 - 左下
            if ( m(y,x)>m(y-1,x+1) )&&( m(y,x)>m(y+1,x-1)  )
                canny1(y,x) = m(y,x);
            else
                canny1(y,x) = 0;
            end
        elseif 1 == sector(y,x) %竖直方向
            if ( m(y,x)>m(y-1,x) )&&( m(y,x)>m(y+1,x)  )
                canny1(y,x) = m(y,x);
            else
                canny1(y,x) = 0;
            end
        elseif 2 == sector(y,x) %左上 - 右下
            if ( m(y,x)>m(y-1,x-1) )&&( m(y,x)>m(y+1,x+1)  )
                canny1(y,x) = m(y,x);
            else
                canny1(y,x) = 0;
            end
        elseif 3 == sector(y,x) %横方向
            if ( m(y,x)>m(y,x+1) )&&( m(y,x)>m(y,x-1)  )
                canny1(y,x) = m(y,x);
            else
                canny1(y,x) = 0;
            end
        end        
    end%end for x
end%end for y

%---------------------------------
%双阈值检测
ratio = 2;
for y = 2:(Ay-1)
    for x = 2:(Ax-1)        
        if canny1(y,x)<lowTh %低阈值处理
            canny2(y,x) = 0;
            bin(y,x) = 0;
            continue;
        elseif canny1(y,x)>ratio*lowTh %高阈值处理
            canny2(y,x) = canny1(y,x);
            bin(y,x) = 1;
            continue;
        else %介于之间的看其8领域有没有高于高阈值的，有则可以为边缘
            tem =[canny1(y-1,x-1), canny1(y-1,x), canny1(y-1,x+1);
                       canny1(y,x-1),    canny1(y,x),   canny1(y,x+1);
                       canny1(y+1,x-1), canny1(y+1,x), canny1(y+1,x+1)];
            temMax = max(tem);
            if temMax(1) > ratio*lowTh
                canny2(y,x) = temMax(1);
                bin(y,x) = 1;
                continue;
            else
                canny2(y,x) = 0;
                bin(y,x) = 0;
                continue;
            end
        end
    end%end for x
end%end for y




end%end of function
