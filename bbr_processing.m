%
% Felipe Anon Da Silva & Erin Wiles 
% Wireless Lab, Montana Tech EE Dept., June 2015
%
% This program processes the power signal [dBm] from a bbr recording
% 1. Load Data
%   A. bbr recording
%   B. BB60C Signal Hound harmonics & FLT201A/N FM notch
% 2. Process Signal
%   Remove harmonics, then fm filtering from each frame of recording
% 3. Optional - graph each step of processing
%       (un)comment where appropriate
%
% See Environment Settings for Spike Capture Settings.
% Our frequencies span from 20MHz to 1GHz with 401408 frequency bins
% Therefore every frequency/power variables must have same dimension

clear;clc;close all;

% Load parsed bbr file (use bbr_parser.m) 
load('parsed_bbr.mat');

% Load BB60C Harmonics & FM Filter Data
load('processing_data.mat');

% Convert Current Recording from Log to Linear 
linear_power_signal=power_vec./10;
linear_power_signal=10.^linear_power_signal;

% Remove Harmonics from each frame
power_no_harmonic=linear_power_signal;
for i=1:num_frame-1
    power_no_harmonic(i,harmonic_idx)=linear_power_signal(i,harmonic_idx)-linear_power_harmonic;
end
clear linear_power_signal;
clear linear_power_harmonic;

% Convert from linear to Log
power_no_harmonic=-abs(10.*log10(power_no_harmonic));

% Reverse Filter Effects from each frame
power_unfilter=power_no_harmonic;
for i=1:num_frame-1
    power_unfilter(i,:)=power_no_harmonic(i,:)+power_filter;
end
power_processed=power_unfilter;
clear power_unfilter;
clear i;

% Important Variables
clear noise_floor;
clear span;
clear points_frame;

% Graphing Variables
% clear freq_vec;
% clear power_vec;
% clear freq_vec_dummy;
% clear power_vec_dummy;
% clear time_vec; 
% clear cmin;
% clear cmax;
% clear signal_threshold;
% clear tdiff;
% clear max_val_freq;
% clear num_frame;
% 
% clear power_filter;
% clear power_no_harmonic;
% clear harmonic_idx;
% clear harmonic_peak;

% 


figure(1)%  reality check - does this look right?
hold on;
plot(freq_vec,max_val_per_freq,'k');
plot(freq_vec_dummy,power_vec_dummy,'r:');
plot(freq_vec,-power_filter,'b:');
title(filename)
legend('Max Values in each Frequency Bin of Recording','BB60C with Dummy Load','FM Filter')
xlabel('Frequency [MHz]')
ylabel('Power [dBm]')

figure(2)
hold on;
plot(freq_vec_dummy,power_vec_dummy)
plot(freq_vec_dummy(harmonic_idx),harmonic_peak,'o');
xlabel('Frequency [MHz]')
ylabel('Power [dBm]')
legend('Dummy Load Data','Identified BB60C Harmonic Peaks')

% 
 figure(3) 
hold on;
plot(freq_vec,max_val_per_freq,'k')
plot(freq_vec,max(power_no_harmonic,[],1),'m')
xlabel('Frequency [MHz]')
ylabel('Power [dBm]')
legend('Max. Values per Freq. bin','Harmonics Removed')
        
% % 
figure(4)
imagesc(freq_vec,time_vec/1000,power_processed)
%Color Mapping Scales
cmin=-90; %dBm 
cmax=-40;%dBm 
caxis([cmin,cmax])
xlabel('Frequency [MHz]')
ylabel('Time [sec]')
filename=filename(1:20);
title(sprintf('%s',filename))
colorbar()

figure(5)
vidObj=VideoWriter('signal');
%vidObj.FrameRate=1000/tdiff; %real time
vidObj.FrameRate=100/tdiff;% 10x slower

open(vidObj);
set(gcf,'Renderer','zbuffer');

frame=zeros(num_frame-1,1);
 for i=1:num_frame-1
     plot(freq_vec,power_processed(i,:))
     axis([0 1000 -100 0])
     xlabel('Frequency [MHz]')
     ylabel('Power [dBm]')
     title(filename)
     frame=getframe(gcf);
     writeVideo(vidObj,frame);
 end
 
close(vidObj);

%Used video & index to find desired stills
idx=round(.333*num_frame);

figure(7)
plot(freq_vec,power_processed(56,:))
axis([0 1000 -100 0])
xlabel('Frequency [MHz]')
ylabel('Power [dBm]')
title(filename)
     
figure(8)
plot(freq_vec,power_processed(25,:))
axis([0 1000 -100 0])
xlabel('Frequency [MHz]')
ylabel('Power [dBm]')
title(filename)


