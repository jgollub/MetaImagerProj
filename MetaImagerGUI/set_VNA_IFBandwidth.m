function []=set_VNA_IFBandwidth(NAobj,IFbandwidth)


%set IF bandwidth--- to go after scaling or it is screwy
fprintf(NAobj,['SENSe:BANDwidth ', num2str(IFbandwidth), ' '])