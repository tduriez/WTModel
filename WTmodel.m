function [Pout,wind_mod,alpha,section]=WTmodel(i0,j0,ControlLaw,Wind,parameters)
%WTmodel simulates the output of a single WT, in term of output Power and
%impact in the wake.
%
% [Pout,wind_mod,alpha,section]=WTmodel(i0,j0,ControlLaw,Wind,parameters) 
%                i0 and j0 design the grid point to use.
%                ControlLaw is a handle to a control function @().
%
% Copyright Thomas Duriez 2017

if nargin==0
    [y,x]=meshgrid(-10:0.1:10,-10:0.1:30);
    parameters.x=x;
    parameters.y=y;
    i0=round(size(x,1)/4);
    j0=round(size(x,2)/2);
    ControlLaw=[];
    Wind=[5 0];
    parameters.wake=parameters.x*0+1;
    
    t=0:0.01:1;
        thetaW=build_random_coherent_noise(t,10,5/180*pi);
        rW=abs(10+build_random_coherent_noise(t,20,0.3));
else
    [thetaW,rW]=cart2pol(Wind(1),Wind(2));
end

nT=size(rW,2);

%% Pout calculation
% first order model Pout is proportional to feeled wind strength times the crosssection;

if ~isempty(ControlLaw)
    alpha=ControlLaw(thetaW,rW);
    alpha=max(alpha,-pi/2);
    alpha=min(alpha,pi/2);
    
    
else
    alpha=0;
end
Crossection=cos(thetaW-alpha);
Attenuation=squeeze(parameters.wake(i0,j0,:));
Pout=rW.*Crossection.*Attenuation;

%% Wake attenuation calculation


% Zone I calculation
[theta,rho]=cart2pol(parameters.x-parameters.x(i0,1),parameters.y-parameters.y(1,j0));
[sx,sy]=pol2cart([alpha+pi/2,alpha-pi/2],[1 1]);
section=[sx;sy]+[parameters.x(i0,1),parameters.x(i0,1);parameters.y(1,j0),parameters.y(1,j0)];

centerWakeTheta=repmat(permute((2*thetaW+alpha)/3,[1 3 2]),[size(theta) 1]);

theta=repmat(theta,[1 1 nT]);
rho=repmat(rho,[1 1 nT]);
rW=repmat(permute(rW,[1 3 2]),[size(theta) 1]);

angle_attn1=exp(-(theta-centerWakeTheta).*(theta-centerWakeTheta)/(0.01));
angle_attn2=exp(-(theta-centerWakeTheta).*(theta-centerWakeTheta)/(1));

rho_attn1=exp(-rho.^2/(rW.^2)/100);
rho_attn2=exp(-rho.^2/(rW.^2)/1);

attn1=angle_attn1.*rho_attn1;
attn2=angle_attn2.*rho_attn2;
wind_mod=1-(attn1*0.25+attn2*0.50).*(rho>0);

if nargin==0
  
        surf(x,y,x*0,wind_mod);shading interp;view(0,90);hold on
        %contourf(x,y,wind_mod,[0 0.25 .5 .75 1]);hold on
        plot(x(i0,1),y(1,j0),'ok','markerfacecolor','w')
        plot(section(1,:),section(2,:),'k');
        hold off
       % set(gca,'clim',[0 1]);
        
            
%             colormap('default');
%             g=colormap;
%             g=g(ceil([0 0.25 0.5 0.75 1]*(size(g,1)-1))+1,:);
%             colormap(g)
        
        c=colorbar;
%         set(c,'Ticks',[0 .25 .5 .75 1],'TickLabels',{'0%','25%','50%','75%','100%'});
        
       
    
end

