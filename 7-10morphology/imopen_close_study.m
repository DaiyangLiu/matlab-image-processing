function imopen_close_study()
%������ͱ�����
clc
clear
f=imread('DIP3E_CH09_Original_Images\DIP3E_Original_Images_CH09\FigP0917(noisy_rectangle).tif');
%se=strel('square',10');%���ͽṹԪ��
se=strel('disk',20');%Բ���ͽṹԪ��
imshow(f);%ԭͼ��
title('��������ԭʼͼ��');


%��������ѧ�����ȸ�ʴ�����͵Ľ�� %�������������Ϊ��ȫɾ���˲��ܰ����ṹԪ�صĶ�������ƽ��
%�˶�����������Ͽ�����խ�����ӣ�ȥ����ϸС��ͻ������
fo=imopen(f,se);%ֱ�ӿ�����
figure,subplot(221),imshow(fo);
title('ֱ�ӿ�����');



%����������ѧ�����������ٸ�ʴ�Ľ��
%�������������Ҳ�ǻ�ƽ������������������뿪���㲻ͬ���ǣ�������
%һ��Ὣ��խ��ȱ�����������γ�ϸ������ڣ������ȽṹԪ��С�Ķ�
fc=imclose(f,se);%ֱ�ӱ�����
subplot(222),imshow(fc);
title('ֱ�ӱ�����');

foc=imclose(fo,se);%�ȿ��������
subplot(223),imshow(foc);
title('�ȿ��������');
fco=imopen(fc,se);%�ȱպ�����
subplot(224),imshow(fco);
title('�ȱպ�����');
end