function [vobj_switch, vobj_vna, buffersize,VNASweepFreqs]=initialize_MetaImager_Instr(fsamples,fstart, fstop,IFbandwidth,power,calfile)


%%% initialize instraments
delete(instrfind) %delete any existing instrament objects 
vobj_switch = start_L4445A; %open switch communications
Init_L4445A(vobj_switch); %initialize switches/modules/etc close all switches

vobj_vna = agilent_N5245A_NA_startVISAObject_TCPIP;           %open vna communications
[buffersize, VNASweepFreqs]=Initialize_N5245A_NoCalFile(vobj_vna, fsamples,fstart,fstop,IFbandwidth,power); %Cal file turned off!!!!!
%[buffersize, VNASweepFreqs] = Initialize_N5245A_FastwithThruCal(vobj_vna, fsamples,fstart,fstop,IFbandwidth,power,calfile);
%[buffersize, f] = Initialize_N5245A_vers3(vobj_vna, fsamples, fstart, fstop,IFbandwidth,calfile); % setup VNA scan

end

