function rice_count()
clear;
close all;
I = imread('rice.png');
[width,height] = size(I);
J = edge(I,'canny');
%figure,imshow(J);
K = imfill(J,'holes');
%figure,imshow(K);
SE = strel('disk',3);%用于膨胀腐蚀及开闭运算等操作的结构元素对象
%对图像实现开运算，开运算一般能平滑图像的轮廓，消弱狭窄的部分，去掉细的突出。
L = imopen(K,SE);
figure,imshow(L);
L = uint8(L);%把L由logic类型转化为uint8类型
for i = 1:height
    for j = 1:width
        if L(i,j) == 1
            L(i,j) = 255;%把白色像素点像素值赋值为255
        end
    end
end
MAXSIZE = 999999;
Q = zeros(MAXSIZE,2);%用数组模拟队列,存储像素点坐标
front = 1;%指明队头的位置
rear = 1;%指明队尾的下一个位置；front=rear表示队空
flag = 0;%米粒的标号
 
for i = 1:height
    for j = 1:width
        if L(i,j) == 255%白色像素点入队列
            if front == rear%队列空，找到新米粒，米粒标号加一
                flag = flag+1;
            end
            L(i,j) = flag;%给白色像素赋值为米粒的标号
            Q(rear,1) = i;
            Q(rear,2) = j;
            rear = rear+1;%队尾后移
            while front ~= rear
                %队头出队
                temp_i = Q(front,1);
                temp_j = Q(front,2);
                front = front + 1;
                %把队头位置像素点8连通邻域中未作标记的白色像素点入队,并加上米粒标号
                %左上角的像素点
                if L(temp_i - 1,temp_j - 1) == 255
                    L(temp_i - 1,temp_j - 1) = flag;
                    Q(rear,1) = temp_i - 1;
                    Q(rear,2) = temp_j - 1;
                    rear = rear + 1;
                end
                %正上方的像素点
                if L(temp_i - 1,temp_j) == 255
                    L(temp_i - 1,temp_j) = flag;
                    Q(rear,1) = temp_i - 1;
                    Q(rear,2) = temp_j;
                    rear = rear + 1;
                end
                %右上方的像素点
                if L(temp_i - 1,temp_j + 1) == 255
                    L(temp_i - 1,temp_j + 1) = flag;
                    Q(rear,1) = temp_i - 1;
                    Q(rear,2) = temp_j + 1;
                    rear = rear + 1;
                end
                %正左方的像素点
                if L(temp_i,temp_j - 1) == 255
                    L(temp_i,temp_j - 1) = flag;
                    Q(rear,1) = temp_i;
                    Q(rear,2) = temp_j - 1;
                    rear = rear + 1;
                end
                %正右方的像素点
                if L(temp_i,temp_j + 1) == 255
                    L(temp_i,temp_j + 1) = flag;
                    Q(rear,1) = temp_i;
                    Q(rear,2) = temp_j + 1;
                    rear = rear + 1;
                end
                %左下方的像素点
                if L(temp_i + 1,temp_j - 1) == 255
                    L(temp_i + 1,temp_j - 1) = flag;
                    Q(rear,1) = temp_i + 1;
                    Q(rear,2) = temp_j - 1;
                    rear = rear + 1;
                end
                %正下方的像素点
                if L(temp_i + 1,temp_j) == 255
                    L(temp_i + 1,temp_j) = flag;
                    Q(rear,1) = temp_i + 1;
                    Q(rear,2) = temp_j;
                    rear = rear + 1;
                end
                %右下方的像素点
                if L(temp_i + 1,temp_j + 1) == 255
                    L(temp_i + 1,temp_j + 1) = flag;
                    Q(rear,1) = temp_i + 1;
                    Q(rear,2) = temp_j + 1;
                    rear = rear + 1;
                end
            end
        end
    end
end



figure,imshow(L);
RiceNumber = flag;%记录米粒的总个数
disp('米粒的总个数:')
RiceNumber
RiceArea = zeros(1,RiceNumber);%记录各米粒的大小
for i = 1:height
    for j = 1:width
        if L(i,j) ~= 0
            RiceArea(L(i,j)) = RiceArea(L(i,j)) + 1;
        end
    end
end
disp('各米粒的大小(按照从上往下，从左往右的顺序)：')
RiceArea

end