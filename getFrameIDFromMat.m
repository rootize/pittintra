function frameid= getFrameIDFromMat( mat_save_folder,continueID_rectinfo,continueID_lminfo )
%GETFRAMEIDFROMMAT get latest frameid from mat file

if exist(fullfile(mat_save_folder,sprintf('%.05d_rect_info.mat',continueID_rectinfo)))
   load_data1=load(fullfile(mat_save_folder,sprintf('%.05d_rect_info.mat',continueID_rectinfo)));
   frameid_rect=load_data1.temp_mat.frameid;

else
     frameid_rect=0;
end

if exist(fullfile(mat_save_folder,sprintf('%.05d_lm_info.mat',continueID_lminfo)))
    load_data2=load(fullfile(mat_save_folder,sprintf('%.05d_lm_info.mat',continueID_lminfo)));
    frameid_lm=load_data2.temp_lm.frameid;
else
    frameid_lm=0;
end

frameid=max(frameid_lm,frameid_rect);


end

