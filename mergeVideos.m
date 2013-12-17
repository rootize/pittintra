function mergeVideos(input1,input2)
[video_folder1, video_name1, ~]=fileparts(input1);
img_save_folder1=fullfile(video_folder1,video_name1);
[video_folder2,video_name2,~]=fileparts(input2);
img_save_folder2=fullfile(video_folder2,video_name2);
list_imgs_files1=dir(fullfile(img_save_folder1,'*.png'));
list_imgs_files2=dir(fullfile(img_save_folder2,'*.png'));
num_files=min(length(list_imgs_files1),length(list_imgs_files2));
videowriter=VideoWriter(strcat(video_name1,video_name2,'.avi'));
videowriter.FrameRate=30;
videowriter.open;

%% test
num_files=150;
for i=1:1:num_files
   fprintf('writting %d th frame\n',i);
    im1=imread(fullfile(img_save_folder1,sprintf('%.05d.png',i)));
    im2=imread(fullfile(img_save_folder2,sprintf('%.05d.png',i)));
    
    if (isempty(im1) || isempty(im2))
        continue;
    else
    im=ImgSyn(im1,im2,'h');
    if i==1
    im_size=size(im);
    end
    videowriter.writeVideo(imresize(im,im_size(1:2)));
    end
end
videowriter.close;

end