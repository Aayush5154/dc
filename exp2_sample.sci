// chatgpt chat -> https://chatgpt.com/share/6918dc57-c88c-8003-b08c-cfd06536c079
clc;
clear;
close;

// --------------------------------------
// PARAMETERS
// --------------------------------------
Fs = 1000;                 // High simulation frequency
t = 0:1/Fs:0.01;           // Time vector (10 ms) and 1/fs is 1ms 
fm = 50;                   // Message frequency

// Continuous message signal
m = sin(2*%pi*fm*t);
//  yaha tak ka part sine wave create karega bas 

// --------------------------------------
// IMPULSE SAMPLING
// --------------------------------------
Fsamp = 200;               // Sampling frequency
Ts = 1/Fsamp;              // Sampling period
n = 0:Ts:0.01;             // Sampling instants Ts = 5ms 
impulse_sample = sin(2*%pi*fm*n); //value of the signal at each sampling instant (like impulses)

// --------------------------------------
// NATURAL SAMPLING
// --------------------------------------
pulse_width = 0.3*Ts;      // 30% duty cycle
p = zeros(t);              // Pulse train

for i = 1:length(t)
    if modulo(t(i), Ts) <= pulse_width then
        p(i) = 1;
    else
        p(i) = 0;
    end
end // creating the 30% duty cycle pulse 

natural_sample = m .* p;

// --------------------------------------
// PLOTTING
// --------------------------------------

subplot(3,1,1);
plot(t, m);
title("Message Signal (Continuous)");
xlabel("Time (s)");
ylabel("Amplitude");

// -------- Impulse sampling using plot2d3 --------
subplot(3,1,2);
plot2d3(n, impulse_sample);     // Equivalent to MATLAB stem()
title("Impulse Sampling");
xlabel("Time (s)");
ylabel("Amplitude");

// -------- Natural sampling --------
subplot(3,1,3);
plot(t, natural_sample);
title("Natural Sampling");
xlabel("Time (s)");
ylabel("Amplitude");
