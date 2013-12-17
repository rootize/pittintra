function loc_frame =synchronizeAudio(audiostr1,audiostr2,drawing)
%SYNCHRONIZEAUDIO - synchronizing two videos, represent video difference in
%frames
%ATTENTION: videos should have same frame rate. The audio sampling rate
%doesn't matter.
% Syntax:  loc_frame = synchronizeAudio(audiostr1,audiostr2,drawing_flag)
%
% Inputs:
%    audiostr1 - the first input video with audio or pure audio file
%    location
%    audiostr2 - the first input video with audio or pure audio file
%    location
%    drawing_flag - 1: draw correlation results, 0: not drawing
%
% Outputs:
%    loc_frame -  offset with related to the first one, positive number means audio1 is x
%seconds ahead, negative number means audio1 is x seconds after
%
%
% Other m-files required: none
% Subfunctions: 
%          best_corr=loc_calcPairwiseMaxCorrelation(av1_data,av2_data,FR,drawing)
% MAT-files required: none
%          
% See also: testOffset to test the offset

% Author: Zijun Wei (hzwzijun@gmail.com)
% Maurice Lamontagne Institute, Dept. of Fisheries and Oceans Canada
%  
% Website:  http://zijunwei.com/
% December 10 2013

%------------- BEGIN CODE --------------

if nargin<3
    drawing=0;
end

videoObj1=VideoReader(audiostr1);
videoObj2=VideoReader(audiostr2);

if videoObj1.FrameRate~=videoObj2.FrameRate
   error('Please check two videos dont have same frame rate');
   
end
frame_rate=videoObj1.FrameRate;

[Y1,Fs1]=audioread(audiostr1);
[Y2,Fs2]=audioread(audiostr2);
if Fs1~=Fs2
    %error('Currently cannot support two audio signals without same bit-rate');
    %changing sampling rate --- if Fs1!=Fs2, sampling Fs2 or Fs1 to a lower rate
    if Fs1>Fs2
        [P,Q]=rat(Fs2/Fs1);
        Y1=resample(Y1,P,Q);
    else
        [P,Q]=rat(Fs1/Fs2);
        Y2=resample(Y2,P,Q);
    end
    
    
    
end
loc_time=loc_calcPairwiseMaxCorrelation(Y1,Y2,Fs1,drawing);
loc_frame=floor (loc_time*frame_rate);
end
%% Useless: for audios that have 2 channels
function best_corr=loc_calcPairwiseMaxCorrelation(av1_data,av2_data,FR,drawing)

if nargin<4
    drawing=0;
end

if length(av1_data)<length(av2_data)
    pn_sign=-1;
    temp=av1_data;
    av1_data=av2_data;
    av2_data=temp;
else
    pn_sign=1;
end

Padding_av2=zeros(length(av1_data)-length(av2_data),size(av1_data,2));
av2_data=[av2_data;Padding_av2];

idx=1;
for i=1:1:size(av1_data,2)
    for j=1:1:size(av2_data,2)
        
        corr_result{idx}=xcorr(av1_data(:,i),av2_data(:,j),'coeff');
        [corr_socre(idx),corr_loc(idx)]=max(corr_result{idx});
        corr_loc(idx)=corr_loc(idx)-length(av1_data);
        idx=idx+1;
    end
end
[~,best_idx]=max(corr_socre);
best_corr=corr_loc(best_idx)/FR * pn_sign;
if drawing==1
    plot(((1:size(corr_result{best_idx},1))-length(av1_data))/FR,corr_result{best_idx});
end
end
%----------------------------END CODE-------------------------------------