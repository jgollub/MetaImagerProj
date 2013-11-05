%% initialize kinect
% create Kinect color and depth video objects, set to get one frame per trigger
% 

%hwInfo = imaqhwinfo('kinect')
%hwInfo.DeviceInfo(1)
%hwInfo.DeviceInfo(2)

function [colorVid depthVid] = initializeKinect


colorVid = videoinput('kinect',1);
%irVid = videoinput('kinect',1,'Infrared_640x480');
depthVid = videoinput('kinect',2);

% Set the triggering mode to 'manual'
triggerconfig([colorVid depthVid],'manual');
set([colorVid depthVid], 'FramesPerTrigger', 1);

