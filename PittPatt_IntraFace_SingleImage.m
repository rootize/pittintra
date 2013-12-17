function  PittPatt_IntraFace_SingleImage( input_img )
%PITTPATT_INTRAFACE_SINGLEIMAGE Summary of this function goes here
%   Detailed explanation goes here
%   Given an image path.

if ischar(input_img)
    input_img_path=input_img;
elseif ismatrix(input_img)
    input_img_path='temp.png';
    imwrite(input_img_path,input_img); 
else
    error('Invalid Input');
end
pre_Pittpatt_Intraface();
meta_Pittpatt_Intraface(input_img_path);
final_Pittpatt_Intraface();


end

