function [background]=measure_MetaImager_Background(hObject,handles,vobj_switch,vobj_vna, axes1,avg_factor,F,PanelInd, num_RFpaths,calData,buffersize)


%initialize size of matrix
background = zeros(length(F),num_RFpaths);
    
%Plotting initialization
        % plot on axes 1
        
        hold on
        cla(axes1);
        axes(axes1);
        title('Background Measurment')
        xlabel('frequency (GHz)')
      
    for sn1=1:num_RFpaths
        
        %collect data from VNA: switch S31
        
        Activate_RFpath_L4445A(vobj_switch,PanelInd,sn1);

        %measure s31 panel to horn
        for an=1:avg_factor
              while ~query(vobj_switch,'*OPC?');
                  pause(.001)
              end
              calRead=calcorr(transpose(Read_N5245A(vobj_vna,buffersize,'MeasS31')),calData{PanelInd}.cal,'through');
              background(:,sn1) = background(:,sn1) + calRead;
            %background(:,sn1,iSwitch) = background(:,sn1,iSwitch) + transpose(Read_N5245A(vobj_vna,buffersize,'MeasS31'));        
        end
        background(:,sn1) = background(:,sn1)./avg_factor;
       
        axes(axes1);
        ylabel(['S_{A' num2str(sn1) '} dB'])
        plot(F,20.*log10(abs(background(:,sn1))),'-b')
        % handles.mostRecPlot=plot(F,20.*log10(abs(background(:,sn1,Switchbank))),'-k','LineWidth',3);
        drawnow   
    end
    Deactivate_RFpath_L4445A( vobj_switch, PanelInd) %close all RF paths for switch
end

