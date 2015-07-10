%
% Felipe Anon Da Silva, Erin Wiles & Bryce Hill
% Wireless Lab, Montana Tech EE Dept., June 2015
%
% Use this script in conjunction with test_api.m
% Save workspace as a .mat file then load in test_api.m
% 
% These frequencies span from 20MHz to 1GHz with 401408 frequency bins
% Accordingly every power measuremet or calculation has same dimension
% 1. Harmonics of BB60C Signal Hound with Dummy Load (-20 dB attenuator)
%    a. load 'raw' harmonic data (.csv)
%    b. find harmonics peaks
%    c. convert harmonic peak power to linear
% 2. Transfer function of FLT201A/N FM Notch filter [dBm]
% 3. Transfer function of LNA, Com-Power Pre-Amp PAM-103
% 4. Transfer function of antenna, Com-Power Combilog AC-220 
clear;clc;close all;

% bb60c_harmonics returns linear peaks of BB60C Signal Hound Harmonic
% and their indices (i.e. frequency locations)
[freq_vec,harmonic_idx,bb60c_harmonic_lin]=bb60c_harmonics;

% Transfer Function of FM filter
% fm_filter() returns interpolated, calibrated & positive
% transfer function [dBm] of filter
% Furthermore we use measurments from the fm_filter transfer function to 
% "calibrate" the data from the Network Analyzer, HP 8753E 
cal_8753E=0;
[FLT201_fm_filter,cal_8753E]=fm_filter(freq_vec,cal_8753E);

% Transfer function of LNA
% pre_amp() returns interpolated, calibrated transfer function [dBm] 
% of pre-amplifier
[LNA_pam103]=pre_amp(freq_vec,cal_8753E);

% Transfer function of Antenna Directivity
% antenna_direc() returns interpolated, calibrated transfer function [dBi] 
% of Com-Power Combi-log AC-220 Antenna
[combilog_AC_220]=antenna(freq_vec,cal_8753E);
 
clear cal_8753E;
clear freq_vec;
clear noise_floor;
clear signal_threshold;
