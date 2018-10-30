I=imread('lena.jpg');
I=rgb2gray(I);
figure,
subplot(1,2,1),imshow(I),title('ԭʼ�Ҷ�ͼ��');

f=double(I);
F=fft2(f);
S=fftshift( log(1+abs(F)) );
subplot(1,2,2),imshow(S,[]),title('��ͼ��ĸ���Ҷ��');

h=fspecial('sobel');
%PQ=paddedsize(size(f));
PQ = 2*size(f);
H=freqz2(h,PQ(1),PQ(2));
H1=ifftshift(H);
figure,
subplot(1,2,1),imshow(abs(H),[]),title('��Ӧ�ڴ�ֱSobel�ռ��˲�����Ƶ�����˲����ľ���ֵ');
subplot(1,2,2),imshow(abs(H1),[]),title('������ifftshift�������ͬһ�˲���');

gs=imfilter(f,h);
gf=dftfilt(f,H1);
figure,
subplot(2,2,1),imshow(gs,[]),title('�ô�ֱSobelģ���ڿռ����ԭʼͼ���˲��Ľ��');
subplot(2,2,2),imshow(gf,[]),title('��H1�˲�����Ƶ�����еõ��Ľ��');

subplot(2,2,3),imshow(abs(gs) ,[]),title('�ô�ֱSobelģ���ڿռ����ԭʼͼ���˲��Ľ���ľ���ֵ ');
subplot(2,2,4),imshow( abs(gf) ,[]),title('��H1�˲�����Ƶ�����еõ��Ľ���ľ���ֵ');

figure,
subplot(1,2,1),imshow( abs(gs) > 0.2*abs(max(gs(:))) ),title('�����˲���ֵ������Ľ��');
subplot(1,2,2),imshow( abs(gf) > 0.2*abs(max(gf(:))) ),title('Ƶ���˲���ֵ������Ľ��');

d=abs(gs-gf);
max(d(:))
min(d(:))