% TVReg. 
% Version 0.8  31-08-09. 
% Copyright (c) 2010 by T.L. Jensen, J.H. Jorgensen, 
% P.C. Hansen and S.H. Jensen
%
% Requires Matlab version 7.5 or later versions.
%    
% These functions accompany the paper
%   Practical Implementation of Optimal First-Order Method
%   for Total Variation Regularization in Tomography
%
% Demonstration.
%   tvreg_demo1      - Demonstration for a tomography problem
%   tvreg_demo2      - Demonstrates for a deblurring problem
%   Pirate.tif     - Test image
%
% TV reconstruction functions.
%   tvreg_gpbb       - Uses a gradient projection algorithm with
%                    Borzilai-Borwein strategy
%   tvreg_upn        - Based on an optimal first-order method as
%                    as described by Yurii Nesterov with modification
%                    for unknown parameters.
% 
% Files from regtools by P.C. Hansen
%   regu/cgls  
%
% Files from tomobox by J.H. Jorgensen
%   tomobox/buildSystemMatrix - Setup system matrix for 3D parallel beam
%                               tomography
%   tomobox/getNoise          - Create white noise with specified relative
%                               noise level
%   tomobox/phantom3d         - Three-dimensional analogue of MATLAB
%                               Shepp-Logan phantom
%   tomobox/plotLayers        - Show the layers of 3D array in subplots
%   tomobpx/tomoboxDemo1      - Demo script for tomobox
%   tomobox/traceRays         - Determine voxels and path lengts for
%                               parallel rays (auxiliary function for 
%                               buildSystemMatrix)
%
% Files for choosing projection directions
%   lebdir/getLebedevDirections - Get unit vectors well spread
%                                            out over sphere
%   lebdir/getHalf              - Discard duplicate vectors
%                                            differing only by the sign
%                                            (auxiliary function for
%                                            getLebedevDirections)
%   lebdir/getLebedevSphere     - function to compute normalized
%                                            points and weights for Lebedev
%                                            quadratures on the surface of 
%                                            the unit sphere at double 
%                                            precision. (auxiliary function
%                                            for getLebedevDirections)
%
% Auxiliary files.
%   install_linux       - Installation script for Linux
%   install_windows     - Installation script for Windows
%   install_linux64     - Installation script for Linux 64bit
%
% Directories.
%   c         - The C functions for TV reconstruction
%   externlib - Contains the library file libut.lib
%   lebdir    - Contains files for computing the Lebedec directions used in
%               the tomography demo
%   regu      - Contains cgls
%   tomobox   - Contains the tomography simulation files