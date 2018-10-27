%http://blog.sciencenet.cn/home.php?mod=space&uid=425437&do=blog&id=1046849
%==========================================================================
%                     数字图像空域/频域滤波对比示例代码
%           name: mySFFilt2Demo.m
%           Author：Peng Zhenming 
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
% 空域滤波器生成
%h = ones(3,3)/(3^2);                   % average
%h = [-1 0 1;-2 0 2;-1 0 1];            % sobel
%h = [0 1 0;1 -4 1;0 1 0];              % laplacian
h = fspecial('gaussian',25,4);          % gaussian
%==========================================================================
% 空域滤波
gx = imfilter(double(inimg),h,'same','replicate');
subplot(132)
imshow(gx,[]);title('Spatial domain filtering')
%==========================================================================
% 频域滤波
%==========================================================================
h_hf = floor(size(h)/2);   % 半宽/高
imgp = padarray(inimg,[h_hf(1),h_hf(2)],'replicate'); % Padding image
%PQ = paddedsize(size(imgp));
PQ = 2*size(imgp);
Fp = fft2(double(imgp), PQ(1), PQ(2)); % 图像补零延拓后FFT
h  = rot90(h,2);                       % mask旋转180度
%Hp = fft2(h, PQ(1), PQ(2));           % 滤波器补零延拓后FFT（未做循环移位）

%==========================================================================
% 滤波器中心像素移到延拓区域的左上角
%==========================================================================
P = PQ(1);Q = PQ(2);
%center_h = ceil((size(h) + 1)/2);  % 确定原滤波器h中心点坐标
center_h = h_hf+1;                  % 确定原滤波器h中心点坐标
hp = zeros(P,Q);                    % 生成全零矩阵
hp(1:size(h,1), 1:size(h,2)) = h;   % 零填充延拓后，h置于hp左上角
%==========================================================================
% h中心点置于hp的左上角方式之一 （可选方式,等效circshift函数）
% row_indices = [center_h(1):P, 1:(center_h(1)-1)]'; 
% col_indices = [center_h(2):Q, 1:(center_h(2)-1)];
% hp = hp(row_indices, col_indices);  
%==========================================================================
% h中心点置于hp的左上角方式之二:直接调用matlab（循环移位）函数
hp = circshift(hp,[-(center_h(1)-1),-(center_h(2)-1)]); 
%==========================================================================
Hp = fft2(double(hp));
%==========================================================================
Gp = Hp.*Fp;                        % 频域滤波
gp = real(ifft2(Gp));               % 反变换，取实部
%gf = gp(1:M,1:N);                  % 截取有效数据（未做循环移位时调用）
gf = gp(h_hf(1)+1:M + h_hf(1), h_hf(2)+1:N + h_hf(2));  %截取有效数据
subplot(133)
imshow(gf,[]),title('Frequency domain filtering')