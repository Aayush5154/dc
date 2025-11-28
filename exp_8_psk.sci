clc; clear; close;

bits = [1 0 1 1 0 0 1];
N = length(bits);

samples = 200;
Tb = 1;
Fs = samples / Tb;
total_samples = N * samples;

t = 0:1/Fs:(total_samples-1)/Fs;

baseband = zeros(1, total_samples);
idx = 1;

for i = 1:N
    baseband(idx : idx + samples - 1) = bits(i);
    idx = idx + samples;
end

f1 = 50;
f0 = 20;

fsk = zeros(1, total_samples);
idx = 1;

for i = 1:N
    if bits(i) == 1 then
        fsk(idx:idx+samples-1) = sin(2 * %pi * f1 * t(idx:idx+samples-1));
    else
        fsk(idx:idx+samples-1) = sin(2 * %pi * f0 * t(idx:idx+samples-1));
    end
    idx = idx + samples;
end

demod1 = zeros(1, N);
demod0 = zeros(1, N);

idx = 1;

for i = 1:N
    segment = fsk(idx:idx+samples-1);
    ref1 = sin(2*%pi*f1 * t(idx:idx+samples-1));
    ref0 = sin(2*%pi*f0 * t(idx:idx+samples-1));
    demod1(i) = sum(abs(segment .* ref1)) / samples;
    demod0(i) = sum(abs(segment .* ref0)) / samples;
    idx = idx + samples;
end

received = zeros(1, N);

for i = 1:N
    if demod1(i) > demod0(i) then
        received(i) = 1;
    else
        received(i) = 0;
    end
end

disp("Sent Bits:      " + string(bits));
disp("Received Bits:  " + string(received));

subplot(4,1,1);
plot(t, baseband);
title("Baseband NRZ Signal");
xlabel("Time"); ylabel("Amplitude"); xgrid();

subplot(4,1,2);
plot(t, fsk);
title("FSK Modulated Signal");
xlabel("Time"); ylabel("Amplitude"); xgrid();

subplot(4,1,3);
plot(1:N, demod1);
title("Detector Output for f1 (bit = 1)");
xlabel("Bit Index"); ylabel("Value"); xgrid();

subplot(4,1,4);
plot(1:N, demod0);
title("Detector Output for f0 (bit = 0)");
xlabel("Bit Index"); ylabel("Value"); xgrid();
