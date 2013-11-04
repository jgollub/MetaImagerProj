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
        RoutingSwitch1='(@1251)';
        RoutingSwitch2='(@1241)';
        %RoutingSwitch
    case 2
        switchCommand=['(@111',num2str(pathNum),')'];
        RoutingSwitch1='(@1251)';
        RoutingSwitch2='(@1242)';  %will need to change when switch indexing changes
    case 3
        switchCommand=['(@112',num2str(pathNum),')'];
        RoutingSwitch1='(@1251)';
        RoutingSwitch2='(@1243)';  %will need to change when switch indexing changes
    case 4
        switchCommand=['(@113',num2str(pathNum),')'];
        RoutingSwitch1='(@1251)';
        RoutingSwitch2='(@1244)';
    case 5
        switchCommand=['(@114',num2str(pathNum),')'];
        RoutingSwitch1='(@1251)';
        RoutingSwitch2='(@1245)';
    case 6
        switchCommand=['(@115',num2str(pathNum),')'];
        RoutingSwitch1='(@1251)';
        RoutingSwitch2='(@1246)';  %will need to change when switch indexing changes
    case 7
        switchCommand=['(@116',num2str(pathNum),')'];
        RoutingSwitch1='(@1254)';
        RoutingSwitch2='(@1261)';  %will need to change when switch indexing changes
    case 8
        switchCommand=['(@117',num2str(pathNum),')'];
        RoutingSwitch1='(@1254)';
        RoutingSwitch2='(@1262)';
    case 9
        switchCommand=['(@120',num2str(pathNum),')'];
        RoutingSwitch1='(@1254)';
        RoutingSwitch2='(@1263)';
    case 10
        switchCommand=['(@121',num2str(pathNum),')'];
        RoutingSwitch1='(@1254)';
        RoutingSwitch2='(@1264)';  %will need to change when switch indexing changes
    case 11
        switchCommand=['(@122',num2str(pathNum),')'];
        RoutingSwitch1='(@1254)';
        RoutingSwitch2='(@1265)';  %will need to change when switch indexing changes
    case 12
        switchCommand=['(@123',num2str(pathNum),')'];
        RoutingSwitch1='(@1254)';
        RoutingSwitch2='(@1266)';
end

fprintf(obj,['ROUT:CLOS ', switchCommand]);
fprintf(obj,['ROUT:CLOS ', RoutingSwitch1]);
fprintf(obj,['ROUT:CLOS ', RoutingSwitch2]);
%check to see that command has been executed
while ~query(obj,'*OPC?');
    pause(.001)
end

end

