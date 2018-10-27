function B=my_boundaries_2(image)
I = imread(image);%����ͼ��

BW = im2bw(I, graythresh(I));%ת����2����ͼ��
%[B,L] = bwboundaries(BW,'noholes');%Ѱ�ұ�Ե����������
%Ŀǰ����ǰ��Ϊ��ɫ������Ϊ��ɫ

[h,w]=size(BW);
bw_tag=bwlabel(BW); %����ͨ�������������
%�����ͼ���Ѿ����߽���ٴ����ˣ���ô����ͼ����bw_tag��Ӧ������ȫ����0

%B=cell()
%����Ԫ���������ӷ���a=[1 2 2]; B=[B a]
B=cell(0,1);
%����Ϊ˳ʱ�룬�󷽣�west��Ϊ1
%          1      2      3      4     5     6      7     8 
direction=[-1  -1; 0, -1; 1  -1; 1  0; 1  1; 0  1; -1  1; -1  0];

%��ʼ��¼����ʼ�㣬�Լ������һ���߽�㣨��ѭ����ͬһ����ʼ������һ���߽����ͬʱ���˱߽������ɣ�
flag=[];
judge_flag=[];

for i=1:h
    for j=1:w
        if bw_tag(i,j)>=1           
            flag=[i j -100 -100];
            brush_tag=bw_tag(i,j);
            start_point = 1;%��ʼ��������                      
            point_set=[i, j;];%������������
            judge_flag=[-100 -100 -100 -100];
            get_point = 0 ;%�Ƿ��ȡ����ʼ������һ���߽��       
            center_x = i;
            center_y = j;
       
            while(~isequal(flag, judge_flag))    
                k=start_point;
                is_noise = 0;  %�����ж�һ�����Ƿ��ǹ�����һ�����ص�
                while(1)                       
                    %(x,y)Ϊ��Χ��������������
                    x = center_x + direction(k,1);
                    y = center_y + direction(k,2);
                    %�ж������Ƿ�Խ��
                    if x >0  && x <= h && y > 0 && y <= w
                        if bw_tag(x , y )==brush_tag %�ҵ���һ���߽��
                            center_x=x;
                            center_y=y;
                            point_set=[point_set; [x,y]]; 
                            judge_flag=[i j x y];
                            if get_point == 0 %ȷ����ʼ�㼰�䷽��
                                flag(3)=x;
                                flag(4)=y;
                                get_point = 1;
                                judge_flag=[];
                            end              
                            break;%�Ѿ��ҵ��߽�㣬��������Χ������������һ��ı߽������
                        else 
                            is_noise=is_noise+1;
                        end
                    else
                        is_noise=is_noise+1;
                    end
                    k=mod( k, 8)+1;
                    
                    if is_noise==9 %������������һ�ܶ�û���������ڵ����ص㣬�����������һ�����������ص㣬����ѡ������
                        break;
                    end
                end      
                
                
                if is_noise==9
                    break;
                end
                %��һ���߽�����������
                start_point=mod((k+4), 8) + 1;
            end
            
            B=[B point_set];
            
            bw_tag=bw_tag-(bw_tag==brush_tag)*brush_tag;      
        end
    end
end

imshow(label2rgb(BW, @jet, [.5 .5 .5]))%��ʾͼ��
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end%����ѭ����ʾ�������
end
