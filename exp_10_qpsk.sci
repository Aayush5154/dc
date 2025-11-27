clc; clear; close;
bits = [1 0  1 1  0 1  0 0];   // Even number of bits
N = length(bits)/2;
Fs = 1000; Tb = 1;         // Bit duration
Ts = 2*Tb;      // Symbol duration
t = 0:1/Fs:(N*Ts - 1/Fs); fc = 50;        // Carrier frequency
I = []; Q = [];
for k = 1:2:length(bits)
    b1 = bits(k);
    b2 = bits(k+1);
    if b1==0 & b2==0 then
        I = [I -1];Q = [Q -1];
    elseif b1==0 & b2==1 then
        I = [I -1]; Q = [Q +1];
    elseif b1==1 & b2==1 then
        I = [I +1]; Q = [Q +1];
    elseif b1==1 & b2==0 then
        I = [I +1];Q = [Q -1];
    end
end
I_sig = [];
Q_sig = [];
for i = 1:N
    I_sig = [I_sig, I(i)*ones(1, Fs*Ts)];
    Q_sig = [Q_sig, Q(i)*ones(1, Fs*Ts)];
end
carrier_cos = cos(2*%pi*fc*t);
carrier_sin = sin(2*%pi*fc*t);
qpsk = I_sig .* carrier_cos - Q_sig .* carrier_sin;
demod_I = qpsk .* carrier_cos;
demod_Q = -qpsk .* carrier_sin;
window = ones(1, 50)/50;
I_rec = conv(demod_I, window, "same");
Q_rec = conv(demod_Q, window, "same");
I_bits = I_rec > 0;
Q_bits = Q_rec > 0;
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
subplot(4,1,1);plot(I_sig);title("I (In-phase) Sequence"); xgrid();
subplot(4,1,2);plot(Q_sig);title("Q (Quadrature) Sequence"); xgrid();
subplot(4,1,3);plot(t, qpsk);title("QPSK Modulated Signal"); xgrid();
subplot(4,1,4);plot(I_rec);title("Demodulated I (after LPF)"); xgrid();
