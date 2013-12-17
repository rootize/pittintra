% Signature: 
%   xx_initialize
%
% Dependence:
%   OpenCV2.4 above, mexopencv
%   mexopencv can be downloaded here:
%   http://www.cs.stonybrook.edu/~kyamagu/mexopencv/
%
%   You do not need the above two packages unless you want to build OpenCV
%   on yourself or re-compile mexopencv. All DLLs and mex functions are
%   included in this package.
%
% Usage:
%   This function loads models and set default parameters of the tracker.
%
% Params:
%   None
%
% Return:
%   DM - detection model
%   TM - tracking model
%   option - tracker parameters
%     .face_score - threshold (<=0) determining whether the tracked face is
%     lost. The lower the value the more tolerated it becomes.
%
%     .min_neighbors - OpenCV face detector parameter (>0). The lower the more 
%     likely to find a face as well as false positives.
%
%     .min_face_size - minimum face size for OpenCV face detector.
%
%     .compute_pose - flag indicating whether to compute head pose.
%
% Author: 
%   Xuehan Xiong, xiong828@gmail.com
% 
% Creation date:
%   3/25/2013
%

function [DM, TM, option] = xx_initialize
  option.face_score = -1.5;
  
  option.min_neighbors = 2;
  
  option.min_face_size = [50 50];
  
  option.compute_pose = true;
  
  % OpenCV face detector model file
  xml_file = 'models/haarcascade_frontalface_alt2.xml';
  
  % load tracking model
  load('models/TrackingModel-xxsift-v1.8.mat');
  
  % load detection model
  load('models/DetectionModel-xxsift-v1.4.mat');
  
  % create face detector handle
  fd_h = cv.CascadeClassifier(xml_file);
  
  DM{1}.fd_h = fd_h;
  
end

