clc; clear; close;

bits = [1 0 1 1 0 0 1];
N = length(bits);

Fs = 1000;
Tb = 1;
samples = Fs * Tb;

t = 0:1/Fs:(N*Tb - 1/Fs);

// ----------------------------
// Baseband NRZ (ASK style)
// ----------------------------
baseband = zeros(1, N*samples);
idx = 1;

for i = 1:N
    baseband(idx : idx+samples-1) = bits(i);
    idx = idx + samples;
end

// ----------------------------
// FSK MODULATION
// ----------------------------
fc1 = 30;
fc0 = 70;

fsk = zeros(1, N*samples);
idx = 1;

for i = 1:N
    if bits(i) == 1 then
        fsk(idx : idx+samples-1) = sin(2*%pi*fc1*t(idx:idx+samples-1));
    else
        fsk(idx : idx+samples-1) = sin(2*%pi*fc0*t(idx:idx+samples-1));
    end
    idx = idx + samples;
end

// ----------------------------
// COHERENT DEMODULATION (loop-based)
// ----------------------------
d1 = zeros(1, N);
d0 = zeros(1, N);

idx = 1;

for i = 1:N
    segment = fsk(idx : idx+samples-1);

    ref1 = sin(2*%pi*fc1 * t(idx:idx+samples-1));
    ref0 = sin(2*%pi*fc0 * t(idx:idx+samples-1));

    d1(i) = sum(abs(segment .* ref1)) / samples;
    d0(i) = sum(abs(segment .* ref0)) / samples;

    idx = idx + samples;
end

rec_bits = zeros(1, N);

for i = 1:N
    if d1(i) > d0(i) then
        rec_bits(i) = 1;
    else
        rec_bits(i) = 0;
    end
end

disp("Sent Bits:     " + string(bits));
disp("Received Bits: " + string(rec_bits));

// ----------------------------
// PLOTS
// ----------------------------
subplot(4,1,1);
plot(t, baseband);
title("Baseband NRZ Signal");
xlabel("Time"); ylabel("Amplitude"); xgrid();

subplot(4,1,2);
plot(t, fsk);
title("FSK Modulated Signal");
xlabel("Time"); ylabel("Amplitude"); xgrid();

subplot(4,1,3);
plot(1:N, d1);
title("Detector Output for fc1 (Bit = 1)");
xlabel("Bit Index"); ylabel("Value"); xgrid();

subplot(4,1,4);
plot(1:N, d0);
title("Detector Output for fc0 (Bit = 0)");
xlabel("Bit Index"); ylabel("Value"); xgrid();
