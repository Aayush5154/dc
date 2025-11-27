clc; clear; close;

bits = [1 0 1 1 0 0 1];
N = length(bits);

Fs = 1000;          // Samples per second
Tb = 1;             // Bit duration
samples = Fs*Tb;    // Samples per bit

t = 0:1/Fs:(N*Tb - 1/Fs);   // Time vector

baseband = zeros(1, N*samples);
idx = 1;

for i = 1:N
    baseband(idx : idx+samples-1) = bits(i);
    idx = idx + samples;
end

fc = 50;
carrier = sin(2*%pi*fc*t);

ask = baseband .* carrier;

rectified = abs(ask);

window = ones(1, 50) / 50;        // Simple LPF
demod = conv(rectified, window, 'same');

threshold = 0.4;
received_bits = demod > threshold;

subplot(4,1,1);
plot(t, baseband);
title("Baseband NRZ Signal");
xlabel("Time"); ylabel("Amplitude"); xgrid();

subplot(4,1,2);
plot(t, carrier);
title("Carrier Signal");
xlabel("Time"); ylabel("Amplitude"); xgrid();

subplot(4,1,3);
plot(t, ask);
title("ASK Modulated Signal");
xlabel("Time"); ylabel("Amplitude"); xgrid();

subplot(4,1,4);
plot(t, demod);
title("Demodulated Signal");
xlabel("Time"); ylabel("Amplitude"); xgrid();
