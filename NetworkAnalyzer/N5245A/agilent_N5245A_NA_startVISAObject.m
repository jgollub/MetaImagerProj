function  [vobj] = agilent_N5245A_NA_startVISAObject

vinfo = instrhwinfo('visa','agilent');
agilent_insts = vinfo.ObjectConstructorName;

vobj = [];
for n = 1:size(agilent_insts)
    inst = char(agilent_insts(n));
    inst = inst(18:end-3);
    
    if strcmp(inst(1:4),'GPIB')
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