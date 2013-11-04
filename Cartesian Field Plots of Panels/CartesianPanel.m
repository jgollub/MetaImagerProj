
[az,z] = meshgrid(Az(1,:),Z);
[xi,zi] = meshgrid(linspace(-0.5,0.5,100),linspace(0,1.6,100));
azi = atan2(xi,zi);

Eyint=interp2(az,z,transpose(abs(squeeze(Ey_Pan(33,:,:,50,1)))),azi,zi);

figure
imagesc(xi(1,:),zi(:,1),Eyint)
axis xy

%%
[el,z] = meshgrid(El(:,1),Z);
[yi,zi] = meshgrid(linspace(-0.5,0.5,100),linspace(0,1.6,100));
eli = atan2(yi,zi);

Eyint=interp2(el,z,transpose(abs(squeeze(Ey_Pan(:,52,:,50,1)))),eli,zi);

figure
imagesc(zi(:,1),yi(1,:),transpose(Eyint))
axis xy