clc; clear; close;

bits = [1 0 1 1 0 0 1];
N = length(bits);

Fs = 1000;          // Samples per second
Tb = 1;             // Bit duration
t = 0:1/Fs:(N*Tb - 1/Fs);

f1 = 50;            // Frequency for bit = 1
f0 = 20;            // Frequency for bit = 0

baseband = [];
for i = 1:N
    baseband = [baseband, bits(i)*ones(1, Fs*Tb)];
end

// --------------------------------------------------
// FSK MODULATION
// --------------------------------------------------
fsk = zeros(1, length(t));
idx = 1;

for i = 1:N
    if bits(i) == 1 then
        fsk(idx : idx+Fs*Tb-1) = sin(2*%pi*f1 * t(idx : idx+Fs*Tb-1));
    else
        fsk(idx : idx+Fs*Tb-1) = sin(2*%pi*f0 * t(idx : idx+Fs*Tb-1));
    end
    idx = idx + Fs*Tb;
end


demod1 = fsk .* sin(2*%pi*f1*t);   // detector for bit=1
demod0 = fsk .* sin(2*%pi*f0*t);   // detector for bit=0

window = ones(1, 50)/50;
rec1 = conv(demod1, window, "same");
rec0 = conv(demod0, window, "same");

// Decision: bit = 1 if rec1 > rec0
rec_bits = rec1 > rec0;

subplot(4,1,1);
plot(t, baseband);
title("Baseband NRZ Signal");
xlabel("Time"); ylabel("Amplitude"); xgrid();

subplot(4,1,2);
plot(t, fsk);
title("FSK Modulated Signal");
xlabel("Time"); ylabel("Amplitude"); xgrid();

subplot(4,1,3);
plot(t, rec1);
title("Detector Output for Frequency f1 (bit = 1)");
xlabel("Time"); ylabel("Amplitude"); xgrid();

subplot(4,1,4);
plot(t, rec0);
title("Detector Output for Frequency f0 (bit = 0)");
xlabel("Time"); ylabel("Amplitude"); xgrid();
