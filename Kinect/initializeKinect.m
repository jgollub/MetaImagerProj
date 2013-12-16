%% initialize kinect
% create Kinect color and depth video objects, set to get one frame per trigger
% 

%hwInfo = imaqhwinfo('kinect')
%hwInfo.DeviceInfo(1)
%hwInfo.DeviceInfo(2)

function [colorVid depthVid] = initializeKinect

colorVid = videoinput('kinect',1,'RGB_1280x960');
depthVid = videoinput('kinect',2);
%irVid = videoinput('kinect',1,'Infrared_640x480');

% Set the triggering mode to 'manual'
triggerconfig([colorVid depthVid],'manual');
set([colorVid depthVid], 'FramesPerTrigger', 1);

