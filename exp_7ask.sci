clc; clear; close;

bits = [1 0 1 1 0 0 1];      // Input binary bits
N = length(bits);

samples = 200;               // Samples per bit (higher = smoother)
Tb = 1;                      // bit duration = 1s (for simplicity)
Fs = samples / Tb;           // sampling frequency
total_samples = N * samples;

t = 0:1/Fs:(total_samples-1)/Fs;  // Time vector

baseband = zeros(1, total_samples);
k = 1;
for i = 1:N
    baseband(k:k+samples-1) = bits(i);
    k = k + samples;
end

fc = 10;                                     // carrier frequency (Hz)
carrier = sin(2 * %pi * fc * t);


A1 = 1;                                      // Amplitude for bit 1
A0 = 0;                                      // Amplitude for bit 0
ask = (A1 * baseband + A0 * (1-baseband)) .* carrier;

rectified = abs(ask);                        // full-wave rectifier
window = ones(1, samples) / samples;         // Ideal LPF
demod = conv(rectified, window, "same");     // envelope detection

sample_points = samples/2 : samples : total_samples;   // mid-bit sampling
received_bits = demod(sample_points) > 0.4;             // threshold detect

disp("Sent Bits:    " + string(bits));
disp("Received Bits:" + string(received_bits));

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
title("Demodulated Envelope");
xlabel("Time"); ylabel("Amplitude"); xgrid();
