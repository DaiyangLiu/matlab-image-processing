function count_rice_by_area()%�������������������
I = imread('rice.png');
[width,height] = size(I);
J = edge(I,'canny');
%figure,imshow(J);
K = imfill(J,'holes');
%figure,imshow(K);
SE = strel('disk',3);%�������͸�ʴ����������Ȳ����ĽṹԪ�ض���
%��ͼ��ʵ�ֿ����㣬������һ����ƽ��ͼ���������������խ�Ĳ��֣�ȥ��ϸ��ͻ����
L0 = imopen(K,SE);
imtool(L0);
L = uint16(L0);%��L��logic����ת��Ϊuint8����---uint16
%flag���ܴ���255����Ӧ����uint8����flag
for i = 1:height
    for j = 1:width
        if L(i,j) == 1
            L(i,j) = 255;%�Ѱ�ɫ���ص�����ֵ��ֵΪ255
        end
    end
end
MAXLABEL=999999;
find=zeros(MAXLABEL,1)-1;
flag=0;

%���û��ݷ������ͨ����
%��ͨ����ָ4��ͨ��
for i=1:height
    for j=1:width
        if L(i,j)==255
            if j-1>0  %���Ƿ���������ؽ����ж�
                temp_j=L(i,j-1);  %�У��򱣴�����ͨ���
            else
                temp_j=0;  %�ޣ��򱣳�����Ϊ��
            end
            if i-1>0  %���Ƿ����ϱ����ؽ����ж�
                temp_i=L(i-1,j);
            else
                temp_i=0;
            end
            
            if temp_j==0&&temp_i==0  %�����ߺ��ϱ߶�û�б�ǣ���ôΪ��i,j����һ���±��
                flag=flag+1;
                L(i,j)=flag;
                find(flag)=0;
            elseif (temp_j~=0&&temp_i==0) || (temp_j==0&&temp_i~=0) %��ߺ��ϱ�����һ���б��
                L(i,j)=temp_j+temp_i; %����һ��Ϊ�㣬���Խ�������ӣ�����һ���ж���䣬ֱ�ӽ��и�ֵ
            elseif temp_j~=0&&temp_i~=0&&temp_j==temp_i %��ߺ��ϱ߶��б�ǣ��ұ����ͬ
                L(i,j)=temp_j;
            elseif temp_j~=0&&temp_i~=0&&temp_j~=temp_i %��ߺ��ϱ߶��б�ǣ�����ǲ�ͬ
                if temp_j<temp_i
                    L(i,j)=temp_j;
                    find(temp_i)=temp_j;
                else
                    L(i,j)=temp_i;
                    find(temp_j)=temp_i;
                end              
            end
        end
    end
end
flag

%�����б�Ǹ�������ڵ��ֵ
for i=1:height
    for j=1:width
        if L(i,j)~=0
            label=L(i,j);
            temp_find=find(L(i,j));
            while(temp_find~=0) %ʹ�ò��鼯�Ҹ��ڵ�
                label=temp_find;
                temp_find=find(temp_find); 
            end
            L(i,j)=label;
        end        
    end
end

%���θ���ͨ����������
true_flag=0;
for index=1:flag+1
    if find(index)==0
        true_flag=true_flag+1;
        for i=1:height
            for j=1:width
                if L(i,j)==index
                    L(i,j)=true_flag;
                end
            end
        end
    end
end

L=uint8(L); 
imtool(L);


rice_amount=zeros(true_flag,1);
for i=1:true_flag
    rice_amount(i)=sum(sum(L==i));
end
rice_amount
hist(rice_amount,20);

%��ȥ�쳣�㣬�������������ƽ��ֵ���Լ����ֵ����Сֵ
%�쳣ֵ���ֶ��ң������Զ���
%�����쳣Ҫ�ж��壬��Ҫ�漰ͳ��ѧ��֪ʶ
%�������������ֱ���ֶ���

%�����쳣���
%���ڶ���Ϊ�쳣ֵ
%���ڶ���Ϊ�쳣ֵ


%�ֶ��ֶ����ֶ�ɸѡ����ֵ

%amount=true_flag+sum(rice_amount>300)

disp('�������ܸ���:')
amount=true_flag+sum(rice_amount>300)
end