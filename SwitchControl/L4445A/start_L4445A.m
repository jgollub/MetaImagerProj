%this initialized the L4445A Switch Controller using Ethernet connection
%10-9-2013 Jonah 

function  [vobj] = start_L4445A

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
    
    
    if strcmp(inst(1:5),'TCPIP')
        obj = visa('agilent',  inst);
        fopen(obj);
        fprintf(obj,'*IDN?');
        idn = fscanf(obj);
        fclose(obj);
        if strcmp(idn(1:end-1),'Agilent Technologies,L4445A,MY53150156,2.43-2.43-0.00-0.00')
            vobj = obj;
        else
            delete(obj)
        end
    end
    
end


if isempty(vobj)
    error('Instrument agilent L4445A Switch driver does not exist');
end

fopen(vobj);