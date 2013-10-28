function [] = Activate_RFpath_L4445A(obj, switchNum, pathNum) %allow RF path to transmit through switchNum/PathNum
%Switch addresses
% if sum(switchNum(:))>1
%         error('more than one switch selected')
%         return
% end
    %build SCPI commands to control switches
    switch switchNum
        case 1
        switchCommand=['(@110',num2str(pathNum),')'];
        case 2
        switchCommand=['(@111',num2str(pathNum),')'];
        case 3
        switchCommand=['(@112',num2str(pathNum),')'];
        case 4
        switchCommand=['(@113',num2str(pathNum),')'];
        case 5
        switchCommand=['(@114',num2str(pathNum),')'];
        case 6
        switchCommand=['(@115',num2str(pathNum),')'];
        case 7
        switchCommand=['(@116',num2str(pathNum),')'];
        case 8
        switchCommand=['(@117',num2str(pathNum),')'];
        case 9
        switchCommand=['(@120',num2str(pathNum),')'];
        case 10
        switchCommand=['(@121',num2str(pathNum),')'];
        case 11
        switchCommand=['(@122',num2str(pathNum),')'];
        case 12
        switchCommand=['(@123',num2str(pathNum),')'];
    end
     
fprintf(obj,['ROUT:CLOS ', switchCommand])
query(obj,'*OPC?');
end

