clc; clear;

// ---------------- PARAMETERS ----------------
M = 256;               // M-QAM (must be a perfect square)
SNR_dB = 20;          // AWGN SNR

k = sqrt(M);
if k ~= round(k) then
    error("M must be a perfect square (4,16,64,256...)");
end

// ---------------- GENERATE CONSTELLATION POINTS ----------------
levels = -(k-1):2:(k-1);   // amplitude levels, e.g., [-3 -1 1 3] for 16-QAM

I_vals = zeros(1,M);
Q_vals = zeros(1,M);

index = 1;
for i = 1:k
    for j = 1:k
        I_vals(index) = levels(i);
        Q_vals(index) = levels(j);
        index = index + 1;
    end
end

// Normalize average power to 1
norm_factor = sqrt(mean(I_vals.^2 + Q_vals.^2));
I_vals = I_vals / norm_factor;
Q_vals = Q_vals / norm_factor;

// ---------------- ADD AWGN ----------------
noise_std = sqrt(0.5 / (10^(SNR_dB/10)));
I_noisy = I_vals + noise_std * rand(1,M,"normal");
Q_noisy = Q_vals + noise_std * rand(1,M,"normal");

// ---------------- PLOTTING ----------------
clf;
x_axis = linspace(-1.5,1.5,200);

// --- Ideal Constellation ---
subplot(2,1,1);
plot(I_vals, Q_vals, 'bo');
title("M-QAM Constellation (Ideal, M="+string(M)+")");
xlabel("In-phase (I)");
ylabel("Quadrature (Q)");
xgrid();
gca().data_bounds = [-1.5 -1.5; 1.5 1.5];
gca().isoview = "on";

// Draw axes
plot(x_axis, 0*x_axis,'k-');  // horizontal
plot(0*x_axis, x_axis,'k-');  // vertical

// --- Noisy Constellation ---
subplot(2,1,2);
plot(I_noisy, Q_noisy, 'rx');
title("M-QAM Constellation with AWGN (SNR="+string(SNR_dB)+" dB)");
xlabel("In-phase (I)");
ylabel("Quadrature (Q)");
xgrid();
gca().data_bounds = [-1.5 -1.5; 1.5 1.5];
gca().isoview = "on";

// Draw axes
plot(x_axis, 0*x_axis,'k-');  // horizontal
plot(0*x_axis, x_axis,'k-');  // vertical
