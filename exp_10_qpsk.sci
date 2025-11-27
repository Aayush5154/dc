clc; clear; close;

bits = [1 0  1 1  0 1  0 0];   // Even number of bits
N = length(bits)/2;            // Number of QPSK symbols

Fs = 1000;         // Samples per second
Tb = 1;            // One bit duration
Ts = 2*Tb;         // One QPSK symbol = 2 bits
samples = Fs*Ts;   // samples per symbol

t = 0:1/Fs:(N*Ts - 1/Fs);
fc = 50;           // Carrier frequency

I = zeros(1,N);
Q = zeros(1,N);

idx = 1;
for k = 1:2:length(bits)
    b1 = bits(k);
    b2 = bits(k+1);

    if b1==0 & b2==0 then
        I(idx) = -1; Q(idx) = -1;
    elseif b1==0 & b2==1 then
        I(idx) = -1; Q(idx) = +1;
    elseif b1==1 & b2==1 then
        I(idx) = +1; Q(idx) = +1;
    elseif b1==1 & b2==0 then
        I(idx) = +1; Q(idx) = -1;
    end

    idx = idx + 1;
end

// ----------------------------------------------------------
// UPSAMPLE I AND Q (same style as your NRZ expansion)
// ----------------------------------------------------------
I_sig = zeros(1, N*samples);
Q_sig = zeros(1, N*samples);

idx = 1;
for i = 1:N
    I_sig(idx : idx+samples-1) = I(i);
    Q_sig(idx : idx+samples-1) = Q(i);
    idx = idx + samples;
end


carrier_cos = cos(2*%pi*fc*t);
carrier_sin = sin(2*%pi*fc*t);

qpsk = I_sig .* carrier_cos - Q_sig .* carrier_sin;


demod_I = qpsk .* carrier_cos;
demod_Q = -qpsk .* carrier_sin;

window = ones(1,50)/50;   // LPF (Moving avg)

I_rec = conv(demod_I, window, "same");
Q_rec = conv(demod_Q, window, "same");

I_bits = I_rec > 0;
Q_bits = Q_rec > 0;

// Combine into recovered bits
rec_bits = [];
for i = 1:N
    if I_bits(i)==0 & Q_bits(i)==0 then
        rec_bits = [rec_bits 0 0];
    elseif I_bits(i)==0 & Q_bits(i)==1 then
        rec_bits = [rec_bits 0 1];
    elseif I_bits(i)==1 & Q_bits(i)==1 then
        rec_bits = [rec_bits 1 1];
    elseif I_bits(i)==1 & Q_bits(i)==0 then
        rec_bits = [rec_bits 1 0];
    end
end

subplot(4,1,1);
plot(I_sig); title("I (In-phase) Sequence"); xgrid();

subplot(4,1,2);
plot(Q_sig); title("Q (Quadrature) Sequence"); xgrid();

subplot(4,1,3);
plot(t, qpsk); title("QPSK Modulated Signal"); xgrid();

subplot(4,1,4);
plot(I_rec); title("Demodulated I (after LPF)"); xgrid();
