clc; clear; close;

bits = [1 0 1 1 0 0 1];
N = length(bits);

Fs = 1000;
Tb = 1;
samples = Fs * Tb;

t = 0:1/Fs:(N*Tb - 1/Fs);
fc = 50;

baseband = zeros(1, N*samples);
idx = 1;

for i = 1:N
    baseband(idx:idx+samples-1) = bits(i);
    idx = idx + samples;
end

bpsk = zeros(1, N*samples);
idx = 1;

for i = 1:N
    if bits(i) == 1 then
        bpsk(idx:idx+samples-1) = sin(2*%pi*fc*t(idx:idx+samples-1));
    else
        bpsk(idx:idx+samples-1) = -sin(2*%pi*fc*t(idx:idx+samples-1));
    end
    idx = idx + samples;
end

received = zeros(1, N);
idx = 1;

for i = 1:N
    segment = bpsk(idx:idx+samples-1);
    ref     = sin(2*%pi*fc*t(idx:idx+samples-1));
    prod = segment .* ref;

    if prod(1) > 0 then
        received(i) = 1;
    else
        received(i) = 0;
    end

    idx = idx + samples;
end

disp("Sent Bits:      " + string(bits));
disp("Received Bits:  " + string(received));

subplot(3,1,1);
plot(t, baseband);
title("Baseband NRZ Signal");
xlabel("Time"); ylabel("Amplitude"); xgrid();

subplot(3,1,2);
plot(t, bpsk);
title("BPSK Modulated Signal");
xlabel("Time"); ylabel("Amplitude"); xgrid();

subplot(3,1,3);
plot(1:N, received);
title("Recovered Bits");
xlabel("Bit Index"); ylabel("Bit Value"); xgrid();
