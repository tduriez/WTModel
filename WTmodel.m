function [Pout,wake_attenuation]=WTmodel(x0,y0,alpha,Wind,parameters)
%WTmodel simulates the output of a single WT, in term of output Power and
%impact in the wake.
%
% alpha is the deviation angle from the optimal orthogonal cross-section
% Wind is a 2D cartesian vector.
%
%
% Copyright Thomas Duriez 2017

%% Pout calculation
% first order model Pout is proportional to feeled wind strength times the crosssection;
[thetaW,rW]=cart2pol(Wind(1),Wind(2));
Crossection=cos(alpha/180*pi);
Attenuation=griddata(parameters.x,parameters.y,parameters.wake,x0,y0);
Pout=rW*Crossection*Attenuation;

%% Wake attenuation calculation
% 3 zones model
% zone I in the center of the wake: 50% attenuation
% zone II 25% attenuation
% zone III 0% attenuation
%
% center of the wake is Wind direction + alpha/2

% Zone I calculation
[theta,rho]=cart2pol(parameters.x-x0,parameters.y-y0);
zoneI=((theta>thetaW+(alpha/180*pi)/2-10/180*pi) & (theta<thetaW+(alpha/180*pi)/2+10/180*pi)) & rho < 2;
zoneII=((theta>thetaW+(alpha/180*pi)/2-20/180*pi) & (theta<thetaW+(alpha/180*pi)/2+20/180*pi)) & rho < 5;
%keyboard
wake_attenuation=ones(size(parameters.x))-zoneI*.25-zoneII*.25;


