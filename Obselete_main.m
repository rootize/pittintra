%% provide video files for synchronization

close all;
clear;
clc;
%%


input1='.\Data\RA054_2012_08_09_canon_child_rabc.avi';
input2='.\Data\RA054_2012_08_09_canon_examiner_rabc.mp4';

[file_dir1,file_name1,file_ext1]=fileparts(input1);
[file_dir2,file_name2,file_ext2]=fileparts(input2);

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
    offset=readdata.offset;
    v1_startid=readdata.v1_startid;
    v2_startid=readdata.v2_startid;
    clip_length=readdata.clip_length;
else
    offset=synchronizeAudio(input1,input2);
    % testOffset(fullfile(audio_path,audio1),fullfile(audio_path,audio2),offset,100);
    %% Using results generated from previous part to get length and startid of eahc video clip
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
                    cleanTempFile(tempinfo_dir);
            end
            
    end
        
end
%% calculate the offset of two videos
% if offset is positive, it means that audio1 is x frame ahead of
% audio2 and vice versa

%% Doing intraface-pittpatt on videos
Expedition_pittpatt_intrface(input1,1,v1_startid,clip_length);
disp('part1_finished\n');
%%
Expedition_pittpatt_intrface(input2,1,v2_startid,clip_length);
disp('part2_finished!\n'); 
%%
% percepts=[];
% percepts=generatePercepts(percepts,1,fullfile(audio_path,audio1),'child');
% startid_2=length(percepts)+1;
% percepts=generatePercepts(percepts,startid_2,fullfile(audio_path,audio2),'examiner');
% %%
% savePercepts(percepts,fullfile(audio_path,audio1),fullfile(audio_path,audio2));

%% Generating percepts
% using audio2's time as reference

