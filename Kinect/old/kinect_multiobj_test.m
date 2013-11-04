home
close all


% % if istruct(context)
% % mxNiDeleteContext(context);
% % end

% clear
%context = mxNiCreateContext('C:\Users\Lab\Dropbox\MetaImager Project\Programming Scripts\Kinect\kinect-mex1.3-windows\[v1.3] for OpenNI Unstable Build for Windows v1.0.0.25\Config\SamplesConfig.xml');

frames = 20;
%pause(5)

clear Azex Elex Zex RGB XYZ
C = [0, 1, 0;1, 0 ,1; 0,0,1];

XYZ = zeros(480,640,3,frames);
RGB = uint8(zeros(480,640,3,frames));

fprintf('%s','collecting data...')
fpsavg = 0;
tic
%align Depth onto RGB
option.adjust_view_point = true;

for n=1:frames
    %% Acquire RGB and Depth image
    cla
    mxNiUpdateContext(context,option);
    [rgb, depth] = mxNiImage(context,option);
    xyzn = double(mxNiConvertProjectiveToRealWorld(context, depth));
    xyzn = xyzn./1E3;
    xyzn = flipdim(xyzn,2);

    %Convert missing data to NaN
    xyzn(xyzn == 0) = NaN;
    XYZ(:,:,:,n) = xyzn;
    RGB(:,:,:,n) = flipdim(rgb,2);
       
    fpsavg = (fpsavg*(n-1)+1/toc)/n;
    tic
end
fprintf('%s%2.1f%s\n','Avg. fps: ',fpsavg,'. done.')
fprintf('%s\n','done.')


fprintf('%s','Rendering data...')
clear F
for n=1:frames
    
    %% get object constraints
    xyz = XYZ(:,:,:,n);
    rgb = double(RGB(:,:,:,n))./255;
    [Azex, Elex, Zex, objs] = niImage_multiobjects_RangeConstraints_fun(xyz);
    Azex = -Azex;
    
    %draw scene
    h = figure('Color',[1 1 1]);
    
    for on=1:size(objs,3)
        notobj = repmat(~objs(:,:,on),[1,1,3]);
        xyz_obj = xyz;
        rgb_obj = rgb;
        xyz_obj(notobj) = NaN;
        rgb_obj(notobj) = NaN;
        surface(-xyz_obj(:,:,1),xyz_obj(:,:,3),xyz_obj(:,:,2),rgb_obj,'edgecolor','none');
        
        if on~=1
            %%draw bounding boxes
            draw_extent_box(Azex(on,:),Elex(on,:),Zex(on,:))
        end
    end
    axis equal;
    axis([-2.5 2.5, 0 5, -1.5 2, 0 5])
   % view(90*n/frames-45,-30*n/frames+40)
       
    xlabel('X')
    ylabel('Y')
    zlabel('Z')

    ctx = 0;
    cty = 2.0;
    ctz = 0;
    
    Az_start = 45;
    Az_end = 45-360-60;
    El_start = 45;
    El_end = 15;
    R_start = 3.5;
    R_end = 1;
    cAz = ((Az_end-Az_start)*n/frames+Az_start);
    cEl = ((El_end-El_start)*n/frames+El_start);
    %cR = R_start+(R_end-R_start)*n/frames; %2.5*((cAz-pi/2)/(2*pi))^2+0.5;
    Az_close = -180;
    Azn = (cAz-Az_close)./(Az_start-Az_close);
    cR = R_start*Azn^2+R_end;
    cx = cR*cos(cEl*pi/180)*sin(cAz*pi/180)+ctx;
    cy = -cR*cos(cEl*pi/180)*cos(cAz*pi/180)+cty;
    cz = cR*sin(cEl*pi/180)+ctz;
    set(gca,'CameraPosition', [cx cy cz])
    set(gca,'CameraViewAngleMode','manual','CameraViewAngle', 60)
    set(gca,'CameraTarget', [ctx cty ctz])
    
    drawnow

    F(n) = getframe(h);
    delete(h)
end
fprintf('%s\n','done.')
write_avi(F,'C:\Users\Lab\Dropbox\MetaImager Project\MetaImager\Subgroup #1 - Metamaterial Aperture\kinect_test3',fpsavg-1,80,'Motion JPEG AVI')