clc; clear; close;

///////////////////////////////////////////////////////////////////////////////
// PART 1: NATURAL SAMPLING
///////////////////////////////////////////////////////////////////////////////

f_msg1 = 50;              // Message freq (natural sampling)
f_samp1 = 1000;           // Sampling freq
fs1 = 10000;              // Simulation sampling freq
t1 = 0:1/fs1:0.1;         // Time duration

msg1  = sin(2*%pi*f_msg1*t1);        // Message 
sine_samp1 = sin(2*%pi*f_samp1*t1);  // Sampling sinusoid
samp1 = double(sine_samp1 > 0);      // Convert to square wave
sampled1 = msg1 .* samp1;           // Natural Sampling

///////////////////////////////////////////////////////////////////////////////
// PART 2: IMPULSE SAMPLING
///////////////////////////////////////////////////////////////////////////////

f_msg2 = 1;           // Message freq (impulse sampling)
f_samp2 = 50;         // Sampling pulses
fs2 = 1000;           
t2 = 0:1/fs2:1;       

msg2 = sin(2*%pi*f_msg2*t2);

// Impulse train generator
imp_samp2 = zeros(t2);
Ts2 = round(fs2/f_samp2);

for i = 1:Ts2:length(t2)
    imp_samp2(i) = 1;
end

sampled2 = msg2 .* imp_samp2;

///////////////////////////////////////////////////////////////////////////////
// PLOTTING BOTH METHODS
///////////////////////////////////////////////////////////////////////////////

subplot(3,2,1)
plot(t1, msg1, 'Linewidth', 2);
title("Natural Sampling: Message"); 
xlabel("Time"); ylabel("Amp");
a=gca(); a.font_size=4;

subplot(3,2,2)
plot(t2, msg2, 'Linewidth', 2);
title("Impulse Sampling: Message");
xlabel("Time"); ylabel("Amp");
a=gca(); a.font_size=4;

subplot(3,2,3)
plot(t1, samp1, 'Linewidth', 2);
title("Natural Sampling: Sampling Train");
xlabel("Time"); ylabel("Amp");
a=gca(); a.font_size=4;

subplot(3,2,4)
plot(t2, imp_samp2, 'Linewidth', 2);
title("Impulse Sampling: Impulse Train");
xlabel("Time"); ylabel("Amp");
a=gca(); a.font_size=4;

subplot(3,2,5)
plot(t1, sampled1, 'Linewidth', 2);
title("Natural Sampled Signal");
xlabel("Time"); ylabel("Amp");
a=gca(); a.font_size=4;

subplot(3,2,6)
plot(t2, sampled2, 'Linewidth', 2);
title("Impulse Sampled Signal");
xlabel("Time"); ylabel("Amp");
a=gca(); a.font_size=4;
