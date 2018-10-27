function mvthtest()
f=imread('20180912140809.jpg');
f=rgb2gray(f);
T=graythresh(f);%ãÐÖµ
g1=im2bw(f,T);

g2=movingthresh(f,20,0.5);

subplot(2,2,1),imshow(f),title('origin');
subplot(2,2,2),imshow(T),title('ostu');
subplot(2,2,3),imshow(g1),title('im2bw');
subplot(2,2,4),imshow(g2),title('movingthresh');
end