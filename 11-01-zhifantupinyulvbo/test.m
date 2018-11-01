I=imread('lena.jpg');
I=rgb2gray(I);
hi = imhist(I);
plot(hi);

f=fft(hi);
fc=fftshift(f);
figure,plot(fc);