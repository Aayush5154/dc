        clc;
clear;
close;


Nb = 1000;         
n = 50;            
fc = 10*%pi;     
t = linspace(0,1,n);


data = round(rand(1,Nb));


PSK = [];
for i = 1:Nb
    if data(i) == 1 then
        PSK = [PSK sin(fc*t)];
    else
        PSK = [PSK sin(fc*t + %pi)];
    end
end


SNR_dB = 0:2:20;
BER = zeros(1,length(SNR_dB));

for k = 1:length(SNR_dB)
    snr_linear = 10^(SNR_dB(k)/10);
    

    noise = rand(1,length(PSK)) - 0.5;
    noise = noise * sqrt(variance(PSK)/(snr_linear*variance(noise)));
    
    r = PSK + noise;
    

    received = zeros(1,Nb);
    for i = 1:Nb
        sample = r((i-1)*n + n/2);
        if sample >= 0 then
            received(i) = 1;
        end
    end
    
    BER(k) = sum(data <> received)/Nb;
end


BER(BER==0) = 1e-6;


figure(0);
semilogy(SNR_dB, BER, '-o','LineWidth',2);
xtitle('BER vs SNR for BPSK','SNR (dB)','Bit Error Rate');
xgrid();
