function percepts = generatePercepts(percepts,startid,videofile,description )
%GENERATEPERCEPTS Summary of this function goes here
%   Detailed explanation goes here

fps=local_getFPS(videofile); 
[~,file_name,~]=fileparts(videofile);
results=load([file_name,'.mat']);
[pittpattt_confid_normalization_coef,pittpattt_confid_normalization_offset]=getConfidenceNorm(results.rects_info);
l_pittpatt_events=length(results.rects_info);
%% Starts here
% 1. face rectangle detection using pittpatt
event=[];
for i=1:1:l_pittpatt_events

 event{i}.starttime=(results.rects_info(i).frameid-1)/fps;
 event{i}.endtime=(results.rects_info(i).frameid)/fps;
 event{i}.value=results.rects_info(i).correctified_rect;
 event{i}.confidence=(results.rects_info(i).rectinfo.confidence-pittpattt_confid_normalization_offset)/pittpattt_confid_normalization_coef;
end
percept=[];
percept=loc_form_single_percept(event,[description,'_face_location_detection'],['Detect', description,' face location using pittpatt']);
percepts{startid}=percept;
startid=startid+1;
event=[];
% 2 face orientaiton detection using pittpatt
for i=1:1:l_pittpatt_events

 event{i}.starttime=(results.rects_info(i).frameid-1)/fps;
 event{i}.endtime=(results.rects_info(i).frameid)/fps;
 temp_value=results.rects_info(i).rectinfo;
 event{i}.value=[temp_value.yaw,temp_value.rot,temp_value.pitch];
  event{i}.confidence=(results.rects_info(i).rectinfo.confidence-pittpattt_confid_normalization_offset)/pittpattt_confid_normalization_coef;
end
percept=[];
percept=loc_form_single_percept(event,[description,'_face_orientation_detection'],['Detect', description,' face orientaiton using pittpatt']);
percepts{startid}=percept;
startid=startid+1;


event=[];
% 3. Face landmark detection using intraface.
length_lm=length(results.landmarks_info);
for i=1:1:length_lm
    
 event{i}.starttime=(results.landmarks_info(i).frameid-1)/fps;
 event{i}.endtime=(results.landmarks_info(i).frameid)/fps;
 event{i}.value=results.landmarks_info(i).pred;
 event{i}.confidence=1;
end
percept=[];
percept=loc_form_single_percept(event,[description,'_face_landmarks'],['Detect', description,' landmarks using intraface']);
percepts{startid}=percept;


end

function fps=local_getFPS(videoFile)
videoObj=VideoReader(videoFile);

fps=videoObj.FrameRate;
end
function [output_coeff,output_offset]=getConfidenceNorm(rects_info)
rect_num=length(rects_info);
max_conf=0;
min_conf=10000000000000;
for i=1:1:rect_num
    
   if rects_info(i).rectinfo.confidence>max_conf
       max_conf= rects_info(i).rectinfo.confidence;
   end
   
   if rects_info(i).rectinfo.confidence<min_conf
       min_conf= rects_info(i).rectinfo.confidence;
   end
end

output_coeff=max_conf-min_conf;
output_offset=min_conf;



end



function percept=loc_form_single_percept(events,description_name,description_des)

percept=[];
percept.events=events;
percept.name=description_name;
percept.description=description_des;
percept.updatedate=date;
percept.contact='hzwzijun@gmail.com';

end