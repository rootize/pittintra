function Entry(input1,input2,save_video_flag)
%ENTRY - Synchronize two input video and run pittpatt-intraface on two
%images. One can choose to visualize the reuslts or not. After the step of
%synchronization, function will ask for mannual verification. One can
%choose to watch a 150 frame video to check if it is synchronized
%
% Syntax:    Entry(video_file1,video_file2,save_flag)
%
% Inputs:
%    video_file1 - path of the first video
%    video_file2 - path of the second video
%    save_flag   - whether write results to images or not
%
% Outputs:
%
% Example:
%   v_dir='C:\Users\Zijun\Documents\Session\Data';
%   v1='RA038_child_rabc.mp4';
%   v2='RA038_examiner_rabc.mp4';
%   Entry(fullfile(v_dir,v1),fullfile(v_dir,v2),1);
%
% Other m-files required: synchronizeAudio getStartIDandLength testoffset
%                         cleanTempFile Expedition_pittpatt_intrface
%                         generatePerceptsFromSingle mergeVideos
% Subfunctions: none
%


% Author: Zijun Wei     Research Associate
% Robotics Institute    Carnegie Mellon University
% email address: hzwzijun@gmail.com
% Website:  http://zijunwei.com/
% December 2013; Last revision:

%------------- BEGIN CODE --------------



[file_path1,file_name1,~]=fileparts(input1);
[file_path2,file_name2,~]=fileparts(input2);

con_name=strcat(file_name1,file_name2);
syn_prefix='syninfo_';
mat_suffix='.mat';

syninfo_file=strcat(syn_prefix,con_name,mat_suffix);
tempinfo_dir='tempinfo_dir';
% create a temp dir to save data in case program halts half way
if ~exist(tempinfo_dir,'dir')
    mkdir(tempinfo_dir);
end
if exist(fullfile(tempinfo_dir,syninfo_file),'file')
    readdata=load(fullfile(tempinfo_dir,syninfo_file));
    v1_startid=readdata.v1_startid;
    v2_startid=readdata.v2_startid;
    clip_length=readdata.clip_length;
else
    offset=synchronizeAudio(input1,input2);
    % Using results generated from previous part to get length and startid of eahc video clip
    [v1_startid,v2_startid,clip_length]=getStartIDandLength(input1,input2,offset);
    save(fullfile(tempinfo_dir,syninfo_file),'offset','v1_startid','v2_startid','clip_length');
    keyinput=input('offset has been generated, do you want to visually check? Y/N:','s');
    if isempty(keyinput)
        keyinput='N' ;
    end
    switch upper(keyinput)
        case 'N'
        case 'Y'
            testoffset(input1,input2,offset,100);
            keyinput2=input('Please check  test.avi,correct?  Y/N \n','s');
            if isempty(keyinput2)
                keyinput2='Y';
            end
            switch upper(keyinput2)
                case  'Y'
                    disp('please rerun the code to generate pittpatt-intraface reuslts, thanks ;) \n');
                    exit;
                case 'N'
                    disp('soory, Currently we cannot synchronize the two videos\n');
                    delete(fullfile(tempinfo_dir,syninfo_file));
            end
            
    end
    
end

%% Doing intraface-pittpatt on videos
Expedition_pittpatt_intrface(input1,save_video_flag,v1_startid,clip_length);
disp('part1_finished\n');
Expedition_pittpatt_intrface(input2,save_video_flag,v2_startid,clip_length);
disp('part2_finished!\n');

%% generate percepts:
percepts=[];
percepts=generatePerceptsFromSingle(percepts,1,input1,'child');

startid2=length(percepts);
percepts=generatePerceptsFromSingle(percepts,startid2+1,input2,'examiner');

save(strcat(con_name,'_percepts','.mat'),'percepts');

%% generate videos if indicated
if save_video_flag==1
    disp('generating videos\n')
    mergeVideos(input1,input2);
    disp(strcat('video has been saved to file:',con_name,'.avi'));
end

%% Cleaning up the environment
 % clean up the temp_info:
 delete(fullfile(tempinfo_dir,syninfo_file));
 rmdir(fullfile(file_path1,file_name1));
 rmdir(fullfile(file_path1,[file_name1,'_mat']));
 rmdir(fullfile(file_path2,file_name2));
 rmdir(fullfile(file_path2,[file_name2,'_mat']));
end
%------------- END OF CODE --------------
