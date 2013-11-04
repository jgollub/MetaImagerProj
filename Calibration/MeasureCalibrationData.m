%calibrate 12 panel cables
%A2

fsamples=101;
fstart=17.5;
fstop=26.5;
IFbandwidth=1000;
power=-10;

avg_factor=10;
%initialize cal data
cal=[];

%set switch path to test
switchtest=1;

RFpath=1; %any would work as for cal we are not connected through switch

%initialize VNA (N5245A) and Switching device (L4445A)
delete(instrfind) %delete any existing instrament objects 
vobj_switch = start_L4445A; %open switch communications
Init_L4445A(vobj_switch); %initialize switches/modules/etc close all switches

vobj_vna = agilent_N5245A_NA_startVISAObject_TCPIP;           %open vna communications
[buffersize, cal.f] = Initialize_N5245A_NoCalFile(vobj_vna, fsamples,fstart,fstop,IFbandwidth,power);

%turn path on
Activate_RFpath_L4445A(vobj_switch, switchtest,RFpath);
%activate probe path
fprintf(vobj_switch,'ROUT:CLOS (@1271)')
query(vobj_switch,'*OPC?');

cal.t=zeros(fsamples,1);
for i=1:avg_factor
cal.t=transpose(Read_N5245A(vobj_vna,buffersize,'MeasS31'))+cal.t;
query(vobj_vna,'*OPC?');
end
cal.t = (cal.t)./avg_factor;

save('C:\Users\MetaImagerDuo\Documents\MetaImager Project\RF Switch Path Calibration\A1RFpathCal.mat','cal');
test=transpose(Read_N5245A(vobj_vna,buffersize,'MeasS31'));
figure(21);
plot(cal.f,20*log10(abs(test)),cal.f,20*log10(abs(calcorr(test,cal,'through'))));