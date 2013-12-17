function [ v1_startid,v2_startid,clip_length ] = getStartIDandLength( v1_path,v2_path,offset )
%GETSTARTIDANDLENGTH Summary of this function goes here
%   Detailed explanation goes here
if nargin<2
    error('At least two file paths have to be provided');
end
if nargin<3
    offset=0;
end

[~,num_frames1]=local_findFPSandLength(v1_path);
[~,num_frames2]=local_findFPSandLength(v2_path);

abs_offset=abs(offset);
if offset<0
    v1_startid=1+abs_offset;
    v2_startid=1;
    clip_length=min(num_frames2,num_frames1-abs_offset);
else
    v1_startid=1;
    v2_startid=1+abs_offset;
    clip_length=min(num_frames2-abs_offset,num_frames1);
    
end

end
function [fps,frame_l]=local_findFPSandLength(v_path)

videoObj=VideoReader(v_path);
frame_l=videoObj.NumberOfFrames;
fps=videoObj.FrameRate;


end
