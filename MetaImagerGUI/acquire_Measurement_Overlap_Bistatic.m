function [ g ]= acquire_Measurement_Overlap_Bistatic(hObject,handles,vobj_switch,vobj_vna,axes1,F,num_switches,num_banks, buffersize, background)


Nf = length(F);
G = zeros(length(F)*num_switches,1);
g = zeros(length(F)*num_switches,1);
fprintf('%s','Collecting data...')

sc = 0;
for sn1=1:num_switches %cycle through s1 switches
    agilent_11713C_switchdriver_openChannelNumbers(handles.vobj_switch,1,sn1)
    %collect data from VNA
          
        %check for Abort interrupt
        userData = get(handles.AbortButtonTag, 'UserData');
        if userData
            return
        end
        
        agilent_11713C_switchdriver_openChannelNumbers(vobj_switch,2,sn1)
        
        Gsc = Read_N5245A(vobj_vna,buffersize,'MeasS21');
        G((1:Nf)+Nf*sc) = transpose(Gsc);
        sc = sc+1;

        agilent_11713C_switchdriver_closeChannelNumbers(vobj_switch,2,sn1)     
        agilent_11713C_switchdriver_closeChannelNumbers(vobj_switch,1,sn1)
end
fprintf('%s\n','done.')

g = G-background;

%g = g(:);
%% psuedo-inverse
% obj = Hinv*g;
end

