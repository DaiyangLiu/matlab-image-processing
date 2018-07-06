function rice_count()
clear;
close all;
I = imread('rice.png');
[width,height] = size(I);
J = edge(I,'canny');
%figure,imshow(J);
K = imfill(J,'holes');
%figure,imshow(K);
SE = strel('disk',3);%�������͸�ʴ����������Ȳ����ĽṹԪ�ض���
%��ͼ��ʵ�ֿ����㣬������һ����ƽ��ͼ���������������խ�Ĳ��֣�ȥ��ϸ��ͻ����
L = imopen(K,SE);
figure,imshow(L);
L = uint8(L);%��L��logic����ת��Ϊuint8����
for i = 1:height
    for j = 1:width
        if L(i,j) == 1
            L(i,j) = 255;%�Ѱ�ɫ���ص�����ֵ��ֵΪ255
        end
    end
end
MAXSIZE = 999999;
Q = zeros(MAXSIZE,2);%������ģ�����,�洢���ص�����
front = 1;%ָ����ͷ��λ��
rear = 1;%ָ����β����һ��λ�ã�front=rear��ʾ�ӿ�
flag = 0;%�����ı��
 
for i = 1:height
    for j = 1:width
        if L(i,j) == 255%��ɫ���ص������
            if front == rear%���пգ��ҵ���������������ż�һ
                flag = flag+1;
            end
            L(i,j) = flag;%����ɫ���ظ�ֵΪ�����ı��
            Q(rear,1) = i;
            Q(rear,2) = j;
            rear = rear+1;%��β����
            while front ~= rear
                %��ͷ����
                temp_i = Q(front,1);
                temp_j = Q(front,2);
                front = front + 1;
                %�Ѷ�ͷλ�����ص�8��ͨ������δ����ǵİ�ɫ���ص����,�������������
                %���Ͻǵ����ص�
                if L(temp_i - 1,temp_j - 1) == 255
                    L(temp_i - 1,temp_j - 1) = flag;
                    Q(rear,1) = temp_i - 1;
                    Q(rear,2) = temp_j - 1;
                    rear = rear + 1;
                end
                %���Ϸ������ص�
                if L(temp_i - 1,temp_j) == 255
                    L(temp_i - 1,temp_j) = flag;
                    Q(rear,1) = temp_i - 1;
                    Q(rear,2) = temp_j;
                    rear = rear + 1;
                end
                %���Ϸ������ص�
                if L(temp_i - 1,temp_j + 1) == 255
                    L(temp_i - 1,temp_j + 1) = flag;
                    Q(rear,1) = temp_i - 1;
                    Q(rear,2) = temp_j + 1;
                    rear = rear + 1;
                end
                %���󷽵����ص�
                if L(temp_i,temp_j - 1) == 255
                    L(temp_i,temp_j - 1) = flag;
                    Q(rear,1) = temp_i;
                    Q(rear,2) = temp_j - 1;
                    rear = rear + 1;
                end
                %���ҷ������ص�
                if L(temp_i,temp_j + 1) == 255
                    L(temp_i,temp_j + 1) = flag;
                    Q(rear,1) = temp_i;
                    Q(rear,2) = temp_j + 1;
                    rear = rear + 1;
                end
                %���·������ص�
                if L(temp_i + 1,temp_j - 1) == 255
                    L(temp_i + 1,temp_j - 1) = flag;
                    Q(rear,1) = temp_i + 1;
                    Q(rear,2) = temp_j - 1;
                    rear = rear + 1;
                end
                %���·������ص�
                if L(temp_i + 1,temp_j) == 255
                    L(temp_i + 1,temp_j) = flag;
                    Q(rear,1) = temp_i + 1;
                    Q(rear,2) = temp_j;
                    rear = rear + 1;
                end
                %���·������ص�
                if L(temp_i + 1,temp_j + 1) == 255
                    L(temp_i + 1,temp_j + 1) = flag;
                    Q(rear,1) = temp_i + 1;
                    Q(rear,2) = temp_j + 1;
                    rear = rear + 1;
                end
            end
        end
    end
end



figure,imshow(L);
RiceNumber = flag;%��¼�������ܸ���
disp('�������ܸ���:')
RiceNumber
RiceArea = zeros(1,RiceNumber);%��¼�������Ĵ�С
for i = 1:height
    for j = 1:width
        if L(i,j) ~= 0
            RiceArea(L(i,j)) = RiceArea(L(i,j)) + 1;
        end
    end
end
disp('�������Ĵ�С(���մ������£��������ҵ�˳��)��')
RiceArea

end