% event
% percept=[];
% load(fullfile(matpath,'ch.mat'));
% percept.name='child_face_detection_rects';
% percept.description='Faces from single image, returning 2 points: x1 y1, x2 y2 representing upperleft and bottom right of faces  hzwzijun@gmail.com';
% percept.updatedate=date;
% percept.contact='hzwzijun@gmail.com';
% rects_child_info=rects_info;
% event=[];
% frame2millisecond=33.33;
% % rect_info
% for i=1:1:length(rects_info)
% event{i}.starttime=(rects_child_info(i).frameid-1)*frame2millisecond;
% event{i}.endtime=(rects_child_info(i).frameid)*frame2millisecond;
% event{i}.value=[rects_child_info(i).rectinfo.x1,rects_child_info(i).rectinfo.y1,rects_child_info(i).rectinfo.x2,rects_child_info(i).rectinfo.y2];
% event{i}.confidence=rects_child_info(i).rectinfo.confidence;
%
%
% end
% percept.events=event;
% session.percepts{3}=percept;
% %% child face orientation
% percept=[];
% load(fullfile(matpath,'ch.mat'));
% percept.name='child_face_detection_rotation';
% percept.description='using pittpatt to detect faces rotation(yaw, roll, pitch) provided by pittpatt hzwzijun@gmail.com';
% percept.updatedate=date;
% percept.contact='hzwzijun@gmail.com';
%
% rects_child_info=rects_info;
% event=[];
% frame2millisecond=33.33;
% % rect_info
% for i=1:1:length(rects_info)
% event{i}.starttime=(rects_child_info(i).frameid-1)*frame2millisecond;
% event{i}.endtime=(rects_child_info(i).frameid)*frame2millisecond;
% event{i}.value=[rects_child_info(i).rectinfo.yaw,rects_child_info(i).rectinfo.rot,rects_child_info(i).rectinfo.pitch];
% event{i}.confidence=rects_child_info(i).rectinfo.confidence;
%
%
% end
% percept.events=event;
% percept.contact='hzwzijun@gmail.com';
%
% session.percepts{4}=percept;
%
%
% percept.name='child_face_detection_facial landmarks';
% percept.description='using pittpatt to detect 49 face landmarks (x,y)from single image, provided by intraface, hzwzijun@gmail.com';
% percept.updatedate=date;
% percept.contact='hzwzijun@gmail.com';
%
% rects_child_info=landmarks_info;
% event=[];
% frame2millisecond=33.33;
% % rect_info
% for i=1:1:length(rects_child_info)
% event{i}.starttime=(rects_child_info(i).frameid-1)*frame2millisecond;
% event{i}.endtime=(rects_child_info(i).frameid)*frame2millisecond;
% event{i}.value=rects_child_info.pred;
% event{i}.confidence=eye(49);
%
%
% end
% percept.events=event;
% session.percepts{5}=percept;
%
%
% percept.name='child_face_detection_facial orientation';
% percept.description='orientation infomation provided by intraface hzwzijun@gmail.com';
% percept.updatedate=date;
% percept.contact='hzwzijun@gmail.com';
%
% rects_child_info=landmarks_info;
% event=[];
% frame2millisecond=33.33;
% % rect_info
% for i=1:1:length(rects_child_info)
% event{i}.starttime=(rects_child_info(i).frameid-1)*frame2millisecond;
% event{i}.endtime=(rects_child_info(i).frameid)*frame2millisecond;
% event{i}.value=rects_child_info(i).pose;
% event{i}.confidence=eye(3);
%
% end
% percept.events=event;
% session.percepts{6}=percept;
%
% %% examiner
%
%
% %% Import Face detector information
%
% % child's face
% percept=[];
% load(fullfile(matpath,'ex.mat'));
% percept.name='examiner_face_detection_rects';
% percept.description='Faces from single image, returning 2 points: x1 y1, x2 y2 representing upperleft and bottom right of faces  hzwzijun@gmail.com';
% percept.updatedate=date;
% percept.contact='hzwzijun@gmail.com';
%
% rects_child_info=rects_info;
% event=[];
% frame2millisecond=33.33;
% % rect_info
% for i=1:1:length(rects_child_info)
% event{i}.starttime=(rects_child_info(i).frameid-1)*frame2millisecond;
% event{i}.endtime=(rects_child_info(i).frameid)*frame2millisecond;
% event{i}.value=[rects_child_info(i).rectinfo.x1,rects_child_info(i).rectinfo.y1,rects_child_info(i).rectinfo.x2,rects_child_info(i).rectinfo.y2];
% event{i}.confidence=rects_child_info(i).rectinfo.confidence;
%
%
% end
% percept.events=event;
% session.percepts{7}=percept;
% %% ex face orientation
% percept=[];
% load(fullfile(matpath,'ex.mat'));
% percept.name='examiner_face_detection_rotation';
% percept.description='using pittpatt to detect faces rotation(yaw, roll, pitch) provided by pittpatt hzwzijun@gmail.com';
% percept.updatedate=date;
% percept.contact='hzwzijun@gmail.com';
%
% rects_child_info=rects_info;
% event=[];
% frame2millisecond=33.33;
% % rect_info
% for i=1:1:length(rects_child_info)
% event{i}.starttime=(rects_child_info(i).frameid-1)*frame2millisecond;
% event{i}.endtime=(rects_child_info(i).frameid)*frame2millisecond;
% event{i}.value=[rects_child_info(i).rectinfo.yaw,rects_child_info(i).rectinfo.rot,rects_child_info(i).rectinfo.pitch];
% event{i}.confidence=rects_child_info(i).rectinfo.confidence;
%
%
% end
% percept.events=event;
% session.percepts{8}=percept;
%
%
% percept.name='examiner_face_detection_facial landmarks';
% percept.description='using pittpatt to detect 49 face landmarks (x,y)from single image, provided by intraface, hzwzijun@gmail.com';
% percept.updatedate=date;
% percept.contact='hzwzijun@gmail.com';
%
% rects_child_info=landmarks_info;
% event=[];
% frame2millisecond=33.33;
% % rect_info
% for i=1:1:length(rects_child_info)
% event{i}.starttime=(rects_child_info(i).frameid-1)*frame2millisecond;
% event{i}.endtime=(rects_child_info(i).frameid)*frame2millisecond;
% event{i}.value=rects_child_info(i).pred;
% event{i}.confidence=eye(49);
%
%
% end
% percept.events=event;
% session.percepts{9}=percept;
%
%
% percept.name='examiner_face_detection_facial orientation';
% percept.description='orientation infomation provided by intraface hzwzijun@gmail.com';
% percept.updatedate=date;
%
% rects_child_info=landmarks_info;
% event=[];
% frame2millisecond=33.33;
% % rect_info
% for i=1:1:length(rects_child_info)
% event{i}.starttime=(rects_child_info(i).frameid-1)*frame2millisecond;
% event{i}.endtime=(rects_child_info(i).frameid)*frame2millisecond;
% event{i}.value=rects_child_info(i).pose;
% event{i}.confidence=eye(3);
%
%
% end
% percept.events=event;
% session.percepts{10}=percept;
%
% save('R49_Face_detection.mat','session');
%% merge videos



% [~,img_folder1,extension1]=fileparts(audio1);
% [~,img_folder2,extension2]=fileparts(audio2);
%
% FileFolder1=fullfile(audio_path,img_folder1);
% FileFolder2=fullfile(audio_path,img_folder2);
%
% v1=30;
% videoO=VideoWriter(fullfile( pwd,'suc.avi'));
% videoO.FrameRate=30;
% open(videoO);
% for i=1:1:4227
%    fprintf('processing %d th image\n',i);
%
%       v1_frame=imread(fullfile(FileFolder1,sprintf('%.05d.png',i)));
%       v2_frame=imread(fullfile(FileFolder2,sprintf('%.05d.png',i)));
%
%     v_syn=ImgSyn(v1_frame,v2_frame,'h');
%     writeVideo(videoO,v_syn);
% end
% close(videoO);
%
%
% save([date,'3.mat']);
% a1=audioread(fullfile(audio_path,audio1));
% figure
%
% subplot(3,1,1);
% plot(1:length(a1),a1(:,1));
% subplot(3,1,2);
% plot(1:length(a1),a1(:,2));
%
% self_cor=xcorr(a1(:,1),a1(:,2));
% [max_v,indx]=max(self_cor);
% subplot(3,1,3);
% plot(1:length(self_cor),self_cor);
% cross correlation ?

