clc; clear; close;

bits = [1 0 1 1 0 0 1];
N = length(bits);

Fs = 1000;          // Samples per second
Tb = 1;             // Bit duration
samples = Fs*Tb;    // Samples per bit
t = 0:1/Fs:(N*Tb - 1/Fs);

fc1 = 30;           // Frequency for bit = 1
fc0 = 70;           // Frequency for bit = 0

baseband = zeros(1, N*samples);
idx = 1;

for i = 1:N
    baseband(idx : idx+samples-1) = bits(i);
    idx = idx + samples;
end


fsk = zeros(1, N*samples);
idx = 1;

for i = 1:N
    if bits(i) == 1 then
        fsk(idx : idx+samples-1) = sin(2*%pi*fc1*t(idx : idx+samples-1));
    else
        fsk(idx : idx+samples-1) = sin(2*%pi*fc0*t(idx : idx+samples-1));
    end
    idx = idx + samples;
end

// --------------------------------------------------
// COHERENT DEMODULATION
// --------------------------------------------------
lo1 = sin(2*%pi*fc1*t);    // detector for bit=1
lo0 = sin(2*%pi*fc0*t);    // detector for bit=0

d1 = fsk .* lo1;           // multiply with fc1
d0 = fsk .* lo0;           // multiply with fc0

window = ones(1, 50)/50;
d1_filt = conv(d1, window, "same");
d0_filt = conv(d0, window, "same");

// decision rule
rec_bits = d1_filt > d0_filt;

subplot(4,1,1);
plot(t, baseband);
title("Baseband NRZ Signal");
xlabel("Time"); ylabel("Amplitude"); xgrid();

subplot(4,1,2);
plot(t, fsk);
title("FSK Modulated Signal");
xlabel("Time"); ylabel("Amplitude"); xgrid();

subplot(4,1,3);
plot(t, d1_filt);
title("Detector Output for fc1 (Bit = 1)");
xlabel("Time"); ylabel("Amplitude"); xgrid();

subplot(4,1,4);
plot(t, d0_filt);
title("Detector Output for fc0 (Bit = 0)");
xlabel("Time"); ylabel("Amplitude"); xgrid();
