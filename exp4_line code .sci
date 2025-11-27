clc;clear;close;
bits = [1 0 1 1 0 0 1];
N = length(bits);
Tb = 1;                   // bit duration (seconds) 1 sec per bit 
Fs = 1000;                // samples per second
samples_per_bit = Fs * Tb;   // = 1000 samples/bit
nrz = zeros(1, N * samples_per_bit); // each bit is drawn using 1000 discrete time points. So the full waveform will have N * 1000 = 7000 samples.
idx = 1;
for i = 1:N
    if bits(i) == 1 then
        nrz(idx : idx+samples_per_bit-1) = 1;
    else
        nrz(idx : idx+samples_per_bit-1) = -1;
    end
    idx = idx + samples_per_bit;
end
half = samples_per_bit/2;
rz = zeros(1, N * samples_per_bit);
idx = 1;
for i = 1:N
    if bits(i) == 1 then
        rz(idx : idx+half-1) = 1;     // first half = +1
    else
        rz(idx : idx+half-1) = -1;    // first half = -1
    end
    idx = idx + samples_per_bit;
end
t = (0:(N*samples_per_bit-1)) / Fs;
bit_time = 0:N;
bit_values = [bits bits($)];
subplot(3,1,1);plot2d2(bit_time, bit_values);xtitle("Input Bits","Time (bits)","Bit Value");xgrid();
subplot(3,1,2);plot(t, nrz);xtitle("NRZ Line Code","Time (s)","Amplitude");xgrid();
subplot(3,1,3);plot(t, rz);xtitle("RZ Line Code","Time (s)","Amplitude");xgrid();
