function imopen_close_fingerprint()
%��ʴ�뿪��������ָ��ͼ���ϵ�Ӧ�öԱ�
clc
clear
f=imread('DIP3E_CH09_Original_Images\DIP3E_Original_Images_CH09\Fig0911(a)(noisy_fingerprint).tif');

subplot(121),imshow(f);
title('ָ��ԭʼͼ��');

se=strel('square',3);%�߳�Ϊ3�ķ��νṹԪ��
A=imerode(f,se);%��ʴ
subplot(122),imshow(A);
title('��ʴ���ָ��ԭʼͼ��');


fo=imopen(f,se);
figure,subplot(221),imshow(fo);
title('ʹ��square(3)���������ͼ��');


fc=imclose(f,se);
subplot(222),imshow(fc);
title('ʹ��square�ղ������ͼ��');

foc=imclose(fo,se);
subplot(223),imshow(foc);
title('ʹ��square(3)�ȿ���ղ������ͼ��')

fco=imopen(fc,se);
subplot(224),imshow(fco);
title('ʹ��square(3)�ȱպ󿪲������ͼ��');
end