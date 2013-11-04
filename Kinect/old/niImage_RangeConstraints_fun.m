%before calling this function, create a Kinect context with:
% context = mxNiCreateContext('C:\Users\Lab\Documents\MATLAB\kinect-mex1.3-windows\[v1.3] for OpenNI Unstable Build for Windows v1.0.0.25\Config\SamplesConfig.xml');
%be sure to delete the context with:
% mxNiDeleteContext(context);
%before creating a new one or you will have to
%restart the computer to reestablish comm with Kinect.

% Get RGB and DEPTH image via Kinect
%% Create context with xml file

function [Az_extent, El_extent, Z_extent, full_XYZ, walls, rgb] = niImage_RangeConstraints_fun(context)


%define room boundaries
room_ymin = -0.90;
room_ymax = 0.900;
room_xmax = 1.40;
room_xmin = -1.40;
room_zmax = 3.5000;
room_zmin = 0;

%align Depth onto RGB
option.adjust_view_point = true;
% Acquire RGB and Depth image
mxNiUpdateContext(context,option);
[rgb, depth] = mxNiImage(context,option);
rgb = flipdim(rgb,2);
XYZ = double(mxNiConvertProjectiveToRealWorld(context, depth))./1E3;
XYZ = flipdim(XYZ,2);
XYZ(XYZ == 0) = NaN; %Convert missing data to NaN
full_XYZ = XYZ;

walls = (XYZ(:,:,2)<room_ymin) | (XYZ(:,:,2)>room_ymax) | (XYZ(:,:,1)<room_xmin) | (XYZ(:,:,1)>room_xmax) | (XYZ(:,:,3)>room_zmax) | (XYZ(:,:,3)<room_zmin);
XYZ(repmat(walls,[1,1,3])) = NaN;


%[Az_extent, El_extent, Z_extent] = getRangeConstraints_fun(real_XYZ);
%% calculate scene extent

X = XYZ(:, :, 1);
Y = XYZ(:, :, 2);
Z = XYZ(:, :, 3);

%  RSqr = X.*X + Y.*Y + Z.*Z;%Compute squared distance to each point
%  R_extent = sqrt([min(min(RSqr)) max(max(RSqr))]);

Z_extent = [min(min(Z)) max(max(Z))];
Az = atan(X./Z);
Az_extent = [min(min(Az)) max(max(Az))];
El = atan(Y./Z);
El_extent = [min(min(El)) max(max(El))];








