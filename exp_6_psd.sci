clc; clear; close;
bits = [1 0 1 1 0 0 1];
N = length(bits);
samples = 200;              // samples per bit
Tb = 1;                     // ideal bit duration for plotting
t = 0:Tb/samples:N*Tb;      // time axis for practical waveform
input_t = [];
input_sig = [];
for i = 1:N
    t0 = (i-1)*Tb;
    t1 = i*Tb;
    input_t = [input_t, t0, t1];
    input_sig = [input_sig, bits(i), bits(i)];
end
ideal_t = [];ideal_sig = [];
for i = 1:N
    t0 = (i-1)*Tb;
    tm = t0 + Tb/2;
    t1 = i*Tb;
    if bits(i) == 1 then
        ideal_t  = [ideal_t, t0, tm, tm, t1];
        ideal_sig = [ideal_sig, 1, 1, -1, -1];
    else
        ideal_t  = [ideal_t, t0, tm, tm, t1];
        ideal_sig = [ideal_sig, -1, -1, 1, 1];
    end
end
practical = zeros(1, N*samples);
idx = 1;
for i = 1:N
    if bits(i) == 1 then
        practical(idx:idx+samples/2-1) = 1;
        practical(idx+samples/2:idx+samples-1) = -1;
    else
        practical(idx:idx+samples/2-1) = -1;
        practical(idx+samples/2:idx+samples-1) = 1;
    end
    idx = idx + samples;
end
subplot(3,1,1);plot(input_t, input_sig, 'LineWidth', 2);title("Input Bit Waveform (Ideal NRZ-Unipolar)");xlabel("Time"); ylabel("Bits");xgrid();
subplot(3,1,2);plot(ideal_t, ideal_sig, 'LineWidth', 2);title("Ideal Manchester Waveform");xlabel("Time"); ylabel("Amplitude");xgrid();
subplot(3,1,3);plot(t(1:length(practical)), practical);title("Practical Manchester Waveform (Sampled)");xlabel("Time"); ylabel("Amplitude");
xgrid();
