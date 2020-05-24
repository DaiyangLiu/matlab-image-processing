function my_fourier()
%��̣�
%�ø���Ҷ�任��ʵ��ͼ���ƽ���˲���
%��ʵ����֤�����˲�����ת����Ƶ�ʼ��㡣
%����Ҷ�任�ͷ��任�������� MATLAB �ĺ�����

img=imread('lena.jpg');
x=rgb2gray(img);
y1=imnoise(x,'gaussian',0,0.02);
f=double(y1);  %��������ת����MATLAB��֧��ͼ����޷������͵ļ���
g=fft2(f);     %����Ҷ�任
g=fftshift(g); %ת�����ݾ��� 
[M, N]=size(g);
nn=4;          %�Ľװ�����˹��ͨ�˲���  
d0=50;         %��ֹƵ��Ϊ50
m=fix(M/2);
n=fix(N/2);
for i=1:M
    for j=1:N
        d=sqrt((i-m)^2+(j-n)^2);
%         if d<=d0
%             h(i,j)=1;
%         else 
%             h(i,j)=0;
%         end
%         result(i,j)=h(i,j)*g(i,j);
        h=1/(1+0.414*(d/d0)^(2*nn));   %�����ͨ�˲������ݺ���
        result(i,j)=h*g(i,j);
    end
end

result=ifftshift(result);
y2=ifft2(result);
y3=uint8(real(y2));
subplot(1,2,1),imshow(y1),title('��Ӹ�˹�������ͼ��');
subplot(1,2,2),imshow(y3),title('�Ľװ�����˹��ͨ�˲�ͼ��');


end