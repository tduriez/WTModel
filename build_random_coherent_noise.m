function y=build_random_coherent_noise(t,deltaf,amp_spec,graphics)
    if nargin<3
        amp_spec=1;
    else
        if isempty(amp_spec)
            amp_spec=1;
        end
    end
    if nargin<4
        graphics=0;
    end
    dt=mean(diff(t));
    ti=t;
    lti=length(t);
    t=(t(1)-0.1*(t(end)-t(1)):dt:t(end));
    nfft=2^nextpow2(6*length(t));
    freqs=[-nfft/2:nfft/2]/nfft*1/dt;
    ft=rand(size(freqs)).*exp(-(freqs.*freqs)/deltaf^2);
    ft(1)=0;
    y=real(ifft(fftshift(ft),nfft));
    y=y(length(t)-lti+1:length(t));
    
    [class,values]=hist(y,length(y));
    c=cumsum(class)/sum(class);
    threshold=1/100;
    [~,i0]=min(abs(c-threshold/2));
    [~,i1]=min(abs(c-(1-threshold/2)));
    amp0=(abs(values(i0))+abs(values(i1)))/2;
    
    
    y=y/amp0*amp_spec;
    
    if graphics
    subplot(3,1,1)
    plot(freqs,ft);
    subplot(3,1,2)
    plot(ti,y)
    subplot(3,1,3)
    hist(y,1000)
    end
    
    