%% KinectforWindows World xyz coordiantes

function [rgb, depth, xyz] = aquireKinect(colorVid, depthVid)

%preview(colorVid);

% Start the color and depth device. This begins acquisition, but does not
% start logging of acquired data.
start([colorVid depthVid]);

% Trigger the devices to start logging of data.
trigger([colorVid depthVid]);
pause(1)
% Retrieve the acquired data
[colorFrameData colorTimeData colorMetaData] = getdata(colorVid);
[depthFrameData depthTimeData depthMetaData] = getdata(depthVid);

% Stop the devices
stop([colorVid depthVid]);

rgb = colorFrameData(:,:,1:3,1);
depth = double(depthFrameData(:,:,1,1))/1000;
depth(depth==0) = NaN;

[xyz] = depthToWorldXYZ(depth);

function [xyz] = depthToWorldXYZ(depth)

fx_d = 1/5.9421434211923247E02;
fy_d = 1/5.9104053696870778E02;
cx_d = 3.3930780975300314E02;
cy_d = 2.4273913761751615E02;

[px, py] = meshgrid(1:size(depth,2),size(depth,1):-1:1);

xyz(:,:,1) = (px - cx_d).*depth*fx_d;
xyz(:,:,2) = (py - cy_d).*depth*fy_d;
xyz(:,:,3) = depth;