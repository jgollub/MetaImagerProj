function [inputBufSize VNASweepFreqs] = Initialize_N5245A_NoCalFile(NAobj, numSweepPoints,fstart,fstop,IFbandInHZ,power) %Assumes NAobj is already opened

%preset analyzer
%delete all previous parameters
fprintf(NAobj, 'CALC:PAR:DEL:ALL')

%return to default setting
fprintf(NAobj,'SYST:PRESet');

query(NAobj,'*OPC?');

%'Define a measurement from port one to horn, s31 parameter
fprintf(NAobj,'CALCulate:PARameter:DEFine:EXT "MeasS31",S31');

fprintf(NAobj, ['SENSE:FREQ:START ', num2str(fstart),'ghz ']);
fprintf(NAobj, ['SENSE:FREQ:STOP ', num2str(fstop),'ghz ']); 

%%%%%%%%%%%%%%%%%%%
% %%turn Cal file off 
% fprintf(NAobj,'SENS:CORR:CSET:ACT ,0');
% query(NAobj,'*OPC?');
% 
% %print working cal file
% fprintf('VNA Correction set to:  "%s"\n',calfile) 

%Query and print ot screen Power setting (set by Cal)
powerread=query(NAobj,'SOURce1:POWer? '); 
fprintf('power output(dB)= %s\n', powerread)

%reset power to desired value
fprintf(NAobj,'SOUR:POW1 %s ', num2str(power))
%fprintf(NAobj,'SOUR:POW2 %s ', num2str(power))

%check that power was set
powerread=query(NAobj,'SOURce1:POWer? '); 
fprintf('power reset to (dB) = %s', powerread)

%set IF bandwidth--- to go after scaling or it is screwy
fprintf(NAobj,['SENSe:BANDwidth ', num2str(IFbandInHZ), ' '])
query(NAobj,'*OPC?');

%%%%%%% turn screen off
fprintf(NAobj,'DISP:ENABLE ON');
query(NAobj,'*OPC?');

%%Set trigger parameters
%turn off continuous sweep and wait for trigger signal
fprintf(NAobj,'INIT:CONT OFF ')
query(NAobj,'*OPC?');

%set number of poinst to sweep
fprintf(NAobj,['SENS:SWE:POIN ', num2str(numSweepPoints), ' '])
query(NAobj,'*OPC?');

%Set trigger to manual, and only trigger active channel
fprintf(NAobj, 'TRIG:SOUR MAN ');
fprintf(NAobj, 'TRIG:SCOP CURR ');
query(NAobj,'*OPC?');

%do test trigger
fprintf(NAobj,'INIT:IMM ');
query(NAobj,'*OPC?');

%Set output format as ASCII
fprintf(NAobj, 'FORMAT:DATA ASCII,0 ');

%Each data point returned from the NA using ASCII is 20 characters long. 
%Thus input Buffer needs to be the number of points in each sweep times 20.
inputBufSize = numSweepPoints*20;

%inputBufSize = 2^16; %this will only allow to read up to 801 points

%Set input buffer size (must close object)
fclose(NAobj);
set(NAobj, 'InputBufferSize', inputBufSize);
fopen(NAobj);


%Get frequency values used in the sweep
fprintf(NAobj, 'SENSE:X?');
VNASweepFreqs = eval(['[' fscanf(NAobj, '%c', inputBufSize) ']']);
query(NAobj,'*OPC?');
end

