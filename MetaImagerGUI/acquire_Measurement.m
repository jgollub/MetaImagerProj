function [ g ] = acquire_Measurement(hObject,handles,vobj_switch,vobj_vna,axes1,F,ActivePanels, num_RFpaths, calData,buffersize, background)

num_Switches=sum(ActivePanels(:));

G = zeros(length(F),num_RFpaths,num_Switches);
g = zeros(length(F),num_RFpaths,num_Switches);

fprintf('%s','Collecting data...')

%sweep through all switches
SwitchPos=find(ActivePanels(:));

for iSwitch=1:num_Switches
    tic
    for sn1=1:num_RFpaths %cycle through s1 switches
        
        %collect data from VNA
        
        Activate_RFpath_L4445A(vobj_switch,SwitchPos(iSwitch),sn1);
        %measure S31
        calRead=calcorr(transpose(Read_N5245A(vobj_vna,buffersize,'MeasS31')),calData{SwitchPos(iSwitch)}.cal,'through'); %user cal 
        G(:,sn1,iSwitch) = calRead;
        g(:,sn1,iSwitch) = G(:,sn1,iSwitch) - background(:,sn1,iSwitch); %subtract background
       
        %figure
        figure(11)
        subplot(2,3,sn1)
        xlabel('frequency (GHz)')
        ylabel(['S_{A' num2str(sn1) '} dB'])
        plot(F,20.*log10(abs(g(:,sn1,iSwitch))),'-b')
        drawnow
    end
    toc
    Deactivate_RFpath_L4445A( vobj_switch, SwitchPos(iSwitch)) %close all RF paths for switch---need to ensure nothing is open when moving to next switch
end

fprintf('%s\n','done.')

g = g(:); % now g is a column vector with all fequencies for each path for each switch

end

