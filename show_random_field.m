function show_random_field();
    N=10;
    [x,y]=meshgrid(-10:0.1:10);
    x0=(rand(1,N)-0.5)*10;
    y0=(rand(1,N)-0.5)*10;
    Wind=[3,2];
    
    parameters.wake=x*0+1;
    parameters.x=x;
    parameters.y=y;
    alpha=(rand(1,N)-0.5)*20;
    global_wake_attn=parameters.wake*0;
    for i=1:N
    [~,wake_attenuation]=WTmodel(x0(i),y0(i),alpha(i),Wind,parameters);
    global_wake_attn=global_wake_attn+wake_attenuation;
    end
    global_wake_attn(global_wake_attn>1)=1;
    parameters.wake=1-global_wake_attn;
    
    
    
    surf(x,y,parameters.wake);shading interp;view(0,90)