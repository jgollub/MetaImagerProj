function [vobj_switch vobj_vna buffersize num_switches num_banks]=initialize_MetaImager_Instr(fsamples,fstart, fstop,IFbandwidth,calfile)


%%% initialize instraments
delete(instrfind) %delete any existing instrament objects 
vobj_switch = start_L4445A; %open switch communications
Init_L4445A(vobj_switch); %initialize switches/modules/etc close all switches

vobj_vna = agilent_N5245A_NA_startVISAObject_TCPIP;           %open vna communications
[buffersize, f] = Initialize_N5245A_vers3(vobj_vna, fsamples, fstart, fstop,IFbandwidth,calfile); % setup VNA scan
pause(2) %wait for VNA 
num_switches=6; %six switches per bank
num_banks=2; %two banks (total of 12 switches)
% for i_bank=1:num_banks
% agilent_11713C_switchdriver_closeChannelNumbers(vobj_switch,repmat(i_bank,[1,num_switches]),[1:num_switches])
% end

%%% 8364B setup

% delete(instrfind) %delete any existing instrament objects
% vobj_switch = agilent_11713C_switchdriver_startVISAObject; %open switch communications
% vobj_vna    = agilent_E8364B_NA_startVISAObject;           %open vna communications
% [buffersize, f] = Initialize_8364B(handles.vobj_vna, fsamples, fstart, fstop); % setup VNA scan
% %close all switches
% for i_bank=1:handles.num_banks
%     agilent_11713C_switchdriver_closeChannelNumbers(handles.vobj_switch,i_bank,[1:handles.num_switches])
% end
% 
% %%define Read and control functions