clc; clear; close;

bits = [1 0 1 1 0 0 1];     // Input bit sequence
N = length(bits);
samples = 100;              // Samples per bit
t = 0:1/samples:N;          // Time axis

input_sig = zeros(1, length(t));
idx = 1;

for i = 1:N
    input_sig(idx : idx+samples-1) = bits(i);
    idx = idx + samples;
end


nrz = zeros(1, length(t));
idx = 1;

for i = 1:N
    if bits(i) == 1 then
        nrz(idx : idx+samples-1) = 1;
    else
        nrz(idx : idx+samples-1) = -1;
    end
    idx = idx + samples;
end


rz = zeros(1, length(t));
half = samples/2;
idx = 1;

for i = 1:N
    if bits(i) == 1 then
        rz(idx : idx+half-1) = 1;     // first half
    else
        rz(idx : idx+half-1) = -1;    // first half
    end
    // second half automatically 0
    idx = idx + samples;
end


subplot(3,1,1);
plot(t, input_sig);
title("Input Bit Signal (Unipolar View)");
xlabel("Time"); ylabel("Bits"); xgrid();

subplot(3,1,2);
plot(t, nrz);
title("NRZ (Polar) Line Coding");
xlabel("Time"); ylabel("Amplitude"); xgrid();

subplot(3,1,3);
plot(t, rz);
title("RZ (Return to Zero) Line Coding");
xlabel("Time"); ylabel("Amplitude"); xgrid();
