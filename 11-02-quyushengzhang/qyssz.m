% Segment based on area, Region Growing;
function qyssz()
[fileName,pathName] = uigetfile('*.*','Please select an image');%�ļ���ѡ���ļ�
if(fileName)
    fileName = strcat(pathName,fileName);
    fileName = lower(fileName);%һ�µ�Сд��ĸ��ʽ
else 
    J = 0;%��¼�����������ָ�õ�������
    msgbox('Please select an image');
    return; %�˳�����
end
 
I = imread(fileName);
if( ~( size(I,3)-3 ))
    I = rgb2gray(I);%ת��Ϊ��ͨ���Ҷ�ͼ
end
I = im2double(I); %ͼ��Ҷ�ֵ��һ����[0,1]֮��
Ireshape = imresize(I,[600,800]);
I = Ireshape(51:475,200:699);
gausFilter = fspecial('gaussian',[5 5],0.5);
I = imfilter(I,gausFilter,'replicate');
 
%���ӵ�Ľ���ʽѡ��
if( exist('x','var') == 0 && exist('y','var') == 0)
    subplot(2,2,1),imshow(I,[]);
    hold on;
    [y,x] = getpts;%���ȡ��  �س�ȷ��
    x = round(x(1));%ѡ�����ӵ�
    y = round(y(1));
end
 
if( nargin == 0)
    reg_maxdist = 0.1;
    %nargin��matlab�����д�г��õ�һ�����ɣ���Ҫ���ڼ��㵱ǰ�����������������
    %����һ����Ը���nargin�ķ���ֵ��ȷ�����������������ȱʡֵ����ʵ���У����
    %�û�����Ĳ�������Ϊ�㣬��ôĬ��Ϊ0.2
end
J = zeros(size(I)); % �������ķ���ֵ����¼�����������õ�������
Isizes = size(I);
reg_mean = I(x,y);%��ʾ�ָ�õ������ڵ�ƽ��ֵ����ʼ��Ϊ���ӵ�ĻҶ�ֵ
reg_size = 1;%�ָ�ĵ������򣬳�ʼ��ֻ�����ӵ�һ��
neg_free = 10000; %��̬�����ڴ��ʱ��ÿ������������ռ��С
neg_list = zeros(neg_free,3);
%���������б�����Ԥ�ȷ������ڴ�������������ص������ֵ�ͻҶ�ֵ�Ŀռ䣬����
%���ͼ��Ƚϴ���Ҫ���neg_free��ʵ��matlab�ڴ�Ķ�̬����
neg_pos = 0;%���ڼ�¼neg_list�еĴ����������ص�ĸ���
pixdist = 0;
%��¼�������ص����ӵ��ָ������ľ�����
%��һ�δ��������ĸ��������ص�͵�ǰ���ӵ�ľ���
%�����ǰ����Ϊ��x,y����ôͨ��neigb���ǿ��Եõ����ĸ��������ص�λ��
neigb = [ -1 0;
          1  0;
          0 -1;
          0  1];
 %��ʼ�������������������д��������������ص���Ѿ��ָ�õ��������ص�ĻҶ�ֵ����
 %����reg_maxdis,������������
 
 while (pixdist < 0.06 && reg_size < numel(I))
     %�����µ��������ص�neg_list��
     for j=1:4
         xn = x + neigb(j,1);
         yn = y + neigb(j,2);
         %������������Ƿ񳬹���ͼ��ı߽�
         ins = (xn>=1)&&(yn>=1)&&(xn<=Isizes(1))&&(yn<=Isizes(1));
         %�������������ͼ���ڲ���������δ�ָ�ã���ô������ӵ������б���
         if( ins && J(xn,yn)==0)
             neg_pos = neg_pos+1;
             neg_list(neg_pos,:) =[ xn, yn, I(xn,yn)];%�洢��Ӧ��ĻҶ�ֵ
             J(xn,yn) = 1;%��ע���������ص��Ѿ������ʹ� ������ζ�ţ����ڷָ�������
         end
     end
    %���������ڴ���ʲ����������µ��ڴ�ռ�
    if (neg_pos+10>neg_free)
        neg_free = neg_free + 100000;
        neg_list((neg_pos +1):neg_free,:) = 0;
    end
    %�����д����������ص���ѡ��һ�����ص㣬�õ�ĻҶ�ֵ���Ѿ��ָ������ҶȾ�ֵ��
    %��ľ���ֵʱ����������������С��
    dist = abs(neg_list(1:neg_pos,3)-reg_mean);
    [pixdist,index] = min(dist);
    %����������µľ�ֵ
    reg_mean = (reg_mean * reg_size +neg_list(index,3))/(reg_size + 1);
    reg_size = reg_size + 1;
    %���ɵ����ӵ���Ϊ�Ѿ��ָ�õ��������ص�
    J(x,y)=2;%��־�����ص��Ѿ��Ƿָ�õ����ص�
    x = neg_list(index,1);
    y = neg_list(index,2);
%     pause(0.0005);%��̬����
%     if(J(x,y)==2)
%     plot(x,y,'r.');
%     end
    %���µ����ӵ�Ӵ����������������б����Ƴ�
    neg_list(index,:) = neg_list(neg_pos,:);
    neg_pos = neg_pos -1;
 end
 
 J = (J==2);%����֮ǰ���ָ�õ����ص���Ϊ2
 hold off;
 subplot(2,2,2),imshow(J);
 J = bwmorph(J,'dilate');%����ն�
 subplot(2,2,3),imshow(J);
 subplot(2,2,4),imshow(I+J);
 
end