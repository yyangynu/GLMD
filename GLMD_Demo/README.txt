Global and Local Mixture Distance based (GLMD) Non-rigid Point Set Matching Matlab package (version 1.0)
	       Copyright (C) 2012, Yang Yang


This package provides Matlab code with matching examples for  Global and Local Mixture Distance based (GLMD) algorithm.


1) INSTALLATION
Step 1. Launch the GLMD_Demo.m file in Matlab.
Step 2. Single click the screen of GLMD_Demo by mouse left button, you will see the information about compiling lap.cpp code which is a solver for the linear assignment problem.
Step 3. Please click the "OK" botton for closing Matlab. 
Step 4. Restart Matlab and launch the GLMD_Demo.m again.
Step 5. Single click the screen of GLMD_Demo by mouse left button for starting the Demo. 

* The initial deformation of each target point set is randomly set in each program launch. Thus you can repeat this demo for observing more examples on different deformation. Moreover, you can also change the source code for noise, outliers and rotation Demo in GLMD_Demo.m. 
   

2) EXAMPLES
Please see many examples in the 'examples' directory for the details.
To change an example, please find the following code in GLMD_Demo.m and change "fish.mat".

Mpoints=load('examples\fish.mat'); % you can change to 'line','fish','fu','bird','Maple','hand','face' and 'face3D'.

3) MATLAB VERSION
These codes were developed in MATLAB R2010b.
IF you have any trouble on this Demo application, please contact me by yang01@nus.edu.sg. 
-----------------------------------------------------------------------
This document was last modified on : Aug. 27th, 2012.
