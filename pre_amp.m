function [LNA_pam103]=pre_amp(freq_vec,cal_8753E)
% This function reads in a csv file with 2 columns:
% freq_vec [MHz] & power_vec [dBm]
% 1. Corrects the Network Analyzer (HP 8753E) calibration 
% 2. Interpolates the data according to our resolution & span

% Load FM Filter Transfer Function (Spectrum Analyzer HP 8753E )
% We can't (yet) access saved data on HP 8753E
pre_amp=csvread('C:PAM_103.csv',1);

% freq_vec
freq_points=pre_amp(:,1);%MHz

% Calibrate HP 8753E Data - We don't know how to calibrate machine
power_points=pre_amp(:,2)-cal_8753E;%dBm

clear pre_amp;

% Linear Interpolation of Pre-amp Data
%LNA_pam103=interp1(freq_points,power_points,freq_vec);

% Cubic Spline Interpolation of Pre-amp Data
LNA_pam103=spline(freq_points,power_points,freq_vec);

figure(3)
hold on;
plot(freq_points,power_points,'ko')
plot(freq_vec,LNA_pam103)
title('Transfer Function of COM-Power Pre-Amp PAM-103')
xlabel('Frequency [MHz]')
ylabel('Power [dBm]')
legend('Raw Data','Cubic Spline Interpolation')


