%http://blog.sciencenet.cn/home.php?mod=space&uid=425437&do=blog&id=1046849
%==========================================================================
%                     ����ͼ�����/Ƶ���˲��Ա�ʾ������
%           name: mySFFilt2Demo.m
%           Author��Peng Zhenming 
%           School of Opto-Electronic Information, 
%           University of Electronic Science and Technology of China
%           Date: 2017.04.03
% =========================================================================
clc;clf;clear all;close all;
%==========================================================================
inimg = imread('cameraman.tif');
subplot(131)
imshow(inimg),title('Original image')
[M,N] = size(inimg);                    % Original image size
%==========================================================================
% �����˲�������
%h = ones(3,3)/(3^2);                   % average
%h = [-1 0 1;-2 0 2;-1 0 1];            % sobel
%h = [0 1 0;1 -4 1;0 1 0];              % laplacian
h = fspecial('gaussian',25,4);          % gaussian
%==========================================================================
% �����˲�
gx = imfilter(double(inimg),h,'same','replicate');
subplot(132)
imshow(gx,[]);title('Spatial domain filtering')
%==========================================================================
% Ƶ���˲�
%==========================================================================
h_hf = floor(size(h)/2);   % ���/��
imgp = padarray(inimg,[h_hf(1),h_hf(2)],'replicate'); % Padding image
%PQ = paddedsize(size(imgp));
PQ = 2*size(imgp);
Fp = fft2(double(imgp), PQ(1), PQ(2)); % ͼ�������غ�FFT
h  = rot90(h,2);                       % mask��ת180��
%Hp = fft2(h, PQ(1), PQ(2));           % �˲����������غ�FFT��δ��ѭ����λ��

%==========================================================================
% �˲������������Ƶ�������������Ͻ�
%==========================================================================
P = PQ(1);Q = PQ(2);
%center_h = ceil((size(h) + 1)/2);  % ȷ��ԭ�˲���h���ĵ�����
center_h = h_hf+1;                  % ȷ��ԭ�˲���h���ĵ�����
hp = zeros(P,Q);                    % ����ȫ�����
hp(1:size(h,1), 1:size(h,2)) = h;   % ��������غ�h����hp���Ͻ�
%==========================================================================
% h���ĵ�����hp�����ϽǷ�ʽ֮һ ����ѡ��ʽ,��Чcircshift������
% row_indices = [center_h(1):P, 1:(center_h(1)-1)]'; 
% col_indices = [center_h(2):Q, 1:(center_h(2)-1)];
% hp = hp(row_indices, col_indices);  
%==========================================================================
% h���ĵ�����hp�����ϽǷ�ʽ֮��:ֱ�ӵ���matlab��ѭ����λ������
hp = circshift(hp,[-(center_h(1)-1),-(center_h(2)-1)]); 
%==========================================================================
Hp = fft2(double(hp));
%==========================================================================
Gp = Hp.*Fp;                        % Ƶ���˲�
gp = real(ifft2(Gp));               % ���任��ȡʵ��
%gf = gp(1:M,1:N);                  % ��ȡ��Ч���ݣ�δ��ѭ����λʱ���ã�
gf = gp(h_hf(1)+1:M + h_hf(1), h_hf(2)+1:N + h_hf(2));  %��ȡ��Ч����
subplot(133)
imshow(gf,[]),title('Frequency domain filtering')