function [Pout,wind_mod,alpha,section]=WTmodel(i0,j0,ControlLaw,Wind,parameters)
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
if ~isempty(ControlLaw);
    alpha=ControlLaw(i0,j0,Wind,parameters);
else
    alpha=0;
end
Crossection=cos(thetaW-alpha);
Attenuation=parameters.wake(i0,j0);
Pout=rW*Crossection*Attenuation;

%% Wake attenuation calculation
% 3 zones model
% zone I in the center of the wake: 50% attenuation
% zone II 25% attenuation
% zone III 0% attenuation
%
% center of the wake is Wind direction + alpha/2

% Zone I calculation
[theta,rho]=cart2pol(parameters.x-parameters.x(i0,1),parameters.y-parameters.y(1,j0));
[sx,sy]=pol2cart([alpha+pi/2,alpha-pi/2],[1 1]);
section=[sx;sy]+[parameters.x(i0,1),parameters.x(i0,1);parameters.y(1,j0),parameters.y(1,j0)];

centerWakeTheta=(2*thetaW+alpha)/3;

angle_attn=exp(-(theta-centerWakeTheta).*(theta-centerWakeTheta)/(0.1));
wind_mod=1-(angle_attn.*exp(-rho.*rho/(rW*rW)/10)*0.75).*(rho>0);%+zoneII*.25;


