function plot_saved_reconstruction_rgbRF(scene_data,recon_num,scene_num)

if nargin==3
    sn = scene_num;
else
    sn = 1;
end

%kinect scene data
rgb = scene_data(sn).rgb;
xyz = scene_data(sn).xyz;
azimuth_min = scene_data(sn).Az_extent(1);
azimuth_max = scene_data(sn).Az_extent(2);
elevation_min = scene_data(sn).El_extent(1); %flipped sign
elevation_max = scene_data(sn).El_extent(2); %flipped sign
z_min = scene_data(sn).Z_extent(1);
z_max = scene_data(sn).Z_extent(2);
objs = scene_data(sn).objs;

%RF scene data
Z = scene_data(sn).Z-0.02;%!!!!!!!!!!!!!!
Az = scene_data(sn).Az-0*pi/180;%!!!!!!!!!!!!!!
El = scene_data(sn).El+2*pi/180;%!!!!!!!!!!!!!!
obj3D = abs(scene_data(sn).obj_saved(recon_num).reconstructed);

%% plot 3D-rgb kinect scene and overlay RF reconstruction
axes('pos', [0,0.5,1,0.5]);
view(-27,34)
drawnow
set(gca,'CameraViewAngleMode','manual')

draw_Kinect_object_scene(xyz,rgb,objs(:,:,2),1:size(objs(:,:,2),3))%!!!!!!!!!!!!!!!!!!
draw_extent_box([azimuth_min azimuth_max]*(pi/180),[elevation_min elevation_max]*(pi/180),[z_min z_max],1,[0 0 1],0)
plot_recon_surface(obj3D,Az,-El,Z,0,4); % put in - sign


%% plot RF scene alone
axes('pos', [0,0,1,0.5])
image(zeros(1,1,3));axis off
axes('pos', [0,0.05,1,0.4]);
view(-27,34)
drawnow
set(gca,'CameraViewAngleMode','manual')

plot_recon_surface(obj3D,Az,-El,Z,0,4);view(-27,34); % put in - sign
set(gca,'CameraViewAngleMode','manual');
set(gca,'Color',[0 0 0],'XColor',[1 1 1], 'YColor',[1 1 1], 'ZColor',[1 1 1],'DataAspectRatio',[1 1 1]);
axis equal;axis tight;box on;colormap jet

