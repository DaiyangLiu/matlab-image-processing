I=imread('pic2.png');
I=rgb2gray(I);
imtool(I)
J=imrotate(I,30);
imtool(J)