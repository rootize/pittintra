% FaceDetectPittPatt.m

function pos = FaceDetectPittPattWindows(src, directory, display_flag)

if nargin == 2
    display_flag = 0;
end

pos = [];

 display('before commandline')
% cd('C:\SSIM\SDKs\pittpatt_sdk-5.2.2-windows-x86_64\applications\visual_studio\2010\examples\x64\Release');
executable = 'detection.exe -binary_output off -models C:\SSIM\SDKs\pittpatt_sdk-5.2.2-windows-x86_64\models\';
dest = 'result.out';
disp('after commandline');
if exist(dest,'file')
    delete(dest);
end
command = [executable ' ' src ' >> ' dest];
system(command);

% display('after commandline');
fid = fopen('result.out','r');
A = textscan(fid,'%s','delimiter','\n','whitespace','');
A = A{1};

fclose(fid);
count = 1;
for i = 1:(length(A)-1)
    k1 = strfind(A{i},'- position');
    k2 = strfind(A{i+1},'- dimension');
    if ~isempty(k1) && ~isempty(k2)
        k1 = strfind(A{i},'(');
        k2 = strfind(A{i},',');
        k3 = strfind(A{i},')');
        str1 = A{i}(k1+1:k2-1);
        str2 = A{i}(k2+1:k3-1);
        pos(count).x = str2double(str1);
        pos(count).y = str2double(str2);
        
        k1 = strfind(A{i+1},': ');
        k2 = strfind(A{i+1},'x');
        k3 = strfind(A{i+1},' (');
        str1 = A{i+1}(k1+1:k2-1);
        str2 = A{i+1}(k2+1:k3-1);
        pos(count).w = str2double(str1);
        pos(count).h = str2double(str2);
        
        k1 = strfind(A{i+2},'y=');
        k2 = strfind(A{i+2},'p=');
        k3 = strfind(A{i+2},'r=');
        str1 = A{i+2}(k1+2:k2-2);
        str2 = A{i+2}(k2+2:k3-2);
        str3 = A{i+2}(k3+2:end);
        pos(count).yaw = str2double(str1);
        pos(count).pitch = str2double(str2);
        pos(count).rot = str2double(str3);
        
        k1 = strfind(A{i+4},':');
        str = A{i+4}(k1+1:end);
        pos(count).confidence = str2double(str);
        pos(count).time_used=0;
        count = count + 1;
        
    end
    
    
    
    
end
% fid = fopen('result.out','r');
% A = textscan(fid,'%s','delimiter','\n','whitespace','');
% A = A{1};
% fclose(fid);
% count=count-1;
% for j=1:1:(length(A)-1)
%     %added @ 20131022
%     k10=strfind(A{j},'|  2 |                     read image |');
%     k11=strfind(A{j+1},'|  3 |                      detection |');
%     if ~isempty(k10)&&~isempty(k11)
%         str=A{j+1}
%         strs=strsplit(str,'|');
%         time_used=str2double(strs{6});
%         for p=1:1:count
%             pos(count).time_used=time_used;
%         end
%     end
% end
if display_flag
    im = imread(src);
    imshow(im);
    hold on;
end

for i = 1:length(pos)
    pos(i).x1 = pos(i).x-pos(i).w/2;
    pos(i).y1 = pos(i).y-pos(i).h/2;
    pos(i).x2 = pos(i).x+pos(i).w/2;
    pos(i).y2 = pos(i).y+pos(i).h/2;
    
    if display_flag
        rectangle('Position',[pos(i).x1,pos(i).y1,pos(i).w,pos(i).h],'LineWidth',2,'edgecolor','r');
    end
end

if display_flag
    hold off;
end

delete(dest);
% cd(directory);