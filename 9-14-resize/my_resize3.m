function resize_img=my_resize3(img,dst_row,dst_col)
%���룺ͼƬ��ַ������ͼƬ�߶ȣ�����ͼƬ���
%������������ͼƬ
%ʹ��ʾ����new_img=my_resize2('Boston.jpg',500,800);
I=imread(img);
[src_row,src_col,d]=size(I);
resize_img=uint8(zeros(dst_row,dst_col,d));

%˫���Բ�ֵ
for i=1:dst_col
    src_i=(i/dst_col) *  src_col;
    i_small=floor(src_i);
    i_large=ceil(src_i);
    if i==1 %�ڱ��Ż�
        src_i=1.5;
        i_small=1;
        i_large=2;
    end

    for j=1:dst_row
        src_j=(j/dst_row) *  src_row;
        j_small=floor(src_j);
        j_large=ceil(src_j);
        if j==1  %�ڱ��Ż�
            src_j=1.5;
            j_small=1;
            j_large=2;
        end
        if i_small>0 && i_large<= src_col && j_small>0 && j_large <= src_row   
            point1=(( I(j_small,i_large,:)- I(j_small,i_small,:) )/(i_large-i_small)) *(src_i-i_small) + I(j_small,i_small,:);
            point2=(( I(j_large,i_large,:)- I(j_large,i_small,:) )/(i_large-i_small)) *(src_i-i_small) + I(j_large,i_small,:);
            
            point3=(point2-point1)/(j_large-j_small)*(src_j-j_small)+point1;
            resize_img(j,i,:)= point3;
        end
    end  
end
figure,imshow(I),title("ԭͼ");
figure,imshow(resize_img);title("�������ͼƬ");
imtool(resize_img);
end