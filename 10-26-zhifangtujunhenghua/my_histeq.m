RGB = imread('Boston.jpg'); % ��ȡ��ɫͼ
subplot(121);
imshow(RGB);
title('��ɫͼ');

[R, C, K] = size(RGB); % ������K��ʾ��ɫͨ����

% ͳ��ÿ������ֵ���ִ���
cnt = zeros(K, 256);
for i = 1 : R
    for j = 1 : C
        for k = 1 : K
            cnt(k, RGB(i, j, k) + 1) = cnt(k, RGB(i, j, k) + 1) + 1;
        end
    end
end

f = zeros(3, 256);
f = double(f); cnt = double(cnt);

% ͳ��ÿ������ֵ���ֵĸ��ʣ� �õ�����ֱ��ͼ
for k = 1 : K
    for i = 1 : 256
        f(k, i) = cnt(k, i) / (R * C);
    end
end

% ���ۼƸ��ʣ��õ��ۼ�ֱ��ͼ
for k = 1 : K
    for i = 2 : 256
        f(k, i) = f(k, i - 1) + f(k, i);
    end
end

% ��f����ʵ������ֵ[0, 255]��ӳ�䡣 
for k = 1 : K
    for i = 1 : 256
        f(k, i) = f(k, i) * 255;
    end
end

% ���ÿ�����ص��ӳ��
for i = 1 : R
    for j = 1 : C
        for k = 1 : K
            RGB(i, j, k) = f(k, RGB(i, j, k) + 1);
        end
    end
end

% ���
RGB = uint8(RGB);
subplot(122);
imshow(RGB);
title('��ɫֱ��ͼ���⻯');
