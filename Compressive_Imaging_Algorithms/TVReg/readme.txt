****************************************************************
*                                                              *
*                 TVReg - a Matlab package for                 *
*                Total Variation Reconstruction                *
*                                                              *
*             Requires Matlab version 7.5 or later             *
*                                                              *
****************************************************************

This package includes Matlab and C codes for Total Variation (TV)
reconstruction.

If you use this package, please give reference to:

   T. L. Jensen, J. H. J�rgensen, P. C. Hansen and S. H. Jensen
   Implementation of an Optimal First-Order Method for Strongly 
   Convex Total Variation Regularization (submitted)

The code is part of the project CSI: Computational Science in
Imaging, supported by the Danish Research Council for Technology
and Production Sciences. The work was carried out at Aalborg
University and Technical University of Denmark.


Installation guide for Windows
------------------------------

1. Go to the directory where you keep your other Matlab toolboxes,
   and unzip the TVReg.zip files to a new folder TVReg.

5. Start Matlab and go to the above TVReg folder.  

6. Run "install_windows". If asked, select the Lcc-win32 compiler
   bundled with Matlab as compiler. If you have used another compiler
   previous, and compilation with this fails, try run "mbuild -setup" 
   and select the Lcc-win32 compiler.

7. Add TVReg to Matlab's path: go to File -> Set Path -> Add Folder
   and choose the folder where TVReg is located.  Then save and close.
   Alternatively, you can use the addpath command in Matlab.

8. To learn more, try the demos:
      tvreg_demo1, tvreg_demo2.

This installation is tested with the Lcc compiler bundled with Matlab.
More options are available in install_windows.m.


Installation guide for Linux and Unix
-------------------------------------

1. Go to the directory where you keep your other Matlab toolboxes, and
   unzip the TVReg.zip files to a new directory TVReg.

3. Start Matlab and go to the above TVReg directory.

4. Run "install_linux". Our experience is that when installing TVReg,
   you can ignore any warnings deriving from an officially unsupported
   version of gcc. For 64bit, use "install_linux64".

5. Add TVReg to Matlab's path: go to File -> Set Path -> Add Folder and
   choose the folder where TVReg is located. Then save and close.
   Alternatively, you can use the addpath command in Matlab.  

6. To learn more, try the demos:
      tvreg_demo1, tvreg_demo2.



Installation guide for Mac 
-------------------------------------

1. Download xcode from http://developer.apple.com/technologies/tools/xcode.html 
   and follow installation instructions. 
 
2. Go to the directory where you keep your other Matlab toolboxes, and 
   unzip the TVReg.zip files to a new directory TVReg. 
 
4. Start Matlab and go to the above TVReg directory. 
 
5. Run "install_linux". Our experience is that when installing TVReg, 
   you can ignore any warnings deriving from an officially unsupported 
   version of gcc. For 64bit, use "install_linux64". 
 
6. Add TVReg to Matlab's path: go to File -> Set Path -> Add Folder and 
   choose the folder where TVReg is located. Then save and close. 
   Alternatively, you can use the addpath command in Matlab.   
 
7. To learn more, try the demos: 
      tvreg_demo1, tvreg_demo2.

If you have any problems on Windows, Linux, Mac or Unix, please check the
files install_windows.m, install_linux.m and install_linux64.m
