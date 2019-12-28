%==========================================================================
% Rotate Source Point-set
% -------------------------------------------------------------------------
% Copyright (C) 2012 Yang Yang, 
%                    Kelvin Weng Chiong Foong, 
%                    Sim Heng Ong
% 
% Contact Information:
% Yang Yang:		yang01@nus.edu.sg
%==========================================================================
function [Fpoints] = RotateObject(Fpoints,theta)
%Rotate Target Object
fx=mean(Fpoints(:,1));
fy=mean(Fpoints(:,2));
fz=mean(Fpoints(:,3));

rmatrix=[cosd(theta) -sind(theta);sind(theta) cosd(theta)];
NewOpoints=Fpoints-ones(size(Fpoints,1),1)*[fx fy fz];
NewOpoints(:,1:2)=(rmatrix*NewOpoints(:,1:2)')'+ones(size(Fpoints,1),1)*[fx fy];
Fpoints=NewOpoints;
end