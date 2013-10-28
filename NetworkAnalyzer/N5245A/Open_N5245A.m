

function [PNAX_obj] = Open_N5245A()

instrhwinfo('gpib','ni')
PNAX_obj=gpib('ni', 0, 16);
% instrhwinfo('visa','ni')
% PNAX_obj=visa('ni', 'GPIB0::16::INSTR');

PNAX_obj.InputBufferSize = 2^16; %this will only allow to read up to 801 points 
fopen(PNAX_obj);

fprintf('*RST ');
fprintf(PNAX_obj,'DISP:ENABLE on');

data1 = query(PNAX_obj, '*IDN? ');
 %query is a java implimented version that shortcuts fprintf followed by fscanf
disp(['connected to' data1]);

fprintf(PNAX_obj,'MMEMory:STORe:TRACe:FORMat:SNP RI');


%fprintf(PNAX_obj, 'CALC:PAR:DEF "read_trace", S21');    
%fprintf(PNAX_obj, 'CALC:PAR:SELECT "read_trace"');

%%%%%%%%%%%%%%%%%%%%%
%fclose(PNAX_obj);

%fprintf(PNAX, 'RST');
%fprintf(PNAX, '*wai');

%set frequency sweep
%fprintf(PNAX, 'SENSE:FREQ:START 18ghz ');
%fprintf(PNAX, 'SENSE:FREQ:STOP 25ghz ');
%fprintf(PNAX, 'SENS:SWE:MODE:CONT');
%fprintf(PNAX, 'INIT:CONT ON');
%fprintf(PNAX, 'TRIGGER:SOURCE'); 
%fprintf(PNAX, 'SENS:SWE:POIN 201 ');

%setup the measurement "S12"
%fprintf(PNAX, 'CALC:PAR:DEFINE "S12",S12');

% fprintf(PNAX, 'SENSE:AVERAGE:STATE OFF');
% fprintf(PNAX, 'DISPLAY:ENABLE ON');

% fprintf(PNAX, 'DISP:WIND:TRAC:DELETE');
% fprintf(PNAX, 'DISP:WIND:TRAC:FEED "S12"');
% fprintf(PNAX, 'CALC:FORM MLIN');
% fprintf(PNAX, 'DISP:WIND:TRAC:Y:AUTO');
% fprintf(PNAX, 'DISP:WIND:TRAC:SEL');

%CALC:PAR:DEF “MyMeasurement”, S11
%CALC:PAR:SEL “MyMeasurement”
%CALC:DATA:SNP? 1

