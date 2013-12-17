function FileTtl = getContinueID( type_file )
%GETCONTINUEID get the number of files of specific types in one folder.
% Syntax:  continueid = getContinueID(type_file)
%
% Inputs:
%    type_file - files formats in specified folder of specified name
%
% Outputs:
%    FileTtl - Number of such files in folder
%
% Example: 
%   imgFilenum=getContinueID(fullfile(mat_save_folder,'*_rect_info.mat'));
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% 

% Author: Zijun Wei     Research Associate 
% Robotics Institute    Carnegie Mellon University
% email address: hzwzijun@gmail.com 
% Website:  http://zijunwei.com/
% December 2013; Last revision: 

%------------- BEGIN CODE --------------
imgFilenum=dir(type_file);
FileTtl=length(imgFilenum(not([imgFilenum.isdir])));

end
%------------- END CODE --------------
