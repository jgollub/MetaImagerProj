function [ output_args ] = Deactivate_RFpath_L4445A( obj, switchNum)

%switching on a new path on a switch automatically turns off previous path,
%but if you send a command to another switches this does not change the original 
%switch back to all open---the last closed path remains so.

if sum(switchNum(:))>1
    error('more than one switch selected');
end
%build SCPI commands to control switches
switch switchNum
    case 1
        switchCommand=['(@1107)'];
    case 2
        switchCommand=['(@1117)'];
    case 3
        switchCommand=['(@1127)'];
    case 4
        switchCommand=['(@1137)'];
    case 5
        switchCommand=['(@1147)'];
    case 6
        switchCommand=['(@1157)'];
    case 7
        switchCommand=['(@1167)'];
    case 8
        switchCommand=['(@1177)'];
    case 9
        switchCommand=['(@1207)'];
    case 10
        switchCommand=['(@1217)'];
    case 11
        switchCommand=['(@1227)'];
    case 12
        switchCommand=['(@1237)'];
end

fprintf(obj,['ROUT:CLOS ', switchCommand])
query(obj,'*OPC?');
end

