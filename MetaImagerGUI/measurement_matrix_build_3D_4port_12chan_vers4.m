% clear
% home
% close all

function [H F Az_A El_A Z] = measurement_matrix_build_3D_4port_12chan_vers4(dmin,dmax,nfreqs,Azmin,Azmax,Elmin,Elmax,dataA,dataB,dataALoaded,dataBLoaded)%filename)
%data offset 

%assign variable, matrices, etc.
if dataALoaded
    
    findexes = unique(round(linspace(1,length(dataA.F),nfreqs)));
    %Ey_numswitches = size(dataA.Ey_PanA,5); %if we change this to reassign later it will prevent large data set from being loaded
    Ey_numswitchesA = 6; %hard setting in order to speed up load
    F = dataA.F(1,findexes);
%     El_A = dataA.El; %flipdim due to flipped El in matrix build
    El_A = dataA.El;
    Az_A = dataA.Az; %(*)
    Z = dataA.Z;
    
    [dum, zindmin] = min(abs(Z-dmin));
    [dum, zindmax] = min(abs(Z-dmax));
    [dum, Azminind] = min(abs(Az_A(1,:)-Azmin));
    [dum, Azmaxind] = min(abs(Az_A(1,:)-Azmax));
    [dum, Elminind] = min(abs(El_A(:,1)-Elmin));
    [dum, Elmaxind] = min(abs(El_A(:,1)-Elmax));
    
    Az_A = Az_A(Elminind:Elmaxind,Azminind:Azmaxind); %%%
    El_A = El_A(Elminind:Elmaxind,Azminind:Azmaxind); %%%
    
end

%if matrix B exist setup
if dataBLoaded
    
    findexes = unique(round(linspace(1,length(dataB.F),nfreqs)));
    %Ey_Bd5size = size(dataB.Ey_PanB,5);
    Ey_numswitchesB = 6; %hard setting in order to speed up load
    F = dataB.F(1,findexes); %%%%
    El_B = dataB.El;
    Az_B = dataB.Az;
    Z = dataB.Z;  %sloppy, but in case there isn't dataA, and hence set here
    %F = dataB.F(findexes);  %sloppy, but in case there isn't dataA, and hence set here

    [dum, zindmin] = min(abs(Z-dmin)); %sloppy, but in case there isn't dataA, and hence set there, ditto for below
    [dum, zindmax] = min(abs(Z-dmax));
    [dum, Azminind] = min(abs(Az_B(1,:)-Azmin));
    [dum, Azmaxind] = min(abs(Az_B(1,:)-Azmax));
    [dum, Elminind] = min(abs(El_B(:,1)-Elmin));
    [dum, Elmaxind] = min(abs(El_B(:,1)-Elmax));
    
    Az_B = Az_B(Elminind:Elmaxind,Azminind:Azmaxind);
    El_B = El_B(Elminind:Elmaxind,Azminind:Azmaxind);
    
end

nz = zindmax-zindmin+1;
%Z = Z(indmin:indmax);


% %% horn radiation pattern
% y = El./(2*pi./180.*17.5).*1.8955; %use a sinc... (17.5 deg beamwidth)
% hornradv = sin(y)./y;
% hornradv(y==0) = 1;
% x = Az./(2*pi./180.*17.5).*1.8955; %use a sinc... (17.5 deg beamwidth)
% hornradh = sin(x)./x;
% hornradh(x==0) = 1;
% hornrad = hornradv.*hornradh;
% yoffset = (8+7/8)*0.0254;     %y separation between horn and metaantenna center
% zoffset = -3.5*0.0254;     %z separation between horn and nearfield mesurement plane
% hornrad = ones(size(hornrad)); %actually, let's just ignore the horn gain for now.

% %% horn radiation pattern
%
% y = El_A./(2*pi./180.*17.5).*1.8955; %use a sinc... (17.5 deg beamwidth)
% hornradv = sin(y)./y;
% hornradv(y==0) = 1;
% x = Az_A./(2*pi./180.*17.5).*1.8955; %use a sinc... (17.5 deg beamwidth)
% hornradh = sin(x)./x;
% hornradh(x==0) = 1;
% hornrad = hornradv.*hornradh;
%

% %Panel A
 %xoffset = 9.5*0.0254;%0 %y separation between horn and metacenter %%%%%%%%%%%%%%

% %Panel B
% xoffset = -9.5*0.0254;
%

xoffset = 0; % meas_matrix are offset (*)
yoffset = 0;%-(.915-0.3045);     %y separation between horn and metaantenna center
zoffset = -.085;%-3.5*0.0254;     %z separation between horn and nearfield mesurement plane

%
if xor(dataALoaded,dataBLoaded)
    
    %%
    % construct 2d measurement matirx
    k0 = 2*pi.*F./3E8;
    %length(k0) %%%(*)
    if dataALoaded
        hornrad = ones(size(El_A)); %actually, let's just ignore the horn gain for now.
        nxy = size(Az_A,1)*size(Az_A,2);
        %initilize H with space for 6 channels
        H=zeros(length(F)*Ey_numswitchesA,nxy*nz);
    elseif dataBLoaded
        hornrad = ones(size(El_B)); %actually, let's just ignore the horn gain for now.
        nxy = size(Az_B,1)*size(Az_B,2);
        %initilize H with space for 6 channels
        H=zeros(length(F)*Ey_numswitchesB,nxy*nz);
    end
    
