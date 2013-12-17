function im_r= ImgSyn(im_1_stirng,im_2_string,layout)
% Mege two images together, defined by parameter 'layout', if 'v', then
% vertically, if 'h', then horionztally
% input: ImgSyn=(im1,im2,'h');

if nargin<3
    layout='v';
end
im_1=im_1_stirng;
im_2=im_2_string;
% im_1=imread(im_1_stirng);
% im_2=imread(im_2_string);

% [h_im1,w_im1]=size(im_1);
% [h_im2,w_im2]=size(im_2);


switch layout
    case 'v'
        im_r=loc_cat_v(im_1,im_2);
    case 'h'
        im_r=loc_cat_h(im_1,im_2);
end
end

function im_r=loc_cat_v(im_1,im_2)
[im_1,im_2]=loc_align_size(im_1,im_2,2);
im_r=[im_1;im_2];

end
function im_r=loc_cat_h(im_1,im_2)
[im_1,im_2]=loc_align_size(im_1,im_2,1);

im_r=[im_1,im_2];

end
%B = imresize(A, [numrows numcols])
function [im_1,im_2]=loc_align_size(im_1,im_2,rc)
%align im_2 to im_1 based on the rows or columns in order to do matrix
%concatnation.
switch rc
    case 1 % row align
        max_r=max(size(im_1,1 ),size(im_2,1));
        im_1=imresize(im_1,[max_r,size(im_1,2)]);
        im_2=imresize(im_2,[max_r,size(im_2,2)]);
    case 2 % column align
        max_c=max(size(im_1,2 ),size(im_2,2));
        im_1=imresize(im_1,[size(im_1,1),max_c]);
        im_2=imresize(im_2,[size(im_2,1),max_c]);
end


end

