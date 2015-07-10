function [fm_filter,cal_8753E]=fm_filter(freq_vec,cal_8753E)
% This function reads in a csv file with 2 columns:
% freq_vec [MHz] & power_vec [dBm]
% 1. Corrects the Network Analyzer (HP 8753E) calibration 
% 2. Interpolates the data according to our resolution & span
% 3. Reverses the sign of power_vec (because the filter is a Loss) 


% Load FM Filter Transfer Function (Spectrum Analyzer HP 8753E )
% We can't (yet) access saved data on HP 8753E
fm_filter=csvread('C:FLT201_fm_filter.csv',1);

% freq_vec
freq_points=fm_filter(:,1);%MHz

% Calibrate HP 8753E Data - We don't know how to calibrate machine
cal_8753E=fm_filter(1,2); %dBm
power_points=fm_filter(:,2)-cal_8753E;%dBm

clear notch_filter;

% Linear Interpolation of FM Filter Data
power_vec=interp1(freq_points,power_points,freq_vec);

figure(2)
hold on;
plot(freq_points,power_points,'ko')
plot(freq_vec,power_vec)
title('Transfer Function of FLT201A/N FM Notch filter')
xlabel('Frequency [MHz]')
ylabel('Power [dBm]')
legend('Raw Data','Linear Interpolation')

% Reverse Attenuation of FM Filter
fm_filter=abs(power_vec);
