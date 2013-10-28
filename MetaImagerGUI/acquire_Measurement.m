function [ g ] = acquire_Measurement(hObject,handles,vobj_switch,vobj_vna,axes1,F,num_switches,num_banks, buffersize, background,panelA,panelB,dataALoaded,dataBLoaded)
n=1;

if dataALoaded && dataBLoaded
    G = zeros(length(F),num_switches,num_banks);
    g = zeros(length(F),num_switches,num_banks);
elseif dataALoaded || dataBLoaded
    G = zeros(length(F),num_switches,1);
    g = zeros(length(F),num_switches,1);
end

fprintf('%s','Collecting data...')

for Switchbank=1:num_banks
    for sn1=1:num_switches %cycle through s1 switches
        
        %collect data from VNA
        
        %depending on channel
        if Switchbank==1 && dataALoaded
            
            Activate_RFpath_L4445A(vobj_switch,num_banks,sn1);
            %agilent_11713C_switchdriver_openChannelNumbers(vobj_switch,Switchbank,sn1)%open switch
            %measure S31 Panel A to horn
            G(:,sn1,Switchbank) = Read_N5245A(vobj_vna,buffersize,'MeasS31');
            %agilent_11713C_switchdriver_closeChannelNumbers(vobj_switch,Switchbank,sn1) %close switch
            g(:,sn1,Switchbank) = G(:,sn1,Switchbank) - background(:,sn1,Switchbank); %subtract background
            
%             figure(Switchbank);
%             subplot(3,2,sn1);
%             hold on
%             xlabel('frequency (GHz)')
%             ylabel(['S_{A',num2str(Switchbank), num2str(sn1), '} dB'])
%             plot(F,20.*log10(abs(G(:,sn)))); hold on
            
%             plot(F./1E9,20.*log10(abs(g(:,sn1,Switchbank))),'r');
%             if n==1
%                 
%                 plot(F./1E9,20.*log10(abs(g(:,sn1,Switchbank))),'g');
%             end
%             ylim([-110 -50])
%             drawnow

%             cla(axes1);
%             axes(axes1);
%             title('Background Measurment')
      

%             if sn1~=1
%                 %set(mostRecPlot,'Visible','off');
%                %delete(handles.mostRecPlot); %delete bold previous line plot
%             end
             figure(15)
            xlabel('frequency (GHz)')
            ylabel(['S_{A' num2str(sn1) '} dB'])
            plot(F,20.*log10(abs(g(:,sn1,Switchbank))),'-b')
             
             %             xlabel('frequency (GHz)')
%             ylabel(['S_{7' num2str(sn1) '} dB'])
%             plot(F,20.*log10(abs(background(:,sn1,Switchbank))),'-b')
%             handles.mostRecPlot=plot(F,20.*log10(abs(background(:,sn1,Switchbank))),'-k','LineWidth',3);
%             drawnow
            
        elseif Switchbank==num_banks && dataBLoaded
            agilent_11713C_switchdriver_openChannelNumbers(vobj_switch,Switchbank,sn1)%open switch
            %measure S31 Panel A to horn
            G(:,sn1,-(~dataALoaded)+Switchbank) = Read_N5245A(vobj_vna,buffersize,'MeasS32');
            agilent_11713C_switchdriver_closeChannelNumbers(vobj_switch,Switchbank,sn1) %close switch
            g(:,sn1,-(~dataALoaded)+Switchbank) = G(:,sn1,-(~dataALoaded )+Switchbank) - background(:,sn1,-(~dataALoaded)+Switchbank); %subtract background
            
%             figure(Switchbank);
%             subplot(3,2,sn1);
%             hold all
%             xlabel('frequency (GHz)')
%             ylabel(['S_{3',num2str(Switchbank), num2str(sn1), '} dB'])
%             plot(F,20.*log10(abs(G(:,sn)))); 
%             
             %plot(F./1E9,20.*log10(abs(g(:,sn1,-~isstruct(panelA)+Switchbank))),'r');
%             if n==1
%                 
%                 plot(F./1E9,20.*log10(abs(g(:,sn1,-~isstruct(panelA)+Switchbank))),'g'); hold off
%             end
%             ylim([-110 -50])
%             drawnow
%             cla(axes1);
%             axes(axes1);
%             title('Background Measurment')
%       
%             
%             if sn1~=1
%                 %set(mostRecPlot,'Visible','off');
%                %delete(handles.mostRecPlot); %delete bold previous line plot
%             end
            figure(15)
            xlabel('frequency (GHz)')
            ylabel(['S_{b' num2str(sn1) '} dB'])
            plot(F,20.*log10(abs(g(:,sn1,-(~dataALoaded )+Switchbank))),'-b')
%             handles.mostRecPlot=plot(F,20.*log10(abs(g(:,sn1,Switchbank))),'-k','LineWidth',3);
%             drawnow

        end
        
    end
    n=n+1;
end
fprintf('%s\n','done.')

g = g(:); % now g is a column vector with all fequencies for switch 1, then all freq for switch 2 etc., same as the rows of H

end

