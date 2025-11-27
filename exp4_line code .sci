clc;
clear;
clf;

A = 1;          // amplitude
Rb = 100;       // bit rate
Tb = 1/Rb;      // bit duration
// Frequency axis
fmax = 1000;
f = -fmax:1:fmax;

sinc_term = sin(%pi * f * Tb) ./ (%pi * f * Tb);
sinc_term(f == 0) = 1;   // Fix for division by zero
PSD = (A^2 * Tb / 4) * (sinc_term.^2);

plot(f, PSD, "LineWidth", 3);
xlabel("Frequency (Hz)");
ylabel("PSD");
title(" PSD of Unipolar NRZ");
xgrid();
a=gca(); a.font_size = 3;

set(gca(), "auto_clear", "off");
delta_height = max(PSD) * 1.2;
plot([0 0], [0 delta_height], "r--", "LineWidth", 3);
set(gca(), "auto_clear", "on");
legend(["PSD", "Delta spike at f=0"], "in_upper_right");
