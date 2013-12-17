function  testOffset( video1,video2,offset,vid_length )
%TESTOFFSET Test of offset provided by function synchronizeAudio 
%
% Syntax:    testOffset(video1,video2,offset,vid_length)
%
% Inputs:
%    video1 - path to video1
%    video2 - path to video2
%    offset - the offset computed by synchronizeAudio function
%    vid_length -  length of test video in frames
%
% Outputs:
%    no output: check the video called "test.avi" in current folder
%    
%
% Example: 
%    testOffset('/test1.avi','/test2.avi',-5)
%    testOffset('/test1.avi','/test2.avi',-5,100)
%    
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
% 
%
% See also: SYNCHRONIZEAUDIO

% Author: Zijun Wei     Research Associate 
% Robotics Institute    Carnegie Mellon University
% email address: hzwzijun@gmail.com 
% Website:  http://zijunwei.com/
% December 2013; Last revision: 

%------------- BEGIN CODE --------------
if nargin<4
    
   vid_length=100;
end
videoObj1=VideoReader(video1);
videoObj2=VideoReader(video2);
if offset<0 % video1 1...N  video2:
    startid=1;
else
    startid=offset+1;
end
videoWriter=VideoWriter('test.avi');
videoWriter.open;

for i=startid:1:startid+vid_length
im1=videoObj1.read(i);
im2=videoObj2.read(i-offset);
im=ImgSyn(im1,im2,'h');
videoWriter.writeVideo(im);
    
end

videoWriter.close;
end

%------------- END OF CODE --------------
