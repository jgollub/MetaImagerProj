function [Hp] = specular_reflection_matrix(H,F,Az,El,Z,specularity)
%Note: this code is setup for a two-panel-Tx, horn-rx configuration with 
%switches 1:6 feeding the panel left of the horn and switches 7:12 feeding
%the panel on the right of the horn.

if specularity==0
    Hp = H;
else
    
    nazel = size(Az,2)*size(El,1);

    xA = -9.5*0.0254;
    xB = 9.5*0.0254;

    S = zeros(101*12,nazel*length(Z));
    for zn=1:length(Z)
        z = Z(zn)*ones(size(Az));
        for fn=1:length(F)  

            %scene points to panel A unitvectors
            xf = tan(Az).*z;
            yf = tan(El)./cos(Az).*z;
            mf = sqrt(xf.^2+yf.^2+z.^2);
            uxf = xf./mf;
            uyf = yf./mf;
            uzf = z./mf;
            %scene points to panel A unitvectors
            xa = xA-xf;
            ya = 0-yf;
            ma = sqrt(xa.^2+ya.^2+z.^2);
            uxa = xa./ma;
            uya = ya./ma;
            uza = z./ma;
            %scene points to panel B unitvectors
            xb = xB-xf;
            yb = 0-yf;
            mb = sqrt(xb.^2+yb.^2+z.^2);
            uxb = xb./mb;
            uyb = yb./mb;
            uzb = z./mb;

            Haspec = uxf.*uxa + uyf.*uya + uzf.*uza;
            Hbspec = uxf.*uxb + uyf.*uyb + uzf.*uzb;
%             Haspec = (Haspec+1)./2; %this will make the gain function have a null only in the backward direction. otherwise there is a null at 90deg. from the illumination direction
%             Hbspec = (Hbspec+1)./2;

            for s=1:6
                S(fn + length(F)*(s-1),(1:nazel)+nazel*(zn-1)) = Haspec(:);
            end
            for s=7:12
                S(fn + length(F)*(s-1),(1:nazel)+nazel*(zn-1)) = Hbspec(:);
            end
        end
    end
    Hp = H.*S.^specularity;
end



