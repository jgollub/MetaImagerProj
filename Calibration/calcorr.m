% *******************************************************************************************************
% LIBRARY / HELPER FUNCTIONS
% **************************
% calibration correction for network analyser measurements
%
% references:
% [1] Michael Hiebel, "Grundlagen der Vektoriellen Netzwerkanalyse", 2nd edition (german),
%     Rohde&Schwarz, 2007 (ISBN 978-3-939837-05-3)
%
%
% ***** Behavior *****
% [cdata, mcond] = calcorr(data, cal, mode)
%    Applies the calibration correction defined by MODE to DATA using the references provided in CAL.
%
% ***** Interface definition *****
% function [cdata, mcond] = calcorr(data, cal, mode)
%    data    measurement data vector (to be corrected)
%    cal     calibration reference measurements (have to be aligned with DATA!)
%       .o      "open" reference
%       .s      "short" reference
%       .m      "match" reference
%       .t      "through" reference
%    mode   type of calibration {'full', 'norm-ms', 'norm-s', 'through', 'none'}
%              full: full 1-port calibration (open, short, match)
%              norm-ms: normalization to match and short
%              norm-s:  normalization to short
%              through: normalization to through
%
%    cdata   corrected DATA
%    mcond   matrix condition for full calibration; NaN otherwise
%
%
% ***** Author *****
% Daniel Arnitz
%   Signal Processing and Speech Communication Laboratory (SPSC)
%   Graz University of Technology (TU Graz), Austria
%   Reynolds Lab, Department of Electrical and Computer Engineering
%   Duke University, USA
%
%
% ***** Changelog *****
% alpha 1.0   2012-04-xx   extracted/modified from nxpanechoic_201005__tagreflection__analysis.m
%                          (TU Graz, SPSC / NXP, 2010)
%
% ***** Todo *****
% - support for non-ideal calibration references
%
% *******************************************************************************************************

function [cdata, mcond] = calcorr(data, cal, mode)
   cdata = nan(size(data));
   mcond = nan(size(data));
   switch(lower(mode))
      % full calibration
      case 'full'
         for i = 1 : length(data) % not vectorized to save memory
            % create correction data for each point in frequency
            corr   = pinv([1, 1, -cal.o(i); -1, 1, cal.s(i); 0, 1, 0]) * [cal.o(i); cal.s(i); cal.m(i)];
            mcond(i)  = cond([1, 1, -cal.o(i); -1, 1, cal.s(i); 0, 1, 0]);
            % apply to data
            cdata(i) = ( data(i) - corr(2) ) ./ ( corr(1) - corr(3) * data(i) );
         end
      % normalization to match and short
      case 'norm-ms'
         cdata = ( data -  cal.m ) ./ ( cal.s - cal.m );
      % normalization to short
      case 'norm-s'
         cdata = data ./ cal.s;
      % normalization to through
      case 'through'
         cdata = data ./ cal.t;
      % none at all
      case 'none'
         cdata = data;
      otherwise
         error('Unsupported calibration correction.');
   end
end

% full -calibration out of [1] to check the above calibration
%          %     references
%          Go =  1;
%          Gs = -1;
%          Gm =  0;
%          %     measurement of references
%          Mo = cal.o(i);
%          Ms = cal.s(i);
%          Mm = cal.m(i);
%          %     combine terms
%          e00 = Mm;
%          e10 = (Go-Gs) * (Mo-Mm) * (Ms-Mm) / ( Go * Gs * (Mo-Ms) );
%          e11 = ( Gs*(Mo-Mm) - Go*(Ms-Mm) ) / ( Go * Gs * (Mo-Ms) );
%          %     apply to data
%          cdata = ( data(:,i,j) - e00 ) / ( e10 + e11*(data(:,i,j)-e00) );
%          mcond = NaN;