%before calling this function, create a Kinect context with:
% context = mxNiCreateContext('C:\Users\Lab\Dropbox\MetaImager Project\Programming Scripts\Kinect\kinect-mex1.3-windows\[v1.3] for OpenNI Unstable Build for Windows v1.0.0.25\Config\SamplesConfig.xml');
%be sure to delete the context with:
% mxNiDeleteContext(context);
%before creating a new one or you will have to
%restart the computer to reestablish comm with Kinect.

% Get RGB and DEPTH image via Kinect
%% Create context with xml file

function [Az_extent, El_extent, Z_extent, objs] = niImage_multiobjects_RangeConstraints_fun(XYZ)
% home
% clear Az_extent
% close all
% tic
%define room boundaries
room_ymin = -0.90;
room_ymax = 0.900;
room_xmax = 1.40;
room_xmin = -1.40;
room_zmax = 3.5000;
room_zmin = 0;

%% find walls. walls are object 1
objs = (XYZ(:,:,2)<room_ymin) | (XYZ(:,:,2)>room_ymax) | (XYZ(:,:,1)<room_xmin) | (XYZ(:,:,1)>room_xmax) | (XYZ(:,:,3)>room_zmax) | (XYZ(:,:,3)<room_zmin);
XYZ(repmat(objs,[1,1,3])) = NaN;

%% find objects separated by Z
Z = XYZ(:, :, 3);

%find the number of Z distances greater than corresponding threshold
thresh = room_zmin:150E-3:room_zmax; % the step size here (meters) determines the range-object sensitivity. too small will creat many objects;large will not recognize objects by range.
gt = zeros(1,length(thresh));
for tn=1:length(thresh)
    gt(tn) = sum(sum(Z>=thresh(tn)));
end

%whenever the change in gt goes to zero we have left an object
thresh_prev = thresh(1);
in_obj = false;
for tn=2:length(thresh)
    if (gt(tn)-gt(tn-1))==0 && in_obj
        in_obj = false;
        objs = cat(3,objs, Z>=thresh_prev & Z<=thresh(tn) );
        thresh_prev = thresh(tn);
    elseif (gt(tn)-gt(tn-1))~=0 && ~in_obj
        in_obj = true;
    end
end
%gotta get that last object if we havent left it by the last range threshold...
if in_obj
    objs = cat(3,objs, Z>=thresh_prev & Z<=thresh(end) );
end

%% find objects seperated by x and y

%check for x-separation
objsnew = objs;
for n=1:size(objs,3)
   s = sum(objs(:,:,n),1);
   in_obj = false;
   ind = [];
   objn = 1;
   for nx=2:640 %make a list of object start and stop x indices
       if s(nx)~=0 && ~in_obj
           ind(objn,1) = nx;
           in_obj = true;
       elseif s(nx)==0 && in_obj
           ind(objn,2) = nx-1;
           in_obj = false;
           objn = objn+1;
       end
   end
   %if we found separate objects, identify them
   for objn=2:size(ind,1)
       onew = zeros(480,640);
       onew(:,ind(objn,1):ind(objn,2)) = objs(:,ind(objn,1):ind(objn,2),n);
       oold = objsnew(:,:,n);
       oold(onew==1) = 0;
       objsnew(:,:,n) = oold;
       objsnew = cat(3,objsnew,onew);
   end
end
objs = objsnew;

%check for y-separation
objsnew = objs;
for n=1:size(objs,3)
   s = sum(objs(:,:,n),2);
   in_obj = false;
   ind = [];
   objn = 1;
   for ny=2:480 %make a list of object start and stop x indices
       if s(ny)~=0 && ~in_obj
           ind(objn,1) = ny;
           in_obj = true;
       elseif s(ny)==0 && in_obj
           ind(objn,2) = ny-1;
           in_obj = false;
           objn = objn+1;
       end
   end
   %if we found separate objects, identify them
   for objn=2:size(ind,1)
       onew = zeros(480,640);
       onew(ind(objn,1):ind(objn,2),:) = objs(ind(objn,1):ind(objn,2),:,n);
       oold = objsnew(:,:,n);
       oold(onew==1) = 0;
       objsnew(:,:,n) = oold;
       objsnew = cat(3,objsnew,onew);
   end
end
objs = objsnew;

%% calculate object extents
Nobj = size(objs,3);
Z_extent = zeros(Nobj,2);
Az_extent = zeros(Nobj,2);
El_extent = zeros(Nobj,2);

%objs(objs==0) = NaN;
X = XYZ(:,:,1);
Y = XYZ(:,:,2);
for n=1:Nobj
    obj = objs(:,:,n)==1;
    z = Z(obj);
    Z_extent(n,:) = [min(min(z)) max(max(z))];
    Az = atan(X(obj)./z);
    Az_extent(n,:) = [min(min(Az)) max(max(Az))];
    El = atan(Y(obj)./z);
    El_extent(n,:) = [min(min(El)) max(max(El))];
end

objs = objs==1;

% %% plotting
% % imagesc(Z)
% figure;
% objall = zeros(size(Z));
% for n=1:size(objs,3)
%     objall = objall+objs(:,:,n)*n;
% end
% imagesc(objall)






