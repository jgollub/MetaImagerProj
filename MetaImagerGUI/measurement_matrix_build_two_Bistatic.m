function [H F Az El Z] = measurement_matrix_build_two_Bistatic(dmin,dmax,nfreqs,Azmin,Azmax,Elmin,Elmax,dataA,dataB)%filename)

findexes = unique(round(linspace(1,length(dataA.F),nfreqs)));

F = dataA.F(1,findexes);

El = dataA.El;
Az = dataA.Az;
Z = dataA.Z;

[dum, zindmin] = min(abs(Z-dmin));
[dum, zindmax] = min(abs(Z-dmax));
[dum, Azminind] = min(abs(Az(1,:)-Azmin));
[dum, Azmaxind] = min(abs(Az(1,:)-Azmax));
[dum, Elminind] = min(abs(El(:,1)-Elmin));
[dum, Elmaxind] = min(abs(El(:,1)-Elmax));

Az = Az(Elminind:Elmaxind,Azminind:Azmaxind);
El = El(Elminind:Elmaxind,Azminind:Azmaxind);
Z=Z(zindmin:zindmax);
Eax = dataA.Ex_PanA(Elminind:Elmaxind,Azminind:Azmaxind,zindmin:zindmax,findexes,1:6);
Eay = dataA.Ey_PanA(Elminind:Elmaxind,Azminind:Azmaxind,zindmin:zindmax,findexes,1:6);
Eaz = dataA.Ez_PanA(Elminind:Elmaxind,Azminind:Azmaxind,zindmin:zindmax,findexes,1:6);
Ebx = dataB.Ex_PanB(Elminind:Elmaxind,Azminind:Azmaxind,zindmin:zindmax,findexes,1:6);
Eby = dataB.Ey_PanB(Elminind:Elmaxind,Azminind:Azmaxind,zindmin:zindmax,findexes,1:6);
Ebz = dataB.Ez_PanB(Elminind:Elmaxind,Azminind:Azmaxind,zindmin:zindmax,findexes,1:6);

nz = length(Z);
nxy = size(Az,1)*size(Az,2);

%resort H into a 2D array
H=zeros(101*36,nxy*nz);
for sn=1:6
    for rn=1:6
        H2 = Eax(:,:,:,:,sn).*Ebx(:,:,:,:,rn)+Eay(:,:,:,:,sn).*Eby(:,:,:,:,rn);%+Eaz(:,:,:,:,sn).*Ebz(:,:,:,:,rn);
        for zn=1:nz
             for fn=1:length(F);
                Hzfs = H2(:,:,zn,fn);
                H(fn+length(F)*(rn-1)+length(F)*6*(sn-1),(1:nxy)+nxy*(zn-1)) = Hzfs(:);
            end
        end
    end
end


