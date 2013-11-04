

context = mxNiCreateContext('C:\Users\Lab\Dropbox\MetaImager Project\Programming Scripts\Kinect\kinect-mex1.3-windows\[v1.3] for OpenNI Unstable Build for Windows v1.0.0.25\Config\SamplesConfig.xml');


[thetac, rc, rgb] = niImage_RangeConstraints_fun(context);
if sum(~isnan(rc))~=0
    thetacmax = max(thetac(~isnan(rc)))*180/pi+2.5;
    thetacmin = min(thetac(~isnan(rc)))*180/pi-2.5;
    rcmin = min(rc);
    rcmax = rcmin+1;
    regularization = 4*regularization*(thetacmax-thetacmin)*(rcmax-rcmin)/((phimax-phimin)*(rmax-rmin));
else
    thetacmax = phimax;
    thetacmin = phimin;
    rcmin = rmin;
    rcmax = rmax;
end
