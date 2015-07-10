function [combilog_AC_220]=antenna(freq_vec,cal_8753E)
% This function reads in a csv file with 2 columns:
% freq_vec [MHz] & power_vec [dBm]
% 1. Corrects the Network Analyzer (HP 8753E) calibration 
% 2. Interpolates the data according to our resolution & span

% Load FM Filter Transfer Function (Spectrum Analyzer HP 8753E )
% We can't (yet) access saved data on HP 8753E
combilog=csvread('C:combilog_AC220.csv',1);

% freq_vec
freq_points=combilog(:,1);%MHz

% Calibrate HP 8753E Data - We don't know how to calibrate machine
power_points=combilog(:,2)-cal_8753E;%dBm

clear pre_amp;

% Linear Interpolation of Pre-amp Data
combilog_AC_220=interp1(freq_points,power_points,freq_vec);

% Cubic Spline Interpolation of Pre-amp Data
% combilog_AC_220=spline(freq_points,power_points,freq_vec);

figure(4)
hold on;
plot(freq_points,power_points,'ko')
plot(freq_vec,combilog_AC_220)
title('Transfer Function of COM-Power Combilog AC-220 Antenna')
xlabel('Frequency [MHz]')
ylabel('Power [dBm]')
legend('Raw Data','Linear Interpolation')


