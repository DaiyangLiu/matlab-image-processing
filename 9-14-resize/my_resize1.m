function resize_img=my_resize1(img,h,w)
I=imread(img);
[src_h,src_w,d]=size(I);
dst_h=h;
dst_w=w;

resize_img=uint8(zeros(dst_h,dst_w,d));

%×îÁÚ½ü²åÖµ
for i=1:dst_w
    src_i=round(i*(src_w/dst_w));
    for j=1:dst_h
        src_j=round(j*(src_h/dst_h));
        resize_img(j,i,:)= I(src_j,src_i,:);
    end
end

end


% new_img=my_resize('Boston.jpg',500,800);
% imshow(new_img)