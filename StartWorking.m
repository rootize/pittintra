function StartWorking
% StartWorking: Change the video paths, put multiple files here and then get a good sleep :)
% Main entry, indicate:
% 1. Path of first video file
% 2. Path of second video file
% 3. Indicate whether generate video or not
% Other m-files required: Entry
% Subfunctions: none
% MAT-files required: Entry.m
%
% See also: Entry

% Author: Zijun Wei     Research Associate 
% Robotics Institute    Carnegie Mellon University
% email address: hzwzijun@gmail.com 
% Website:  http://zijunwei.com/
% December 2013; Last revision: 

%------------- BEGIN CODE --------------
v_dir='C:\Users\Zijun\Documents\Session\Data';
v1='RA038_child_rabc.mp4';
v2='RA038_examiner_rabc.mp4';
Entry(fullfile(v_dir,v1),fullfile(v_dir,v2),1);

v1='RA039_child_rabc.mp4';
v2='RA039_examiner_rabc.mp4';
Entry(fullfile(v_dir,v1),fullfile(v_dir,v2),1);


v1='RA042_child_rabc.mp4';
v2='RA042_examiner_rabc.mp4';
Entry(fullfile(v_dir,v1),fullfile(v_dir,v2),1);

v1='RA043_child_rabc.mp4';
v2='RA043_examiner_rabc.mp4';
Entry(fullfile(v_dir,v1),fullfile(v_dir,v2),1);

v1='RA056_child_rabc.mp4';
v2='RA056_examiner_rabc.mp4';
Entry(fullfile(v_dir,v1),fullfile(v_dir,v2),1);

v1='RA051_child_rabc.mp4';
v2='RA051_examiner_rabc.mp4';
Entry(fullfile(v_dir,v1),fullfile(v_dir,v2),1);


v1='RA052_child_rabc.mp4';
v2='RA052_examiner_rabc.mp4';
Entry(fullfile(v_dir,v1),fullfile(v_dir,v2),1);


v1='RA045_child_rabc.mp4';
v2='RA045_examiner_rabc.mp4';
Entry(fullfile(v_dir,v1),fullfile(v_dir,v2),1);
end
%------------- END OF CODE --------------
