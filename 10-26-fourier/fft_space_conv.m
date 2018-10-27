I=imread('cameraman.tif');
figure,imshow(I);title('original');

h=fspecial('gaussian',[7 7],1);
I=double(I);
J=imfilter(I,h,'same','circular');
figure,imshow(J,[]);title('blur by gaussian kernal');

 FI=fft2(I);
 hsame= zeros(256,256);
% hsame(126:132,126:132)=h;
 hsame(1:7,1:7)=h;
%hsame(1:7,1:7)=h;
 FH=fft2(hsame);
 Result=ifft2(FI.*FH);
 
 figure,imshow(uint8(Result));title('reverse from FFT');
 

 PQ=psf2otf(h,[256 256]);
 r2=ifft2(FI.*PQ);
  figure,imshow(r2,[]);
 
  
  Q1= zeros(256,256);
% Q1(125:131,125:131)=h;
 Q1(126:132,126:132)=h;
 Q1=fftshift(Q1);
 FQ1=fft2(Q1);
  r3=ifft2(FI.*FQ1);
    figure,imshow(r3,[]);