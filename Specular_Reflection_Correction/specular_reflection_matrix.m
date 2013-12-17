function [Hp] = specular_reflection_matrix(H,F,Az,El,Z,ActivePanels,specularity)
%

if specularity==0
    Hp = H;
else
    %define panel positions here
    xp = [-0.5 0.5 1.5;...
          -0.5 0.5 1.5;...
          -0.5 0.5 1.5;...
          -0.5 0.5 1.5]*23.5*0.0254;
    yp = [-1  -1   -1; ...
          0    0    0; ...
          1    1    1; ...
          2    2    2]*17.5*0.0254;
     zp = 0.085;

    nazel = size(Az,2)*size(El,1);
    Nf = length(F);
    S = zeros(6*Nf*sum(ActivePanels(:)),nazel*length(Z));
    
    pn = 0;
    for prow=1:4 %for each panel..
        for pcol=1:3
            if ActivePanels(prow,pcol)
                pn = pn+1;
                for sn=1:6 %for each port... [in the future, we should add actual port locations from panel center,JH]
                    for zn=1:length(Z)
                        zf = Z(zn)*ones(size(Az));
                        %for every point in a single range plane calculate:
                        %unitvectors pointing from probe to scene points
                        xf = tan(Az).*zf;
                        yf = tan(El)./cos(Az).*zf;
                        mf = sqrt(xf.^2+yf.^2+zf.^2);
                        uxf = xf./mf;
                        uyf = yf./mf;
                        uzf = zf./mf;
                        %unitvectors pointing from scene points to panels
                        xa = xp(prow,pcol) - xf;
                        ya = yp(prow,pcol) - yf;
                        za = zp - zf;
                        ma = sqrt(xa.^2+ya.^2+za.^2);
                        uxa = xa./ma;
                        uya = ya./ma;
                        uza = za./ma;

                        Hspec = uxf.*uxa + uyf.*uya - uzf.*uza; %dot product between scene point unit vector and uf-up mirrored in z
                        %Haspec = (Haspec+1)./2; %this will make the gain function have a null only in the backward direction. otherwise there is a null at 90deg. from the illumination direction
                        S((1:Nf)+Nf*(sn-1)+6*Nf*(pn-1),(1:nazel)+nazel*(zn-1)) = repmat(transpose(Hspec(:)),[length(F),1]);
                    end
                end
            end
        end
    end
    Hp = H.*S.^specularity;
end

