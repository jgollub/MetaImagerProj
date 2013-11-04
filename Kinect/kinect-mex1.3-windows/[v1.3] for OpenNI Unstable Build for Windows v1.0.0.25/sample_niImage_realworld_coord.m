% sample_niImage
% Get RGB and DEPTH image via Kinect

close all; clear all;
addpath('C:\Users\Lab\Documents\MATLAB\kinect-mex1.3-windows\[v1.3] for OpenNI Unstable Build for Windows v1.0.0.25\Mex');

%% Create context with xml file
context = mxNiCreateContext('C:\Users\Lab\Documents\MATLAB\kinect-mex1.3-windows\[v1.3] for OpenNI Unstable Build for Windows v1.0.0.25\Config\SamplesConfig.xml');

%% Initialise FIGURE
width = 640; height = 480;
% depth image
h1 = figure; %h1 = imagesc(zeros(height,width,'uint16'));


%% LOOP
for k=1:50
    tic
    %align Depth onto RGB
    option.adjust_view_point = true;
    % Acquire RGB and Depth image
    mxNiUpdateContext(context);
    [rgb, depth] = mxNiImage(context);
    real_XYZ = double(mxNiConvertProjectiveToRealWorld(context, depth));
    % Update figure 
    %scatter3(real_XYZ(:,1),real_XYZ(:,2),real_XYZ(:,3),'.');
    a = 2;
    surface(real_XYZ(1:a:height,1:a:width,1),real_XYZ(1:a:height,1:a:width,2),real_XYZ(1:a:height,1:a:width,3),'edgecolor','none');
    %set(h1,'CData',depth); 
    drawnow;
    disp(['itr=' sprintf('%d',k) , ' : FPS=' sprintf('%f',1/toc)]);
    toc
end

%% Delete the context object
mxNiDeleteContext(context);