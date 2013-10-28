function [background]=measure_MetaImager_Background(hObject,handles,vobj_switch,vobj_vna, axes1,avg_factor,F,ActivePanels, num_RFpaths, buffersize)

%initialize size of matrix
num_Switches=sum(ActivePanels(:));
background = zeros(length(F),num_RFpaths,num_Switches);
    
%sweep through all switches
SwitchPos=find(ActivePanels(:));

for iSwitch=1:num_Switches %find number for all nonzero switches
    for sn1=1:num_RFpaths
        
        %collect data from VNA: switch S31
        
        Activate_RFpath_L4445A(vobj_switch,SwitchPos(iSwitch),sn1);

        %measure s31 panel to horn
        for an=1:avg_factor
            background(:,sn1,iSwitch) = background(:,sn1,iSwitch) + transpose(Read_N5245A(vobj_vna,buffersize,'MeasS31'));
        end
        background(:,sn1,iSwitch) = background(:,sn1,iSwitch)./avg_factor;
        
        % plot on axes 1
        cla(axes1);
        axes(axes1);
        title('Background Measurment')
        
        xlabel('frequency (GHz)')
        ylabel(['S_{A' num2str(sn1) '} dB'])
        plot(F,20.*log10(abs(background(:,sn1,iSwitch))),'-b')
        % handles.mostRecPlot=plot(F,20.*log10(abs(background(:,sn1,Switchbank))),'-k','LineWidth',3);
        drawnow
        
    end
    
end
end
