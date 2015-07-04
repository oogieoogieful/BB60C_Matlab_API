function [power_filter]=fm_filter(freq_vec)
% This function reads in a csv file with 2 columns:
% freq_vec [MHz] & power_vec [dBm]
% 1. Corrects the Network Analyzer (HP 8753E) calibration 
% 2. Interpolates the data according to our resolution & span
% 3. Reverses the sign of power_vec 
%    - We're adding back the filtered FM band

% Load FM Filter Transfer Function (Spectrum Analyzer HP 8753E )
fm_filter=csvread('C:FLT201_fm_filter.csv',1);
freq_points=fm_filter(:,1);%MHz

% Calibrate HP 8753E Data - We don't know how to calibrate machine
% Additionally, we can't (yet) access saved data on HP 8753E
cal_8753E=fm_filter(1,2); %dBm  
power_points=fm_filter(:,2)-cal_8753E;%dBm

clear cal_8753E;
clear fm_filter;

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

clear freq_points;
clear power_points;

% Reverse Attenuation of FM Filter
power_filter=abs(power_vec);
