function [ ] = Init_L4445A(vobj_switch)

%module 1
 fprintf(vobj_switch, 'SYST:RMOD:RES 1'); %reset remote modules to factory defaults
 
 
 fprintf(vobj_switch, 'ROUT:RMOD:BANK:PRESET ALL,(@1100)'); %module 1, set presets on module. Each distribution board has associated preset
 %fprintf(obj, 'ROUT:RMOD:BANK:PRESET ALL,(@1200)'); %module 2, set presets on module. Each distribution board has associated preset
 
 %fprintf(vobj_switch, 'ROUTe:RMODule:BANK:DRIVe TTL, BANK1, (@1100)') %!!!!!!!!!!!!!!! set drive mode for 24V TTL switches
 
 fprintf(vobj_switch,'ROUT:CHAN:DRIV:OPEN:DEF (@1101:1178)'); % module 1 default is switches open (non transmitting)
% fprintf(obj,'ROUT:CHAN:DRIV:OPEN:DEF (@1201:1178)'); % Module 2 "
 
 fprintf(vobj_switch,'ROUT:RMOD:DRIV:SOUR EXT,(@1100)'); %first module can be powererd by L4445A
 fprintf(vobj_switch,'ROUT:RMOD:DRIV:SOUR EXT,(@1200)'); %second module must be powered by external power supply
 
 %close all switches
 for j=1:2
     for i=0:7
         fprintf(vobj_switch,['ROUT:CLOS (@1',num2str(j), num2str(i),'7)'])
     end
 end

 query(vobj_switch,'*OPC?');

 
 %fprintf(obj,'ROUT:CLOS (@1107)'); %open all switches: by closing element 1107 or 1108 all switches are opened (no RF path)  
 
%note 
% by closing element 1xx7 or 1xx8 all switches are opened (no RF path) on that switch 