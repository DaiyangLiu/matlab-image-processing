function myGaussFilter(src, N, sigma)
%���룺ͼƬ��ַ���˲�����С�� sigma
%ʹ��ʾ����myGaussFilter('Boston2.jpg', 7, 1.6)
I = imread(src);
I = rgb2gray(I);
[img_row, img_col] = size(I);

N_row = 2*N+1;
I_noise = imnoise(I, 'gaussian');

gausFilter = fspecial('gaussian',[N_row N_row],sigma);      %matlab �Դ���˹ģ���˲�
blur=imfilter(I_noise,gausFilter,'conv');

H = [];
for i = 1:N_row
    for j = 1:N_row
       fenzi=double((i-N-1)^2+(j-N-1)^2);
        H(i,j)=exp(-fenzi/(2*sigma*sigma))/(2*pi*sigma); 
    end
end
H=H/sum(H(:)); 


desimg=zeros(img_row,img_col);            %�˲���ͼ��
midimg=zeros(img_row+2*N,img_col+2*N);    %�м�ͼ��
for i=1:img_row                           %ԭͼ��ֵ���м�ͼ�����ܱ�Ե����Ϊ0
    for j=1:img_col
        midimg(i+N,j+N)=I_noise(i,j);
    end
end

temp=[];
for ai=N+1:img_row+N
    for aj=N+1:img_col+N
        temp_row=ai-N;
        temp_col=aj-N;
        temp=0;
        for bi=1:N_row
            for bj=1:N_row
                temp= temp+(midimg(temp_row+bi-1,temp_col+bj-1)*H(bi,bj));
            end
        end
        desimg(temp_row,temp_col)=temp;
    end
end
desimg=uint8(desimg);

subplot(2,2,1);imshow(I);title('ԭͼ');
subplot(2,2,2);imshow(I_noise);title('����ͼ');
subplot(2,2,3);imshow(desimg);title('��ʵ�ָ�˹�˲�');
subplot(2,2,4);imshow(blur);title('matlab��˹�˲�');
end
