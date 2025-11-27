clc; clear; close;
bits = [1 0 1 1 0 0 1];
N = length(bits);
Fs = 1000;          // Sampling frequency
Tb = 1;             // Bit duration
t = 0:1/Fs:(N*Tb - 1/Fs);
fc1 = 30;            // For bit = 1
fc0 = 70;            // For bit = 0
fsk = [];
for i = 1:N
    tt = 0:1/Fs:(Tb - 1/Fs);
    if bits(i) == 1 then
        fsk = [fsk, sin(2*%pi*fc1*tt)];
    else
        fsk = [fsk, sin(2*%pi*fc0*tt)];
    end
end
lo1 = sin(2*%pi*fc1*t);   // Local oscillator for bit = 1
lo0 = sin(2*%pi*fc0*t);   // Local oscillator for bit = 0
d1 = fsk .* lo1;          // Multiply with fc1
d0 = fsk .* lo0;          // Multiply with fc0
window = ones(1, 50)/50;
d1_filt = conv(d1, window, "same");
d0_filt = conv(d0, window, "same");
rec_bits = d1_filt > d0_filt;
subplot(4,1,1);plot2d2(0:N-1, bits);   // FIXED: replaced stairs()title("Input Bit Sequence");xgrid();
subplot(4,1,2);plot(t, fsk);title("FSK Modulated Signal"); xgrid();
subplot(4,1,3);plot(t, d1_filt);title("Demodulator Output (fc1 → bit 1)"); xgrid();
subplot(4,1,4);plot(t, d0_filt);title("Demodulator Output (fc0 → bit 0)"); xgrid();
