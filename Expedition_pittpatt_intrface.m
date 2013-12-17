function Expedition_pittpatt_intrface(video_file,save_flag,startid,clip_length)
%Expedition_pittpatt_intrface - given a video file, compute face-location
%using pittpatt and face lanmarks, face orientation using intraface. Save
%data to the folder video file located at with the same name as videofile_mat,
%if save_flag indicated, save images to the folder "videofile"
%
% Syntax:   Expedition_pittpatt_intrface(video_file,save_flag,startid,clip_length)
%
% Inputs:
%    video_file  - path of video to be processed
%    save_flag   - save visualization or not Default: 0
%    startid     - start frame number of video. Provided by function
%    synchronizeAudio Default: 1
%    clip_length - number of frames to process. Provided by function
%    synchronizeAudio Default: all the frames in audio
%
%
%
% Other m-files required: FaceDetectPittPattWindows.m xx_initialize.m,
%                         xx_initialize2.m 
%


% Author: Zijun Wei     Research Associate 
% Robotics Institute    Carnegie Mellon University
% email address: hzwzijun@gmail.com 
% Website:  http://zijunwei.com/
% December 2013; Last revision: 

%------------- BEGIN CODE --------------


if nargin<2
   save_flag=0; 
end
if nargin<3
   startid=1; 
end
if nargin<4
   clip_length=100000000000000; 
end
[video_folder, video_name, ~]=fileparts(video_file);
img_save_folder=fullfile(video_folder,video_name);
mat_save_folder=fullfile(video_folder,[video_name,'_mat']);
if ~exist(img_save_folder,'dir')
   mkdir(img_save_folder);
end
if ~exist(mat_save_folder,'dir')
   mkdir(mat_save_folder); 
end

continueID_rectinfo=getContinueID(fullfile(mat_save_folder,'*_rect_info.mat'));
continueID_lminfo=getcontinueID(fullfile(mat_save_folder,'*_lm_info.mat'));
if continueID_lminfo~=0 && continueID_rectinfo~=0
continue_imgID=getFrameIDFromMat(mat_save_folder,continueID_rectinfo,continueID_lminfo);
else
    continueID_lminfo=0;
    continueID_rectinfo=0;
    continue_imgID=0;
end


mean_height_pittpatt=176.3637;
mean_width_pittpatt=141.0943;
img_suffix='.png';
[DM,TM,option] = xx_initialize;

videoObj=VideoReader(video_file);
nFrames=videoObj.NumberOfFrames;
vidHeight=videoObj.Height;
vidWidth=videoObj.Width;



idx_bb=continueID_rectinfo+1;
idx_lm=continueID_lminfo;
rects_info=[];
landmarks_info=[];

figure;
set(gcf,'visible','off');
%%
% if offset >0, it means that video 
loop_length=min(nFrames-startid+1,clip_length);
    
 for i=continue_imgID+1:1:loop_length;
     fprintf('Computing %d th img of %d...\n',i,loop_length);
     tmp_img_name='temp.png';
     temp_img=read(videoObj,i);


if isempty(temp_img)
  temp_img=zeros(vidHeight,vidWidth,3);
end

imwrite(temp_img,fullfile(pwd,tmp_img_name));
result_pitt=[];

result_pitt=FaceDetectPittPattWindows(fullfile(pwd,tmp_img_name),pwd);
if save_flag==1
imshow(temp_img);
end
if ~isempty(result_pitt)
     
    for numl=1:1: length(result_pitt)
        rects_info(idx_bb).frameid=i;
        rects_info(idx_bb).rectinfo=result_pitt(numl);
        
        pittpatt_rect= round([result_pitt(numl).x1 result_pitt(numl).y1 result_pitt(numl).w result_pitt(numl).h]);
        pittpatt_ang=[result_pitt(numl).yaw result_pitt(numl).pitch result_pitt(numl).rot];
        pittpatt_rect= pittpatt_rect- ceil([-(1.0668*pittpatt_ang(1)+10.3149)*  pittpatt_rect(3)/mean_width_pittpatt,...
            -35.1369 *pittpatt_rect(4)/mean_height_pittpatt, ...
            ((1.0668*pittpatt_ang(1)+10.3149+ (-1.2393)*pittpatt_ang(1) +9.5758)*pittpatt_rect(3)/mean_width_pittpatt),...
            ((19.2323+35.1369)*pittpatt_rect(4)/mean_height_pittpatt)]);
        
        
        
        if sum(pittpatt_rect>0)==4
            [pred,pose] = xx_track_detect2(DM,TM,temp_img,pittpatt_rect,option);
            rects_info(idx_bb).correctified_rect=pittpatt_rect;
            temp_mat=rects_info(idx_bb);
            save(fullfile( mat_save_folder,sprintf('%.05d_rect_info.mat',idx_bb)),'temp_mat');
            idx_bb=idx_bb+1;
            % draw rectangle on image to show results of pittpatt
            if(save_flag==1)
               hold on;
               rectangle('position',int32(pittpatt_rect),'edgecolor','w');
               rectangle('position',int32(pittpatt_rect+[1,1,0,0]),'edgecolor','k');
            end
            if ~isempty(pred)
                
                landmarks_info(idx_lm).frameid=i;
                landmarks_info(idx_lm).pred=pred;
                landmarks_info(idx_lm).pose=pose;
                temp_lm=landmarks_info(idx_lm);
                 save(fullfile( mat_save_folder,sprintf('%.05d_lm_info.mat',idx_lm)),'temp_lm');
                idx_lm=idx_lm+1;
                % draw landmarks on iamge to show results of pittpatt
                if(save_flag==1)
                 hold on;
                 Pts = int32(pred);
                 plot(Pts(:,1),Pts(:,2),'b.');
                end
            end
        end
        
    end
end
if(save_flag==1)
% imwrite(temp_img,fullfile(img_save_folder,sprintf('%.05d.png',i)), 'png');
 im=export_fig();
 imwrite(im,fullfile(img_save_folder,sprintf('%.05d.png',i)), 'png');
hold off;
end

  end


 save([video_name,'.mat'],'rects_info','landmarks_info');

end
%------------- BEGIN CODE --------------