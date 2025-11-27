clc; clear; close;
n = -10:10;
delta = (n == 0);

figure();
stem(n, delta);
title("Unit Impulse Signal δ[n]");
xlabel("n"); ylabel("Amplitude");

u = (n >= 0);

figure();
stem(n, u);
title("Unit Step Signal u[n]");
xlabel("n"); ylabel("Amplitude");

n2 = 0:20;
r = n2;

figure();
plot(n2, r);
title("Ramp Signal r[n]");
xlabel("n"); ylabel("Amplitude");

t = 0:0.01:2*%pi;
x1 = sin(t);
x2 = cos(t);

figure();
plot(t, x1);
title("Sine Wave sin(t)");
xlabel("t"); ylabel("Amplitude");

figure();
plot(t, x2);
title("Cosine Wave cos(t)");
xlabel("t"); ylabel("Amplitude");
t2 = 0:0.1:10;
xe = exp(-0.5 * t2);

figure();
plot(t2, xe);
title("Exponential Signal e^{-0.5t}");
xlabel("t"); ylabel("Amplitude");

// -------------------------------------------------------------
// 6. DISCRETE EXPONENTIAL
// -------------------------------------------------------------
n3 = 0:15;
xd = 0.8 .^ n3;

figure();
stem(n3, xd);
title("Discrete Exponential (0.8^n)");
xlabel("n"); ylabel("Amplitude");

x_uni = rand(1, 1000);

figure();
histplot(20, x_uni);
title("Uniform Random Variable");

x_gauss = grand(1, 1000, "nor", 0, 1);

figure();
histplot(20, x_gauss);
title("Gaussian Random Variable (mean=0, var=1)");

x_bin = grand(1, 1000, "bin", 10, 0.5);

figure();
histplot(20, x_bin);
title("Binomial Random Variable (n=10, p=0.5)");

x_poi = grand(1, 1000, "poi", 5);

figure();
histplot(20, x_poi);
title("Poisson Random Variable (lambda = 5)");

white_noise = rand(1, 500);

figure();
plot(white_noise);
title("White Noise");
xlabel("Samples");

gauss_noise = grand(1, 500, "nor", 0, 1);

figure();
plot(gauss_noise);
title("Gaussian Noise");
xlabel("Samples");
