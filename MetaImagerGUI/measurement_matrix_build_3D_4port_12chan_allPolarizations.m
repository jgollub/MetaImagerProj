% clear
% home
% close all

function [H F Az El Z] = measurement_matrix_build_3D_4port_12chan_allPolarizations(dmin,dmax,nfreqs,Azmin,Azmax,Elmin,Elmax,data,ActivePanels,num_RFpaths)%filename)
%data offset 

%switch number
SwitchPos=find(ActivePanels(:));

%assign variable, matrices, etc.

%use first matrix to get general coordinate system--- all systems must be
%built referenced to one coordinate system

    findexes = unique(round(linspace(1,length(data{SwitchPos(1)}.F),nfreqs)));
    %E_numswitches = size(dataA.E_PanA,5); %if we change this to reassign later it will prevent large data set from being loaded
    E_numswitches = num_RFpaths; %hard setting in order to speed up load
    F = data{SwitchPos(1)}.F(1,findexes);
%     El_A = dataA.El; %flipdim due to flipped El in matrix build
    El= data{SwitchPos(1)}.El;
    Az = data{SwitchPos(1)}.Az; %(*)
    Z = data{SwitchPos(1)}.Z;
    
    [dum, zindmin] = min(abs(Z-dmin));
    [dum, zindmax] = min(abs(Z-dmax));
    [dum, Azminind] = min(abs(Az(1,:)-Azmin));
    [dum, Azmaxind] = min(abs(Az(1,:)-Azmax));
    [dum, Elminind] = min(abs(El(:,1)-Elmin));
    [dum, Elmaxind] = min(abs(El(:,1)-Elmax));
    
    Az = Az(Elminind:Elmaxind,Azminind:Azmaxind); %%%
    El = El(Elminind:Elmaxind,Azminind:Azmaxind); %%%
nz = zindmax-zindmin+1;
%Z = Z(indmin:indmax);

% Horn radiation pattern
%set to 1 for now: see previous versions for notes

%position of horn with respect to coordinate system
xoffset = 0; % meas_matrix are offset (*)
yoffset = 0;%-(.915-0.3045);     %y separation between horn and metaantenna center
zoffset = -.085;%-3.5*0.0254;     %z separation between horn and nearfield mesurement plane

% construct Measurement matrix
k0 = 2*pi.*F./3E8;

hornrad = ones(size(El)); %actually, let's just ignore the horn gain for now.
nxy = size(Az,1)*size(Az,2);

%initilize H with space for (6 RF channels x number of switches)
H=zeros(length(F)*E_numswitches*sum(ActivePanels(:)),nxy*nz);

for iSwitch=1:sum(ActivePanels(:))
    %pull out reduced H matrix
    E_PanReducedMtx=data{SwitchPos(iSwitch)}.Ey_Pan(Elminind:Elmaxind,Azminind:Azmaxind,zindmin:zindmax,1:length(k0),1:6);
  
    for sn=1:num_RFpaths
        %         for zn=zindmin:zindmax;
        for zn=1:length(zindmin:zindmax)
            z=Z(zindmin+zn-1);
            
            %calculate X, Y coordinates
            X = tan(Az).*z;
            Y = z.*tan(El)./cos(Az);
            
            rs = sqrt((z-zoffset)^2+(X-xoffset).^2+(Y-yoffset).^2);  %distance from horn to scene points (.09 correction for additional z path length)
            for fn=1:length(k0)
                
                %Ezfs = dataA.E_PanA(Elminind:Elmaxind,Azminind:Azmaxind,zn,fn,sn);%.*exp(1i*k0(fn).*0.1);%%%(*)
                Ezfs = E_PanReducedMtx(:,:,zn,fn,sn);%.*exp(1i*k0(fn).*0.1);%%%(*)
                phase_s = exp(-1i.*k0(fn).*rs);  %phase advance from horn to scene points
                %Ezfs = Ezfs.*phase_s.*abs(hornrad);
                Ezfs = Ezfs.*phase_s.*abs(hornrad);
                %H((Switchbank-1)*length(F)*6 + fn+length(F)*(sn-1),[1:nxy]+nxy*(zn-zindmin)) = Ezfs(:);
                H((iSwitch-1)*length(F)*6 + fn+length(F)*(sn-1),[1:nxy]+nxy*(zn-1)) = Ezfs(:);
            end
        end
    end
end

Z=Z(zindmin:zindmax);

