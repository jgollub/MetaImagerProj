function  [vobj] = agilent_N5245A_NA_startVISAObject_TCPIP

vinfo = instrhwinfo('visa','agilent');
agilent_insts = vinfo.ObjectConstructorName;
objtest=instrfind('Status','open'); %check for open instruments

vobj = [];

for n = 1:size(agilent_insts,1)
    inst = char(agilent_insts(n));
    inst = inst(18:end-3);
    
    %exclude active instruments
    activeInstr=0;
    for i=1:length(objtest)
        activeInstr=activeInstr+ ~isempty(strfind(inst, objtest(i).RemoteHost));
    end
    
    %find instrument ID
    if strcmp(inst(1:5),'TCPIP') & activeInstr==0
        
        obj = visa('agilent',  inst);
        
        fopen(obj);
        fprintf(obj,'*IDN?');
        idn = fscanf(obj);
        fclose(obj);
        if strcmp(idn(1:end-1),'Agilent Technologies,N5245A,MY49151009,A.09.33.09')
            vobj = obj;
        else
            delete(obj)
        end
    end
    
end


if isempty(vobj)
    error('Instrument agilent N5245A VNA driver does not exist');
end

fopen(vobj);