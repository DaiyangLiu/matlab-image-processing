function resize_img=my_resize2(img,h,w)
I=imread(img);
[src_h,src_w,d]=size(I);
dst_h=h;
dst_w=w;

resize_img=uint8(zeros(dst_h,dst_w,d));

%Ë«ÏßÐÔ²åÖµ
for i=1:dst_w
    src_i=(i+0.5)*(src_w/dst_w)-0.5;
    i_small=floor(src_i);
    i_large=ceil(src_i);
    src_i=round(src_i);

    for j=1:dst_h
        src_j=(j+0.5)*(src_h/dst_h)-0.5;
        j_small=floor(src_j);
        j_large=ceil(src_j);
        src_j=round(src_j);
        %point1=I(j_small,i_small,:) + ( I(j_small,i_large,:) - I(j_small,i_small,:) ) * ( src_i - i_small );
        %point2=I(j_large,i_small,:) + ( I(j_large,i_large,:) - I(j_large,i_small,:) ) * ( src_i - i_small );

        %point3=point1 + ( point2 - point1 ) * ( src_j - j_small );  
        
        if i_small>0 && i_large<= src_w && j_small>0 && j_large <= src_h
            point1=((i_large-src_i)/(i_large-i_small)) *I(j_small,i_small,:) + ((src_i-i_small)/(i_large-i_small))*I(j_small,i_large,:);
            point2=((i_large-src_i)/(i_large-i_small)) *I(j_large,i_small,:) + ((src_i-i_small)/(i_large-i_small))*I(j_large,i_large,:);

            point3=((j_large-src_j)/(j_large-j_small))*point1 + ((src_j-j_small)/(j_large-j_small))*point2;

            resize_img(j,i,:)= point3;
        end
        %resize_img(j,i,:)= point3;
    end
end

end