elseif (dataALoaded && dataBLoaded )
    hornrad = ones(size(El_B)); %actually, let's just ignore the horn gain for now.
    % construct 2d measurement matirx
    k0 = 2*pi.*F./3E8;
    
    nxy = size(Az_B,1)*size(Az_B,2);
    %initialize H with twice as much space
    H=zeros(length(F)*Ey_numswitchesA+length(F)*Ey_numswitchesB,nxy*nz);
end


%set number of banks
num_banks=2;

if dataALoaded
%Ey_PanAReducedMtx=flipdim(dataA.Ey_PanA,1);% mismatch btwn imported data.F and
Ey_PanAReducedMtx=dataA.Ey_PanA;
Ey_PanAReducedMtx=Ey_PanAReducedMtx(Elminind:Elmaxind,Azminind:Azmaxind,zindmin:zindmax,1:length(k0),1:6);
%Ey_PanAReducedMtx=dataA.Ey_PanA(Elminind:Elmaxind,Azminind:Azmaxind,zindmin:zindmax,1:length(k0),1:6); % mismatch btwn imported data.F and 
size(Ey_PanAReducedMtx)
end

if dataBLoaded
Ey_PanBReducedMtx=dataB.Ey_PanB(Elminind:Elmaxind,Azminind:Azmaxind,zindmin:zindmax,1:length(k0),1:6);%.*exp(1i*k0(fn).*0.1);
end

for Switchbank=1:num_banks
    for sn=1:6
%         for zn=zindmin:zindmax;
          for zn=1:length(zindmin:zindmax)
            z=Z(zindmin+zn-1);
            
            if Switchbank==1 && dataALoaded
                
                %calculate X, Y coordinates
                X = tan(Az_A).*z;
                
                Y = z.*tan(El_A)./cos(Az_A);

                rs = sqrt((z-zoffset)^2+(X-xoffset).^2+(Y-yoffset).^2);  %distance from horn to scene points (.09 correction for additional z path length)
                for fn=1:length(k0)
                    
                    %Ezfs = dataA.Ey_PanA(Elminind:Elmaxind,Azminind:Azmaxind,zn,fn,sn);%.*exp(1i*k0(fn).*0.1);%%%(*)
                    Ezfs = Ey_PanAReducedMtx(:,:,zn,fn,sn);%.*exp(1i*k0(fn).*0.1);%%%(*)
                    phase_s = exp(-1i.*k0(fn).*rs);  %phase advance from horn to scene points
                    %Ezfs = Ezfs.*phase_s.*abs(hornrad);
                   Ezfs = Ezfs.*phase_s.*abs(hornrad);
                    %H((Switchbank-1)*length(F)*6 + fn+length(F)*(sn-1),[1:nxy]+nxy*(zn-zindmin)) = Ezfs(:);
                    H((Switchbank-1)*length(F)*6 + fn+length(F)*(sn-1),[1:nxy]+nxy*(zn-1)) = Ezfs(:);
                end
                
            elseif Switchbank==2 && dataBLoaded
                X = tan(Az_B).*z;
                %Y = z.*tan(El); %??tan(Az)??
                Y = z.*tan(El_B)./cos(Az_B); %??tan(Az)??
                       
                rs = sqrt((z-zoffset)^2+(X-xoffset).^2+(Y-yoffset).^2);  %distance from horn to scene points (.09 correction for additional z path length)
                for fn=1:length(k0)
                    
                  %  Ezfs = dataB.Ey_PanB(Elminind:Elmaxind,Azminind:Azmaxind,zn,fn,sn);%.*exp(1i*k0(fn).*0.1);
                    Ezfs = Ey_PanBReducedMtx(:,:,zn,fn,sn);                 
                    phase_s = exp(-1i.*k0(fn).*rs);  %phase advance from horn to scene points
                    %Ezfs = Ezfs.*phase_s.*abs(hornrad);
                    Ezfs = Ezfs.*phase_s.*abs(hornrad);
                    %H(isstruct(dataA)*(Switchbank-1)*length(F)*6 + fn+length(F)*(sn-1),[1:nxy]+nxy*(zn-zindmin)) = Ezfs(:);
                   % H(dataALoaded*length(F)*6 + fn+length(F)*(sn-1),[1:nxy]+nxy*(zn-zindmin)) = Ezfs(:);
                    H(dataALoaded*length(F)*6 + fn+length(F)*(sn-1),[1:nxy]+nxy*(zn-1)) = Ezfs(:);
                end
                
            end
        end
    end
end

Z=Z(zindmin:zindmax);

if dataALoaded~=1 %for export out of funct in case Az_A and El_A are not assigned
    Az_A=Az_B;
    El_A=El_B;
end
