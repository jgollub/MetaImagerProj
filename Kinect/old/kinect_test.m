home
close all


% if istruct(context)
% mxNiDeleteContext(context);
% end

%clear
%context = mxNiCreateContext('C:\Users\Lab\Dropbox\MetaImager Project\Programming Scripts\Kinect\kinect-mex1.3-windows\[v1.3] for OpenNI Unstable Build for Windows v1.0.0.25\Config\SamplesConfig.xml');

frames = 20;
%pause(5)

Azex = zeros(frames,2);
Elex = zeros(frames,2);
Zex = zeros(frames,2);
xyz = zeros(480,640,3,frames);
walls = false(480,640,frames);
rgb = zeros(480,640,3,frames);

fprintf('%s','collecting data...')
for n=1:frames
    [Aze, Ele, Ze, xy, wall, rg] = niImage_RangeConstraints_fun(context);
    Azex(n,:) = -Aze;
    Elex(n,:) = Ele;
    Zex(n,:) = Ze;
    xyz(:,:,:,n) = xy; 
    walls(:,:,n) = wall;
    rgb(:,:,:,n) = double(flipdim(rg,2))./255;
end
fprintf('%s\n','done.')

fprintf('%s','rendering data...')
clear F
for n=1:frames
    
    h = figure('Color',[1 1 1]);
  
    wall = repmat(walls(:,:,n),[1 1 3]);
    xyz_scene = xyz(:,:,:,n);
    xyz_scene(wall) = NaN;
    rgb_scene = rgb(:,:,:,n);
    rgb_scene(wall) = NaN;
    xyz_walls = xyz(:,:,:,n);
    xyz_walls(~wall) = NaN;
    rgb_walls = rgb(:,:,:,n);
    rgb_walls(~wall) = NaN;
    
    rscene = sqrt(xyz_scene(:,:,1).^2+xyz_scene(:,:,2).^2+xyz_scene(:,:,3).^2);
    rwalls = sqrt(xyz_walls(:,:,1).^2+xyz_walls(:,:,2).^2+xyz_walls(:,:,3).^2);
    surface(-xyz_scene(:,:,1),xyz_scene(:,:,3),xyz_scene(:,:,2),rgb_scene,'edgecolor','none');
	surface(-xyz_walls(:,:,1),xyz_walls(:,:,3),xyz_walls(:,:,2),rgb_walls,'edgecolor','none');
%     surface(-xyz_scene(:,:,1),xyz_scene(:,:,3),xyz_scene(:,:,2),rscene,'edgecolor','none');
% 	surface(-xyz_walls(:,:,1),xyz_walls(:,:,3),xyz_walls(:,:,2),rwalls,'edgecolor','none');

    axis equal;
    axis([-2.5 2.5, 0 5, -1.5 2, 0 5])
   % view(90*n/frames-45,-30*n/frames+40)
       
    xlabel('X')
    ylabel('Y')
    zlabel('Z')

    x1 = tan(Azex(n,1))*Zex(n,1);
    x2 = x1;
    x3 = tan(Azex(n,2))*Zex(n,1);
    x4 = x3;
    x5 = tan(Azex(n,1))*Zex(n,2);
    x6 = x5;
    x7 = tan(Azex(n,2))*Zex(n,2);
    x8 = x7;

    y1 = tan(Elex(n,1))*Zex(n,1)*cos(Azex(n,1));
    y2 = tan(Elex(n,2))*Zex(n,1)*cos(Azex(n,1));
    y3 = y2;
    y4 = y1;
    y5 = tan(Elex(n,1))*Zex(n,2)*cos(Azex(n,1));
    y6 = tan(Elex(n,2))*Zex(n,2)*cos(Azex(n,1));
    y7 = y6;
    y8 = y5;

    z1 = Zex(n,1);
    z2 = Zex(n,1);
    z3 = Zex(n,1);
    z4 = Zex(n,1);
    z5 = Zex(n,2);
    z6 = Zex(n,2);
    z7 = Zex(n,2);
    z8 = Zex(n,2);

    a = 0.2;
    c = [0, 0.5, 1];
    patch([x1 x2 x3 x4], [z1 z2 z3 z4], [y1 y2 y3 y4],c,'FaceAlpha',a)
    patch([x5 x6 x7 x8], [z5 z6 z7 z8], [y5 y6 y7 y8],c,'FaceAlpha',a)
    patch([x1 x5 x8 x4], [z1 z5 z8 z4], [y1 y5 y8 y4],c,'FaceAlpha',a)
    patch([x2 x6 x7 x3], [z2 z6 z7 z3], [y2 y6 y7 y3],c,'FaceAlpha',a)
    patch([x2 x6 x5 x1], [z2 z6 z5 z1], [y2 y6 y5 y1],c,'FaceAlpha',a)
    patch([x2 x6 x5 x1], [z2 z6 z5 z1], [y2 y6 y5 y1],c,'FaceAlpha',a)
    patch([x3 x7 x8 x4], [z3 z7 z8 z4], [y3 y7 y8 y4],c,'FaceAlpha',a)
    
    cxt = mean([x1 x2 x3 x4 x5 x6 x7 x8]);
    czt = mean([y1 y2 y3 y4 y5 y6 y7 y8]);
    cyt = mean([z1 z2 z3 z4 z5 z6 z7 z8])+0.1;
%     ctx = 0;
%     cty = 2.5;
%     ctz = 0.4;
    
    Az_start = 45;
    Az_end = -70;
    El_start = 45;
    El_end = 15;
    R_start = 3.5;
    R_end = 1.75;
    cAz = ((Az_end-Az_start)*n/frames+Az_start)*pi/180;
    cEl = ((El_end-El_start)*n/frames+El_start)*pi/180;
    cR = R_start+(R_end-R_start)*n/frames; %2.5*((cAz-pi/2)/(2*pi))^2+0.5;
    cx = cR*cos(cEl)*sin(cAz)+ctx;
    cy = -cR*cos(cEl)*cos(cAz)+cty;
    cz = cR*sin(cEl)+ctz;
    set(gca,'CameraPosition', [cx cy cz])
    set(gca,'CameraViewAngleMode','manual','CameraViewAngle', 60)
    set(gca,'CameraTarget', [ctx cty ctz])
    
    drawnow
    F(n) = getframe(h);
    close(h)
end
fprintf('%s\n','done.')
write_avi(F,'C:\Users\Lab\Dropbox\MetaImager Project\MetaImager\Subgroup #1 - Metamaterial Aperture\kinect_test2',18,80,'MPEG-4')