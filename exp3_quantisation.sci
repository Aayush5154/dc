clc;
clear;
close;

// ---------------------------------------
// PARAMETERS
// ---------------------------------------
Fs = 1000;                        // Sampling frequency
t = 0:1/Fs:0.01;                  // Time vector (10 ms)
fm = 50;                          // Message signal frequency

// Message signal
x = sin(2*%pi*fm*t);

// ---------------------------------------
// QUANTIZATION PARAMETERS
// ---------------------------------------
L = 16;                           // Number of quantization levels
xmin = min(x);                    // Minimum of signal
xmax = max(x);                    // Maximum of signal
delta = (xmax - xmin) / L;        // Step size (quantum)

// ---------------------------------------
// UNIFORM QUANTIZATION
// ---------------------------------------

// Find index of quantization level
q_index = floor((x - xmin) ./ delta); // lower value 

// Clamp the values to valid range (0 to L-1)
// manully fixing 
// Sometimes due to rounding, index may go below 0 or above maximum.
q_index(q_index < 0) = 0;
q_index(q_index > L-1) = L-1;

// Quantized (reconstructed) signal
xq = xmin + q_index * delta + delta/2;   // midpoint representation

// ---------------------------------------
// PLOTTING
// ---------------------------------------

subplot(3,1,1);
plot(t, x);
title("Original Signal");
xlabel("Time");
ylabel("Amplitude");

subplot(3,1,2);
plot2d3(t, xq);       // Shows levels visually (stem-like)
title("Quantized Signal (Uniform)");
xlabel("Time");
ylabel("Amplitude");

subplot(3,1,3); 
plot(t, x);
plot(t, xq, 'r');
title("Original vs Quantized");
xlabel("Time");
ylabel("Amplitude");
legend("Original", "Quantized");
