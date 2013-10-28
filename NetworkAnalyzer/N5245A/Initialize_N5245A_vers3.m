function [inputBufSize freqs] = Initialize_N5245A_vers3(NAobj, numSweepPoints,fstart,fstop,IFbandInHZ,calfile) %Assumes NAobj is already opened
power=13;
 
%preset analyzer
%delete all previous parameters
fprintf(NAobj, 'CALC:PAR:DEL:ALL')

%return to default setting
fprintf(NAobj,'SYST:PRESet');

%
% Create and turn on window 1% already turned on by
 %SYST:PRESet
 %fprintf(NAobj,'DISPlay:WINDow1:STATE ON'); 

%create and turn window 2
 fprintf(NAobj,'DISPlay:WINDow2:STATE ON');
%query(NAobj,'*OPC?');


 %create and turn window 3
 fprintf(NAobj,'DISPlay:WINDow3:STATE ON');
 %fprintf(NAobj,'*OPC?');

 %fprintf(NAobj,'*OPC?');
 
%'Define a measurement from port one to horn, s31 parameter
fprintf(NAobj,'CALCulate:PARameter:DEFine:EXT "MeasS31",S31');

fprintf(NAobj, ['SENSE:FREQ:START ', num2str(fstart),'ghz ']);
fprintf(NAobj, ['SENSE:FREQ:STOP ', num2str(fstop),'ghz ']); 

%define a measurement from port 2 to horn, s32
 fprintf(NAobj,'CALCulate:PARameter:DEFine:EXT "MeasS32",S32');
%define sweep parameters
 fprintf(NAobj, ['SENSE:FREQ:START ', num2str(fstart),'ghz ']);
fprintf(NAobj, ['SENSE:FREQ:STOP ', num2str(fstop),'ghz ']); 

%define a measurement from panel A to panel B, s21
fprintf(NAobj,'CALCulate:PARameter:DEFine:EXT "MeasS21",S21');
%define sweep parameters
fprintf(NAobj, ['SENSE:FREQ:START ', num2str(fstart),'ghz ']);
fprintf(NAobj, ['SENSE:FREQ:STOP ', num2str(fstop),'ghz ']); 

 %select Calibration must come after frequency range is defined for a
%calibration or else it will hard fail vna software

%%%%%%%%%%%%%%%%%%%
%%See Calibrations query(vobj_vna,'SENS:CORR:CSET:CAT? Name')
fprintf(NAobj,'SENS:CORR:CSET:ACT "%s",1',calfile);%!!!!!!!!!!!!! calfile
%turned off
fprintf('VNA Correction set to:  "%s"\n',calfile) %!!!!!!!!!!!!!! Calfile
%turned off
%%%%%%%%%%%%%

fprintf(NAobj,'SOUR:POW1 %s ', num2str(power))
%fprintf(NAobj,'SOUR:POW2 %s ', num2str(power))
% pause(.5)
powerread=query(NAobj,'SOURce1:POWer? '); 
% pause(.5)
fprintf('power reset to (dB) = %s', powerread)

% fprintf(NAobj,'SENS:CORR:CSET:ACT "Cal_3port_S123_1ftToAmp_6ftToAnt_6ftToHorn061713",1')
% fprintf('VNA Correction set to: "Cal_3port_S123_1ftToAmp_6ftToAnt_6ftToHorn061713"\n')

 fprintf('power output(dB)= %s', query(NAobj,'SOURce1:POWer?\n'))

% % %check the defined measurments
% fprintf(['measurments setup:  ', query(NAobj,'CALCulate:PARameter:CATalog?'),'\n '])
pause(1.5)

%  %Take and dispay S31 into window 1 %%% already in window 1
% fprintf(NAobj,'DISPlay:WINDow1:TRACe1:FEED "MeasS31"')

%pause to allow window to load:the usual query(NAobj,'*OPC?') doesn't
%work because it is an windows thing....

%autoscale 
fprintf(NAobj,'Display:WINDow1:TRACe1:Y:Scale:AUTO')
 
%Take and display S32 into window 2

fprintf(NAobj,'DISPlay:WINDow2:TRACe2:FEED "MeasS32"')
%autoscale
fprintf(NAobj,'Display:WINDow2:TRACe2:Y:Scale:AUTO')
 
fprintf(NAobj,'DISPlay:WINDow3:TRACe3:FEED "MeasS21"')
%autoscale
fprintf(NAobj,'Display:WINDow3:TRACe3:Y:Scale:AUTO')

%set IF bandwidth--- to go after scaling or it is screwy
fprintf(NAobj,['SENSe:BANDwidth ', num2str(IFbandInHZ), ' '])
%set frequency sweep

%%%%%%% turn screen off
fprintf(NAobj,'DISP:ENABLE OFF');

%%triggering
%turn off continuous sweep and wait for trigger signal
  fprintf(NAobj,'INIT:CONT OFF')

%set number of poinst to sweep
fprintf(NAobj,['SENS:SWE:POIN ', num2str(numSweepPoints), ' '])

%Set trigger to manual, and only trigger active channel
fprintf(NAobj, 'TRIG:SOUR MAN');
fprintf(NAobj, 'TRIG:SCOP CURR');

  %do test trigger
 fprintf(NAobj,'INIT:IMM')

%Set output format as ASCII
fprintf(NAobj, 'FORMAT:DATA ASCII,0');



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

freqs = eval(['[' fscanf(NAobj, '%c', inputBufSize) ']']);

end

