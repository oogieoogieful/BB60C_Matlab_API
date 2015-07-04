%
% Felipe Anon Da Silva, Erin Wiles & Bryce Hill
% Wireless Lab, Montana Tech EE Dept., June 2015
%
% Use this script in conjunction with test_api.m
% Save workspace as a .mat file then load in test_api.m
% 
% These frequencies span from 20MHz to 1GHz with 401408 frequency bins
% Accordingly every power measuremet or calculation has dimension
% 1. Harmonics of BB60C Signal Hound with Dummy Load (-20 dB attenuator)
%    a. load 'raw' harmonic data (.csv)
%    b. find harmonics peaks
%    c. convert harmonic peak power to linear
% 2. Transfer function of FLT201A/N FM Notch filter [dBm]
clear;clc;close all;

% Load Harmonic csv file from Spike Software
% Use export button in Traced Measurement
% Type -Average, Avg. Count - 100, Update box checked
% Assumption: harmonics are constant, while the noise floor varies. 
bb60C_dummy=csvread('C:bb60C_harmonics_ave_100.csv');
freq_vec_dummy=(bb60C_dummy(:,1))'; %MHz
% 2 blocks of power measurment, if avg. setting col2=col3
power_vec_dummy(1,:)=bb60C_dummy(:,3); %dBm
clear bb60C_dummy;

% Find BB60C Harmonics - Determine Signal Threshold of BB60C
% based on figure 1
noise_floor=-100;%dBm
signal_threshold=-95;%dBm
harmonic_idx=find(power_vec_dummy > signal_threshold);
harmonic_peak=power_vec_dummy(harmonic_idx);%dBm

figure(1)
hold on;
plot(freq_vec_dummy,power_vec_dummy,'k')
plot(freq_vec_dummy(harmonic_idx),harmonic_peak,'o');
xlabel('Frequency [MHz]')
ylabel('Power [dBm]')
legend('Dummy Load Data','Harmonic Peaks')
title('Harmonics of BB60C Signal Hound with 50 Ohm Terminating Load')

%  Convert harmonic peaks from logrhithmic to linear
bb60c_harmonics=harmonic_peak./10;
clear harmonic_peak;
clear power_vec_dummy;

bb60c_harmonics=10.^bb60c_harmonics;

% Transfer Function of FM filter, see fm_filter()
% fm_filter() returns interpolated, calibrated & positive
% transfer function [dBm] of filter
[FLT201_fm_filter]=fm_filter(freq_vec_dummy);
clear freq_vec_dummy;
clear noise_floor;
clear signal_threshold;
