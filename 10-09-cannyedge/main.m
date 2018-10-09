function main()
    %����ͼ��
    [filename, pathname] = uigetfile({'*.jpg'; '*.bmp'; '*.gif'}, 'ѡ��ͼƬ');

    %û��ͼ��
    if filename == 0
        return;
    end

    imgsrc = imread([pathname, filename]);
    [y, x, dim] = size(imgsrc);

    %ת��Ϊ�Ҷ�ͼ
    if dim>1
        imgsrc = rgb2gray(imgsrc);
    end

    sigma = 1;
    gausFilter = fspecial('gaussian', [3,3], sigma);
    img= imfilter(imgsrc, gausFilter, 'replicate');

    zz = double(img);

     %----------------------------------------------------------
     %�Լ��ı�Ե��⺯��
     [m theta sector canny1  canny2 bin] = canny1step(img, 22);
      [msrc thetasrc sectorsrc c1src  c2src binsrc] = canny1step(imgsrc, 22);
     %Matlab�Դ��ı�Ե���
     ed = edge(img, 'canny', 0.5); 


    [xx, yy] = meshgrid(1:x, 1:y);

    figure(1)
        %mesh(yy, xx, zz);
        surf(yy, xx, zz);
        xlabel('y');
        ylabel('x');
        zlabel('Grayscale');
        axis tight

    figure(2)    
        subplot(4,2,1);
            imshow(imgsrc);%ԭͼ
            title('ԭͼ');
        subplot(4,2,2);
            imshow(img);%��˹�˲���
            title('��˹�˲���');
        subplot(4,2,3);
            imshow(uint8(m));%����
            title('����');
        subplot(4,2,4);
            imshow(uint8(canny1));%�Ǽ���ֵ����
            title('�Ǽ���ֵ����');
        subplot(4,2,5);
            imshow(uint8(canny2));%˫��ֵ
            title('˫��ֵ');
        subplot(4,2,6);
            imshow(ed);%Matlab�Դ���Ե���
            title('Matlab�Դ��ı�Ե���');
        subplot(4,2,8);
            imshow(bin);%���Լ���bin
            title('�Լ���˫��ֵ');

    figure(3)
        edzz = 255*double(ed);
        mesh(yy,xx,edzz);
        xlabel('y');
        ylabel('x');
        zlabel('Grayscale');
        axis tight 



    figure(4)
        mesh(yy,xx,m);%��ƫ����
        xlabel('y');
        ylabel('x');
        zlabel('Derivative');
        axis tight 

    figure(5)
        mesh(yy,xx,theta);
        xlabel('y');
        ylabel('x');
        zlabel('Theta');
        axis tight

    figure(6)
        mesh(yy,xx,sector);
        xlabel('y');
        ylabel('x');
        zlabel('Sector');
        axis tight

    figure(7)
        mesh(yy,xx,canny2);
        xlabel('y');
        ylabel('x');
        zlabel('Sector');
        axis tight
end
