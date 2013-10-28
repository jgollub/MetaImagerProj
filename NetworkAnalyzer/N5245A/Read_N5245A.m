function [data] = Read_N5245A(PNAX_obj, inputBufSize, s31orS32) %Assumes NAobj is already opened


 %select channel to sweep
 fprintf(PNAX_obj,['CALCulate:PARameter:SELect "', s31orS32,'" '])
 
%trigger
fprintf(PNAX_obj,'INIT:IMM')

%check that all pending operations are complete
operationscomplete = false;
while ~operationscomplete
    operationscomplete = query(PNAX_obj,'*OPC?');
end
 
fprintf(PNAX_obj, 'CALC:FORMAT REAL');
fprintf(PNAX_obj, 'CALC:DATA? FDATA');

%[real num] = query(PNAX_obj, ['CALC:DATA:SNP? ', 1]);

Sreal = eval(['[' fscanf(PNAX_obj,'%c', inputBufSize) ']']);

fprintf(PNAX_obj, 'CALC:FORMAT IMAG');
fprintf(PNAX_obj, 'CALC:DATA? FDATA');

Simag = eval(['[' fscanf(PNAX_obj,'%c', inputBufSize) ']']);

operationscomplete = false;
while ~operationscomplete
    operationscomplete = query(PNAX_obj,'*OPC?');
end

data = Sreal + (Simag.*1i);

%fclose(PNAX_obj); %THIS NEEDS TO COME AT THE END OF SOMETHING, OR DO BY HAND.