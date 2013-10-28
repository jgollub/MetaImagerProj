home 
clear
close all

matlabpool open
%from "An Overview of Near-Field Antenna Measurements", Arthur D. Yaghjian,
%IEEE Trans. on Antennas and Propagation. Vol. 34, 1986

%load measured E = Ev(x,y,f)+Eh(x,y,f)
%load 'C:\Users\John\Documents\MetaImaging\MetaAntenna\A3_2D\Measurements\NFS_verticalpol_with_amp';


%polarization in X direction
%load('D:\Users\jng6\Documents\MATLAB\Measurement Data\A3_12Panel\B2_Pol_X_NFS-10-Oct-2013.mat');
%dataPolX=data;



%Which panel to calculated
ActivePanels=[ 0 0 0; 0 0 1; 0 0 0; 0 0 0];

PanelPositions=zeros(4,3,3);
%physical positions of panels  
%%
%A2
PanelPositions(2,1,1)= -.3; %x
PanelPositions(2,1,2)= 0;  %y

%B2
PanelPositions(2,2,1)= .3; %x
PanelPositions(2,2,2)= 0;  %y

%C2
PanelPositions(2,3,1)= .9; %x
PanelPositions(2,3,2)= 0;  %y

%%
%A3
PanelPositions(3,1,1)= -.3; %x
PanelPositions(3,1,2)= .445;  %y

%B3
PanelPositions(3,2,1)= .3; %x
PanelPositions(3,2,2)= .445;  %y

%C3
PanelPositions(3,3,1)= .9; %x
PanelPositions(3,3,2)= .445;  %y

%% Load appropriate near field scan data

PositionActivePanels=find(ActivePanels(:));    
folderName='D:\Users\jng6\Documents\MATLAB\Measurement Data\A3_12Panel\';
filenameFragment=[char(65+floor(PositionActivePanels/size(ActivePanels,1))), num2str(mod(PositionActivePanels,size(ActivePanels,1))),'_Pol_M'];
filenameFragmentSave=[char(65+floor(PositionActivePanels/size(ActivePanels,1))), num2str(mod(PositionActivePanels,size(ActivePanels,1))),'_Pol_Y'];

