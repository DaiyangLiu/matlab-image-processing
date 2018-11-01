clear all;
I=imread('lena.jpg');
I=rgb2gray(I);
I_i = imhist(I);
figure,plot(I_i);title('I_i');
%�ź�����
N=256*2;
hi=zeros(N,1);
hi(1:N/2)=I_i;

%һά��ɢ���ұ任

ft=size(hi);

Cu=1.0;
for u=1:N
    if u==0
          Cu=1.0/sqrt(2);
    end 
    sum=0;
    for x=1:N
        sum=sum + hi(x)*cos((2*x+1)*u*pi/(2*N));
    end    
    temp=Cu * sqrt(2.0/N)*sum;
    ft(u)=temp;
end

ft=int16(ft);
figure,
subplot(2,1,1),plot(ft);title('ft');

%Ƶ���˲� 
%�˲��� h=[1*50 *]
hp=zeros(N,1);
d=50;
hp(1:d)=1;


result=size(hi);
for u=1:N
    if u==0
          Cu=1.0/sqrt(2);
    end 
    result(u)=Cu * hp(u) * ft(u);
end
subplot(2,1,2),plot(result);title('result');

new_hi=size(hi);
%����Ҷ���任
for x=1:N
    sum=0;         
    for u=1:N
        sum=sum + result(u)*cos((2*x+1)*u*pi/(2*N));
    end
%     if hi(x)==0
%         sum=0
%     end  
    temp=sqrt(2.0/N)*sum;
    new_hi(x)=abs(temp);
end

new_hi=int16(new_hi);
figure,
subplot(2,1,1),plot(hi);title('hi');
subplot(2,1,2),plot(new_hi);title('new hi');