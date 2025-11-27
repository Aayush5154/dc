clc; clear; close;
bits = [1 0 1 1 0 0 1];
N = length(bits);
Fs = 1000;
Tb = 1;
t = 0:1/Fs:(N*Tb - 1/Fs);
fc = 50;    // Carrier frequency
nrz = 2*bits - 1;
baseband = [];
for i = 1:N
    baseband = [baseband, nrz(i)*ones(1, Fs*Tb)];
end
carrier = cos(2*%pi*fc*t);
bpsk = baseband .* carrier;
demod = bpsk .* carrier;
window = ones(1, 50)/50;
recovered = conv(demod, window, "same");
rec_bits = recovered > 0;
subplot(4,1,1);
plot(t, baseband);
title("NRZ Baseband Signal (1 → +1, 0 → -1)");
xlabel("Time"); ylabel("Amplitude"); xgrid();
subplot(4,1,2);plot(t, carrier);title("Carrier Signal");xlabel("Time"); ylabel("Amplitude"); xgrid();
subplot(4,1,3);plot(t, bpsk);title("BPSK Modulated Signal");xlabel("Time"); ylabel("Amplitude"); xgrid();
subplot(4,1,4);plot(t, recovered);title("Demodulated Signal");xlabel("Time"); ylabel("Amplitude"); xgrid();
