function savePercepts(percepts,video_path1,video_path2)

[~,v1_name,~]=fileparts(video_path1);
[~,v2_name,~]=fileparts(video_path2);
savefile_name=[v1_name,v2_name,'_percepts'];
save([savefile_name,'.mat'],'percepts');


end