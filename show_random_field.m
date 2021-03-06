function [J,P]=show_random_field(N,WindForce,geometry,figs)
warning('off', 'MATLAB:handle_graphics:Canvas:RenderingException');

if nargin<1
    N=9;
end


if nargin<2
    WindForce=3;
end


if nargin<3
    geometry='square';
end

if nargin<4
    figs=0;
end

[y,x]=meshgrid(-10:0.1:10,-10:0.1:30);

if N==1
    geometry='square';
end

switch geometry
    case 'square'
        n=ceil(sqrt(N));
        [x0,y0]=meshgrid(linspace(-5,5,n));
        y0=y0(1:N);
        x0=x0(1:N);
        i0=zeros(size(x0));
        j0=zeros(size(y0));
        for i=1:N
            [~,k]=min(abs(x(:,1)-x0(i)));
            [~,l]=min(abs(y(1,:)-y0(i)));
            i0(i)=k;
            j0(i)=l;
        end
        
    case 'square_intertwined'
        n=ceil(sqrt(N));
        [x0,y0]=meshgrid(linspace(-5,5,n));
        idx=1:size(x0,1);
        idx=find(mod(idx,2));
        dy=diff(y0(1:2,1));
        y0(:,idx)=y0(:,idx)-dy/2;
        y0=y0+dy/2;
        
        
        
        y0=y0(1:N);
        x0=x0(1:N);
        i0=zeros(size(x0));
        j0=zeros(size(y0));
        for i=1:N
            [~,k]=min(abs(x(:,1)-x0(i)));
            [~,l]=min(abs(y(1,:)-y0(i)));
            i0(i)=k;
            j0(i)=l;
        end
        
        
        
end




t=0:0.01:1;


Wind_angle=build_random_coherent_noise(t,10,5/180*pi);
Wind_force=abs(WindForce+build_random_coherent_noise(t,20,WindForce*0.1));


[xWind,yWind]=pol2cart(Wind_angle,Wind_force);
Wind=[xWind; yWind];
parameters.x=x;
parameters.y=y;

FlowField.U=

P=zeros(length(t),N);


%ControlLaw=@(i0,j0,Wind,parameters)(cart2pol(Wind(1),Wind(2)));
ControlLaw=[];
%ControlLaw=@(i0,j0,Wind,parameters)(rand-0.5);

for it=1:length(t)
    parameters.wake=x*0+1;
    
    [~,wind_mod]=WTmodel(i0(1),j0(1),ControlLaw,Wind(:,it),parameters);
    for i=2:N
        [~,wake_attenuation]=WTmodel(i0(i),j0(i),ControlLaw,Wind(:,it),parameters);
        wind_mod=wind_mod.*wake_attenuation;
    end
    
    
    
    wind_mod(wind_mod>1)=1;
    wind_mod(wind_mod<0)=0;
    parameters.wake=wind_mod;
    sec=[];
    for i=1:N
        [Pout,~,~,section]=WTmodel(i0(i),j0(i),ControlLaw,Wind(:,it),parameters);
        P(it,i)=Pout;
        sec=[sec,[NaN;NaN],section];
    end
    J=sum(trapz(t,P));
    if figs
        subplot(3,1,[1 2])
        %surf(x,y,x*0,parameters.wake);shading interp;view(0,90);hold on
        contourf(x,y,parameters.wake,[0 0.25 .5 .75 1]);hold on
        plot(x(i0,1),y(1,j0),'ok','markerfacecolor','w')
        plot(sec(1,:),sec(2,:),'k');
        hold off
        set(gca,'clim',[0 1]);
        if it==1
            
            colormap('default');
            g=colormap;
            g=g(ceil([0 0.25 0.5 0.75 1]*(size(g,1)-1))+1,:);
            colormap(g)
        end
        c=colorbar;
        set(c,'Ticks',[0 .25 .5 .75 1],'TickLabels',{'0%','25%','50%','75%','100%'});
        
        subplot(3,1,3)
        plot(t(1:it),P(1:it,:));
        set(gca,'xlim',[t(1) t(end)]);
        
        drawnow
    end
end

