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
    baseband(idx:idx+samples-1) = bits(i);
    idx = idx + samples;
end

fc = 10;
carrier = sin(2 * %pi * fc * t);

ask = baseband .* carrier;

demod = zeros(1, N);
idx = 1;
for i = 1:N
    segment = ask(idx:idx+samples-1);
    demod(i) = sum(abs(segment)) / samples;
    idx = idx + samples;
end

received_bits = zeros(1, N);
threshold = 0.4;

for i = 1:N
    if demod(i) > threshold then
        received_bits(i) = 1;
    else
        received_bits(i) = 0;
    end
end

disp("Sent Bits:    " + string(bits));
disp("Received Bits:" + string(received_bits));

subplot(4,1,1);
plot(t, baseband);
title("Baseband NRZ Signal");
xlabel("Time"); ylabel("Amp"); xgrid();

subplot(4,1,2);
plot(t, carrier);
title("Carrier Signal");
xlabel("Time"); ylabel("Amp"); xgrid();

subplot(4,1,3);
plot(t, ask);
title("ASK Modulated Signal");
xlabel("Time"); ylabel("Amp"); xgrid();

subplot(4,1,4);
plot(demod);
title("Demodulated Output");
xlabel("Bit index"); ylabel("Value"); xgrid();
