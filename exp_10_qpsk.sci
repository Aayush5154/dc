clc; clear; close;

bits = [1 0 1 1 0 1 0 0];
N = length(bits)/2;

Fs = 1000;
Tb = 0.05;     // smaller bit duration
Ts = 2*Tb;
fc = 500;      // higher carrier frequency

samples = Fs * Ts;

t = 0:1/Fs:(N*Ts - 1/Fs);
// fc = 50;

I = zeros(1,N);
Q = zeros(1,N);

idx = 1;
for k = 1:2:length(bits)
    b1 = bits(k);
    b2 = bits(k+1);

    if b1==0 & b2==0 then
        I(idx) = -1;  Q(idx) = -1;
    elseif b1==0 & b2==1 then
        I(idx) = -1;  Q(idx) =  1;
    elseif b1==1 & b2==1 then
        I(idx) =  1;  Q(idx) =  1;
    elseif b1==1 & b2==0 then
        I(idx) =  1;  Q(idx) = -1;
    end

    idx = idx + 1;
end

I_sig = zeros(1, N*samples);
Q_sig = zeros(1, N*samples);

idx = 1;
for i = 1:N
    I_sig(idx:idx+samples-1) = I(i);
    Q_sig(idx:idx+samples-1) = Q(i);
    idx = idx + samples;
end

carrier_cos = cos(2*%pi*fc*t);
carrier_sin = sin(2*%pi*fc*t);

qpsk = I_sig .* carrier_cos - Q_sig .* carrier_sin;

rec_I = zeros(1,N);
rec_Q = zeros(1,N);

idx = 1;
for i = 1:N
    segment = qpsk(idx:idx+samples-1);
    ref_cos = carrier_cos(idx:idx+samples-1);
    ref_sin = carrier_sin(idx:idx+samples-1);

    prod_I = segment .* ref_cos;
    prod_Q = -segment .* ref_sin;

    avg_I = sum(abs(prod_I)) / samples;
    avg_Q = sum(abs(prod_Q)) / samples;

    if prod_I(1) > 0 then
        rec_I(i) = 1;
    else
        rec_I(i) = 0;
    end

    if prod_Q(1) > 0 then
        rec_Q(i) = 1;
    else
        rec_Q(i) = 0;
    end

    idx = idx + samples;
end

rec_bits = [];
for i = 1:N
    if rec_I(i)==0 & rec_Q(i)==0 then
        rec_bits = [rec_bits 0 0];
    elseif rec_I(i)==0 & rec_Q(i)==1 then
        rec_bits = [rec_bits 0 1];
    elseif rec_I(i)==1 & rec_Q(i)==1 then
        rec_bits = [rec_bits 1 1];
    elseif rec_I(i)==1 & rec_Q(i)==0 then
        rec_bits = [rec_bits 1 0];
    end
end

disp("Sent Bits:     " + string(bits));
disp("Received Bits: " + string(rec_bits));

subplot(4,1,1);
plot(I_sig); title("I Signal"); xgrid();

subplot(4,1,2);
plot(Q_sig); title("Q Signal"); xgrid();

subplot(4,1,3);
plot(t, qpsk); title("QPSK Signal"); xgrid();

subplot(4,1,4);
plot(rec_I); title("Recovered I Bits"); xgrid();
