clc; clear; close;
bits = [1 0 1 1 0 0 1];     // Input bit sequence
N = length(bits);
samples = 100;              // Samples per bit
t = 0:1/samples:N;          // Time axis
input_sig = zeros(1, length(t));
idx = 1;
for i = 1:N
    input_sig(idx:idx+samples-1) = bits(i);
    idx = idx + samples;
end
bipolar = zeros(1, length(t));
level = 1;                  // Start with +1
idx = 1;
for i = 1:N
    if bits(i) == 1 then
        bipolar(idx:idx+samples-1) = level;
        level = -level;
    else
        bipolar(idx:idx+samples-1) = 0;
    end
    idx = idx + samples;
end
manchester = zeros(1, length(t));
idx = 1;
for i = 1:N
    if bits(i) == 1 then
        manchester(idx:idx+samples/2-1) = 1;
        manchester(idx+samples/2:idx+samples-1) = -1;
    else
        manchester(idx:idx+samples/2-1) = -1;
        manchester(idx+samples/2:idx+samples-1) = 1;
    end
    idx = idx + samples;
end
subplot(3,1,1);plot(t, input_sig);title("Input Bit Signal (NRZ-Unipolar View)");xlabel("Time"); ylabel("Bits");xgrid();
subplot(3,1,2);plot(t, bipolar);title("Bipolar (AMI) Line Coding");xlabel("Time"); ylabel("Amplitude");xgrid();
subplot(3,1,3);plot(t, manchester);title("Manchester Line Coding");xlabel("Time"); ylabel("Amplitude");
xgrid();
