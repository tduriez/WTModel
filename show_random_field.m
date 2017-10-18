function show_random_field();
    [x,y]=meshgrid(-10:0.1:10);
    x0=-1;
    y0=2;
    Wind=[3,0];
    
    parameters.wake=x*0+1;
    parameters.x=x;
    parameters.y=y;
    alpha=0;
    [Pout,wake_attenuation]=WTmodel(x0,y0,alpha,Wind,parameters);
    
    Pout
    surf(x,y,wake_attenuation);shading interp;view(0,90)