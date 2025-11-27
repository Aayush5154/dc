clear;clc;close;
N=100000;SNR_dB=0:2:14;num_SNR=length(SNR_dB);
BER_simulated=zeros(1,num_SNR);BER_theoretical=zeros(1,num_SNR);
disp('=== BPSK BER Simulation ===');disp(msprintf('Number of bits: %d',N));disp('Simulating...');
for idx=1:num_SNR
    snr=SNR_dB(idx);
    data=rand(1,N)>0.5;
    tx_signal=2*data-1;
    signal_power=mean(tx_signal.^2);
    noise_power=signal_power/(10^(snr/10));
    noise=sqrt(noise_power)*rand(1,N,'normal');
    rx_signal=tx_signal+noise;
    rx_data=rx_signal>0;
    errors=sum(data~=rx_data);
    BER_simulated(idx)=errors/N;
    BER_theoretical(idx)=0.5*erfc(sqrt(10^(snr/10)));
    disp(msprintf('SNR=%2d dB: Simulated BER=%.6f, Theoretical BER=%.6f',snr,BER_simulated(idx),BER_theoretical(idx)));
end

scf(1);clf;
semilogy(SNR_dB,BER_theoretical,'r-','LineWidth',2);
semilogy(SNR_dB,BER_simulated,'bo-','LineWidth',2,'MarkerSize',8);
xgrid();xlabel('SNR (dB)','fontsize',3);ylabel('Bit Error Rate','fontsize',3);
title('BPSK BER Performance in AWGN Channel','fontsize',4);
legend(['Theoretical BER';'Simulated BER'],'in_upper_right');
a=gca();a.log_flags="nly";

scf(2);clf;
SNR_display=[0,6,10];N_display=1000;
for idx=1:3
    snr_val=SNR_display(idx);
    data_disp=rand(1,N_display)>0.5;
    tx_disp=2*data_disp-1;
    sig_pow=mean(tx_disp.^2);
    noi_pow=sig_pow/(10^(snr_val/10));
    noise_disp=sqrt(noi_pow)*rand(1,N_display,'normal');
    rx_disp=tx_disp+noise_disp;

    subplot(2,3,idx);
    plot(tx_disp,zeros(1,N_display),'ro','MarkerSize',12,'LineWidth',3);
    xgrid();title('BPSK (No Noise)','fontsize',2);
    xlabel('In-Phase','fontsize',2);ylabel('Quadrature','fontsize',2);
    a=gca();a.data_bounds=[-2,-0.5;2,0.5];

    subplot(2,3,idx+3);
    plot(rx_disp,zeros(1,N_display),'b.','MarkerSize',4);
    plot([-1,1],[0,0],'ro','MarkerSize',12,'LineWidth',3);
    plot([0,0],[-0.5,0.5],'k--','LineWidth',2);
    xgrid();title(msprintf('BPSK (SNR=%d dB)',snr_val),'fontsize',2);
    xlabel('In-Phase','fontsize',2);ylabel('Quadrature','fontsize',2);
    legend(['Received';'Ideal';'Threshold'],'in_upper_right');
    a=gca();a.data_bounds=[-2,-0.5;2,0.5];
end

disp(' ');disp('=== Simulation Complete ===');
disp(msprintf('Total bits transmitted: %d',N));
disp(msprintf('SNR range: %d to %d dB',min(SNR_D_B),max(SNR_D_B)));

scf(3);clf;
SNR_eye=10;N_eye=5000;samples_per_bit=10;
data_eye=rand(1,N_eye)>0.5;
tx_eye=2*data_eye-1;
tx_upsampled=[];
for i=1:N_eye
    tx_upsampled=[tx_upsampled,tx_eye(i)*ones(1,samples_per_bit)];
end

sig_pow_eye=mean(tx_upsampled.^2);
noi_pow_eye=sig_pow_eye/(10^(SNR_eye/10));
noise_eye=sqrt(noi_pow_eye)*rand(1,length(tx_upsampled),'normal');
rx_upsampled=tx_upsampled+noise_eye;

num_traces=floor(length(rx_upsampled)/(2*samples_per_bit));
for i=1:num_traces
    start_idx=(i-1)*2*samples_per_bit+1;
    end_idx=min(start_idx+2*samples_per_bit-1,length(rx_upsampled));
    if end_idx-start_idx+1==2*samples_per_bit then
        segment=rx_upsampled(start_idx:end_idx);
        plot(1:length(segment),segment,'b-','LineWidth',0.5);
    end
end

xgrid();xlabel('Sample Index','fontsize',3);ylabel('Amplitude','fontsize',3);
title(msprintf('BPSK Eye Diagram (SNR=%d dB)',SNR_eye),'fontsize',4);
