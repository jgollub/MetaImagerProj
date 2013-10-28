function [ background ] = measure_MetaImager_Background_Bistatic(hObject,handles,vobj_switch,vobj_vna, axes1,avg_factor,F,num_switches,num_banks, buffersize, panelA)

%measure_MetaImager_Background_Bistatic Summary of this function goes here
%   Detailed explanation goes here
%% take background

Nf = length(F);
background = zeros(Nf*num_switches*num_switches,1);
sc = 0;

for sn1=1:num_switches
    agilent_11713C_switchdriver_openChannelNumbers(vobj_switch,1,sn1)
    for sn2=1:num_switches %cycle through each switch pair

        %check for Abort interrupt
     userData = get(handles.AbortButtonTag, 'UserData');
     if userData
        return
     end
  
%take background scans  
        agilent_11713C_switchdriver_openChannelNumbers(vobj_switch,2,sn2)
        
        for an=1:avg_factor
            %collect data from VNA
            background((1:Nf)+Nf*sc) = background((1:Nf)+Nf*sc)+transpose(Read_N5245A(vobj_vna,buffersize,'MeasS21'));
            %background(:,sn1*(num_switches-1)+sn2) = background(:,sn1,sn2) + transpose(Read_8364B(vobj_vna,buffersize));
        end
        
        %background(:,sn1,sn2) = background(:,sn1,sn2)./avg_factor;
         background((1:Nf)+Nf*sc) = background((1:Nf)+Nf*sc)./avg_factor;
         sc = sc+1;
         
        agilent_11713C_switchdriver_closeChannelNumbers(vobj_switch,2,sn2)


    end
    agilent_11713C_switchdriver_closeChannelNumbers(vobj_switch,1,sn1)
    
    
end
fprintf('%s\n','done.')
end



