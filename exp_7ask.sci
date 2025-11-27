clc; clear; close;
bits = [1 0 1 1 0 0 1];
N = length(bits);
Fs = 1000;
Tb = 1;
t = 0:1/Fs:(N*Tb - 1/Fs);   // FIXED time vector
fc = 50;
baseband = [];
for i = 1:N
    baseband = [baseband, bits(i)*ones(1, Fs*Tb)];
end
carrier = sin(2*%pi*fc*t);
ask = baseband .* carrier;
rectified = abs(ask);
window = ones(1, 50)/50;
demod = conv(rectified, window, 'same');
threshold = 0.4;
received_bits = demod > threshold;
subplot(4,1,1);
plot(t, baseband);
title("Input NRZ Signal"); xgrid();
subplot(4,1,2);plot(t, carrier);title("Carrier Signal"); xgrid();
subplot(4,1,3);plot(t, ask);title("ASK Modulated Signal"); xgrid();
subplot(4,1,4);plot(t, demod);title("Demodulated Signal"); xgrid();
