function [freq_vec,harmonic_idx,bb60c_harmonic_lin]=bb60c_harmonics
% Load Harmonic csv file from Spike Software
% Use export button in Traced Measurement
% Type -Average, Avg. Count - 100, Update box checked
% Assumption: harmonics are constant, while the noise floor varies.

bb60C_dummy=[];
bb60C_dummy=csvread('C:bb60C_harmonics_ave_100.csv');
freq_vec=(bb60C_dummy(:,1))'; %MHz
% 2 blocks of power measurment, if avg. setting col2=col3
power_vec(1,:)=bb60C_dummy(:,3); %dBm
clear bb60C_dummy;

% Find BB60C Harmonics - Determine Signal Threshold of BB60C
% based on figure 1
noise_floor=-100;%dBm
signal_threshold=-95;%dBm
harmonic_idx=find(power_vec > signal_threshold);
harmonic_peak=power_vec(harmonic_idx);%dBm

figure(1)
hold on;
plot(freq_vec,power_vec,'k')
plot(freq_vec(harmonic_idx),harmonic_peak,'o');
xlabel('Frequency [MHz]')
ylabel('Power [dBm]')
legend('Dummy Load Data','Harmonic Peaks')
title('Harmonics of BB60C Signal Hound with 50 Ohm Terminating Load')

%  Convert harmonic peaks from logrhithmic to linear
bb60c_harmonics=harmonic_peak./10;
clear harmonic_peak;
clear power_vec_dummy;

bb60c_harmonic_lin=10.^bb60c_harmonics;