for iPanel=1:sum(ActivePanels(:))
fileName=dir(['D:\Users\jng6\Documents\MATLAB\Measurement Data\A3_12Panel\',filenameFragment(iPanel,:),'*.mat']);
fprintf(['Loading file: ',fileName.name,'\n'])

load([folderName,fileName.name]);

%only loading Y Pol
dataPolY=data;
clear data;

%polarization in Y direction
% load('D:\Users\jng6\Documents\MATLAB\Measurement Data\A3_12Panel\C3_Pol_M_NFS-09-Oct-2013.mat');
% dataPolY=data;
% clear data;
% %Offset

%Panel A-> filen=1,  Panel B-> filen=2
%filen=1

%x0 = -(2*filen-3)*9.5*0.0254;
PanelPositionsX=PanelPositions(:,:,1);
PanelPositionsY=PanelPositions(:,:,2);

x0 = PanelPositionsX(PositionActivePanels(iPanel))
y0 = PanelPositionsY(PositionActivePanels(iPanel))

%%
saveFileAs=['D:\Users\jng6\Documents\MATLAB\Measurement Matrix Build\', filenameFragmentSave,'_X_',num2str(1000*x0),'_Y_',num2str(1000*y0),'_101pts'];
fprintf('File will be saved as: %s.mat \n', saveFileAs)



X = dataPolY.X.*1E-3;
Y = dataPolY.Y.*1E-3;

fsampleindex = 1:1:101; %take only 4th point
F = dataPolY.f(fsampleindex);

% Ey = single(flipdim(data.measurements,1));
%Ex = single(dataPolX.measurements);
Ey = single(dataPolY.measurements);

%load 'C:\Users\John\Documents\MetaImaging\MetaAntenna\A3_2D\Measurements\NFSh';
%Ex = single(data.measurements);
clear data

%pad data 5x
p = 5;
[ny nx] = size(padpow2(Ey(:,:,1,1),[p p]));

dx = abs(X(1,2)-X(1,1));
dy = abs(Y(2,1)-Y(1,1));

kxmax = 2*pi/(2*dx);
kymax = 2*pi/(2*dy);
[kx ky] = meshgrid(linspace(-kxmax,kxmax,nx),linspace(-kymax,kymax,ny));
dkx = kx(1,2)-kx(1,1);
dky = ky(2,1)-ky(1,1);
xpadmax = 2*pi/(2*dkx);
ypadmax = 2*pi/(2*dky);
%new cartesian coordinates with finer sampling due to zero-padding
[Xpad Ypad] = meshgrid(linspace(-xpadmax,xpadmax,nx),linspace(-ypadmax,ypadmax,ny));
fov = 45*pi/180;%+-
[Az El] = meshgrid((-fov:(3E8/22.25E9)/((2*16+3)*0.0254):fov),(-fov:(3E8/22.25E9)/(22*0.0254):fov));

dz = 1*3E8/(2*(max(F)-min(F)));
zmin = 0;
zmax = 1.666; %
Z = zmin:dz:zmax;
nz = length(Z);

% [kx ky] = meshgrid(linspace(-kxmax,kxmax,nx),linspace(-kymax,kymax,ny));
% kx = repmat(kx,[1,1,length(F)]);
% ky = repmat(ky,[1,1,length(F)]);
% k0 = (2*pi.*repmat(Fn,ny,nx)./3E8);
% kz = sqrt(k0.^2-kx.^2-ky.^2);
% alpha = kx./k0;
% beta = ky./k0;
% gamma = kz./k0;

%% load probe recieve coefficients
% load 'C:\Users\John\Documents\MetaImaging\MetaAntenna\NearFieldCharacterization\NearFieldTransformation\ProbeCoeff.mat';
% fp(1,1,:) = freqs;
% fp = repmat(fp,size(kxp,1),size(kxp,2));
% kxp = repmat(kxp,[1,1,length(freqs)]);
% kyp = repmat(kyp,[1,1,length(freqs)]);
% alphap = kxp./(2*pi.*fp./3E8);
% betap = kyp./(2*pi.*fp./3E8);

%% probe compensation
% for sn=1%1:6
%     for fn=100%1:length(f);
%         tic
%         f = F(fn);
%         lambda = 3E8/f;
%         
%         Sx = fftshift(fft2(ifftshift(padpow2(Ex(:,:,fn,1),[p p]))));
%         Sy = fftshift(fft2(ifftshift(padpow2(Ey(:,:,fn,1),[p p]))));
%         
%         % probe compensation
% %         PxB = PxInterp(-alpha,beta,f.*ones(size(alpha)));
% %         PyB = PyInterp(-alpha,beta,f.*ones(size(alpha)));
% %         PyC = PyInterp(-beta,-alpha,f.*ones(size(alpha)));
% %         PxC = PxInterp(-beta,-alpha,f.*ones(size(alpha)));
%         PxB = (Py(:,:,7));
%         PyB = (Px(:,:,7));
%         PyC = (Py(:,:,7));
%         PxC = (Px(:,:,7));
%         
% %         PxB = ones(size(PxB));
% %         PyC = ones(size(PxB));
%         
%         for r=1:ny
%             for c=1:nx
%                 a = alpha(r,c);
%                 b = beta(r,c);
%                 g = gamma(r,c);
% %                 Minv = 1/g.*[(1-a^2) a*b;-a*b -(1-b^2)];
% %                 Pinv = 1/(PxB(r,c)*PxC(r,c)+PyB(r,c)*PyC(r,c)).*[PxC(r,c) PyB(r,c);PyC(r,c) -PxB(r,c)];
% %                 Ft = lambda/1j.*Minv*Pinv*[Sx(r,c);Sy(r,c)].*exp(1j*kz(r,c)*z0);
%                 const = 1j/lambda*(1/g)*exp(-1j*kz(r,c)*z0)/g;
%                 M = [(1-b^2) a*b; -a*b -(1-a^2)];
%                 P = [PxB(r,c) PyB(r,c); PyC(r,c) -PxC(r,c)];
%                 pc = inv(const*P*M);
%                 PC11(r,c) = pc(1,1);
%                 PC12(r,c) = pc(1,2);
%                 PC21(r,c) = pc(2,1);
%                 PC22(r,c) = pc(2,2);
%                 Ft = pc*[Sx(r,c);Sy(r,c)];
%                 Fx(r,c,fn,sn) = Ft(1);
%                 Fy(r,c,fn,sn) = Ft(2);
%             end
%         end
%         %Fz(:,:,fn,sn) = -(kx.*Fx+ky.*Fy)./sqrt(k^2-kx.^2-ky.^2);
%         toc*401*6/3600
%     end
% end

%Ex_PanA = single(zeros(size(Az,1),size(Az,2),nz,length(fsampleindex),6));
Ey_Pan = single(zeros(size(Az,1),size(Az,2),nz,length(fsampleindex),6));
%Ez_PanA = single(zeros(size(Az,1),size(Az,2),nz,length(fsampleindex),6));
% Ey_PanB = single(zeros(size(Az,1),size(Az,2),nz,length(fsampleindex),6));
% Ey_PanB = single(zeros(size(Az,1),size(Az,2),nz,length(fsampleindex),12));
%Ex_intp = single(zeros(size(Azintp,1),size(Azintp,2),nz,length(fsampleindex),6));
%Ez_intp = single(zeros(size(Azintp,1),size(Azintp,2),nz,length(fsampleindex),6));
%Ey_pws = single(zeros(size(Xpad,1),size(Xpad,2),nz,1,1));
% Ex_pws = single(zeros(size(Xpad,1),size(Xpad,2),nz,length(fsampleindex),6));
% Ez_pws = single(zeros(size(Xpad,1),size(Xpad,2),nz,length(fsampleindex),6));
at = 0;
count = 1;
fprintf('%s\n','Starting diffraction calculation.')
tic
for sn=1:6
    for fn=1:length(fsampleindex);
        %% uncorrected planewave spectrum components
        f = F(fsampleindex(fn));
        lambda = 3E8/f;
        k0 = 2*pi/lambda;
        kz = sqrt(k0.^2-kx.^2-ky.^2);
        kz = real(kz)-1i.*imag(kz);
        %Expad = padpow2(Ex(:,:,fsampleindex(fn),sn),[p p]);
       % Expad = padpow2(Ex(:,:,fsampleindex(fn),sn),[p p]);
        Eypad = padpow2(Ey(:,:,fsampleindex(fn),sn),[p p]);

        %Fx = fftshift(fft2(ifftshift(Expad)));
      %  Fx = fftshift(fft2(ifftshift(Expad)));
        Fy = fftshift(fft2(ifftshift(Eypad)));

      %  Fz = -(kx.*Fx+ky.*Fy)./sqrt(k0^2-kx.^2-ky.^2);

        
        %% Field diffraction calculation - Fresnel resampling
       parfor zn=1:nz
            fprintf('%i%s%i%s%i\n',sn,' ',fn,' ',zn)
            z = Z(zn);
        %    Ex_pws = 1/(4*pi^2).*fftshift(ifft2(ifftshift(Fx.*exp(-1j.*kz.*z))));
            Ey_pws = 1/(4*pi^2).*fftshift(ifft2(ifftshift(Fy.*exp(-1j.*kz.*z))));            
        %    Ez_pws = 1/(4*pi^2).*fftshift(ifft2(ifftshift(Fz.*exp(-1j.*kz.*z))));
            
            %interpolate fresnel resampled fields onto the desired coords
            Xintp = z.*tan(Az);
            Yintp = z.*tan(El)./cos(Az); 
      
            
         %   Ex_PanA(:,:,zn,fn,sn) = interp2(Xpad-x0,Ypad-y0,Ex_pws,Xintp,Yintp,'*linear'); 
            Ey_Pan(:,:,zn,fn,sn) = interp2(Xpad-x0,Ypad-y0,Ey_pws,Xintp,Yintp,'*linear'); 
         %   Ez_PanA(:,:,zn,fn,sn) = interp2(Xpad-x0,Ypad-y0,Ez_pws,Xintp,Yintp,'*linear');
            
            %Ey_intp(:,:,zn,fn,sn) = interp2(Xpad,Ypad,Ey_pws,Xintp,Yintp,'*linear');
            
            %Ex_intp(:,:,zn,fn,sn) = interp2(Xpad,Ypad,Ex_pws,Xintp,Yintp,'*linear');
            %Ez_intp(:,:,zn,fn,sn) = interp2(Xpad,Ypad,Ez_pws,Xintp,Yintp,'*linear');
        end
        at = toc/count+at*(count-1)/count; tic
        disp(at*(length(fsampleindex)*6-count)/3600)
        count = count+1;
    end
end

%save(['D:\Users\jng6\Documents\MATLAB\Measurement Matrix Build\PanelA_Pol_XYZ_101pts_13dBm_Jumper-' date],'Ex_PanA','Ey_Pan','Ez_PanA','Az','El','F','Z','-v7.3') %%%%%
save(saveFileAs,'Ey_Pan','Az','El','F','Z','-v7.3') %%%%%
 
end

%% svd
% H = zeros(201*6,1 11*36*44);
% n = 1;
% for fn=1:201
% for sn=1:6
% h = squeeze(Ey(:,:,:,fn,sn));
% h = transpose(h(:));
% H(n,:) = h(:);
% n=n+1;
% end
% end

matlabpool close