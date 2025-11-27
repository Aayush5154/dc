clc;
clear;
close;

A = 1;                 // amplitude
Rb = 100;              // bit rate
Tb = 1/Rb;             // bit duration

// Frequency axis
fmax = 1000;
f = -fmax:1:fmax;

// sinc term
sinc_term = sin(%pi*f*Tb) ./ (%pi*f*Tb);
sinc_term(f == 0) = 1;      // avoid division by zero

// PSD of Unipolar NRZ
PSD = (A^2 * Tb / 4) * (sinc_term.^2);

// Plot PSD
plot(f, PSD);
title("PSD of Unipolar NRZ");
xlabel("Frequency (Hz)");
ylabel("PSD");
xgrid();

// DC spike at f = 0
hold("on");
delta_height = max(PSD)*1.2;
plot([0 0], [0 delta_height], "r--");
hold("off");
