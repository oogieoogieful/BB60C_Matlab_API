function [message]=test_api
% We are creating nested-functions to configure sweep mode, fetch, process
% and compress power data from Signal Hound BB60C Spectrum Analyzer
% 	3.0 USB on 64-bit Window 7 computer
% 	86 BB API Version 3.0.4 (included with Spike 64 bit 3.0.8 download)
% 	32-bit Matlab
% 	Drivers CDM v2.12.00 WHQL Certified.exe
% Equipment: (See equipment_schematic.PNG on github)
% 	Com Power Combilog Antenna AC-220 25MHz - 2GHz
% 	FLT201A/N FM Notch Filter
% 	DC Power Block

close all;clear;clc;

% path to dll & lib
addpath('C:\Program Files\Signal Hound\Spike\api\bb_series\x86');
% path to header
addpath('C:\Program Files\Signal Hound\Spike\api\bb_series');

% Check if Library Loaded
if (libisloaded('bb_api' )== 0)
    loadlibrary('bb_api','bb_api.h')
end

% Open Device
devicePtr=libpointer('int32Ptr',0);% .Value is device number
%devicePtr.Value called in every API function
message(1,:)=calllib('bb_api','bbOpenDevice',devicePtr);

% Configure Settings - see function for rest of settings
center=double(510e6); %Hz
span=double(980e6); %Hz
config_sweep;

% Initialize Mode & (Re)-Calibrate BB60C device to current temp.
init_device;

% Query Trace - Frequency Bin Characteristics
traceLenPtr=libpointer('uint32Ptr',0); %
startPtr=libpointer('doublePtr',0);%
query_trace;

% Data Aquisition
sweep_num=1;% number of sweeps
time_stamps=zeros(sweep_num,6);
maxPtr=fetch_trace;

% Signal Processing - see processing_vars.m
FLT201_fm_filter=cell(1,traceLenPtr.Value);% dBm
harmonic_idx=cell(1,78);
bb60c_harmonics=cell(1,78);%mW
load('processing_vars.mat');
% Remove BB60C Signal Hound harmonics & FLT201A/N FM notch attenuation
max_vec=process;

% collect several sweeps

% Find std & mean (linear NOT log operations)
% leave processed max_vec linear
% compress;

% Plot
start=startPtr.Value; %Hz
stop=start+span; %Hz
freq_bins=traceLenPtr.Value;
freq_vec=linspace(start,stop,freq_bins);

close_test;

% config_sweep_test;
    function close_test
        message(12,:)=calllib('bb_api','bbCloseDevice',devicePtr.Value)
    end
    function config_sweep
        %  Configuring the detector and power scaling
        BB_MIN_AND_MAX=uint32(0);
        BB_LOG_SCALE=uint32(0);
        message(2,:)=calllib('bb_api','bbConfigureAcquisition',devicePtr.Value,BB_MIN_AND_MAX,BB_LOG_SCALE);
        % Configuring the frequency range
        message(3,:)=calllib('bb_api','bbConfigureCenterSpan',devicePtr.Value,center,span);
        % Configuring reference level and internal attenuators
        ref=double(-30); %dBm
        atten=double(-1);% <0 auto
        message(4,:)=calllib('bb_api','bbConfigureLevel',devicePtr.Value,ref,atten);
        % Configuring internal amplifiers
        BB_AUTO_GAIN=int32(-1); %
        message(5,:)=calllib('bb_api','bbConfigureGain',devicePtr.Value,BB_AUTO_GAIN);
        % Configuring RBW/VBW/sweep time
        rbw=double(10e3); %Hz
        vbw=double(10e3); %Hz
        swp_time=double(0.01); %sec
        BB_NON_NATIVE=uint32(1); %<------------------------------------???
        BB_NO_SPUR_REJECT=uint32(0);%<------------------------------------???
        message(6,:)=calllib('bb_api','bbConfigureSweepCoupling',devicePtr.Value,rbw,vbw,swp_time,BB_NON_NATIVE,BB_NO_SPUR_REJECT);
        % Configuring window functions for certain RBWs
        BB_FLAT_TOP=uint32(3);% b/c BB_NON_NATIVE
        message(7,:)=calllib('bb_api','bbConfigureWindow',devicePtr.Value,BB_FLAT_TOP);
        % Configure VBW processing
        BB_POWER=uint32(2); %
        %BB_LOG=uint32(0);
        message(8,:)=calllib('bb_api','bbConfigureProcUnits',devicePtr.Value,BB_POWER);
    end
    function init_device
        % This function may be used to calibrate device to it current temp.
        BB_SWEEPING=uint32(0); % aquisition mode
        flag=uint32(0);
        message(9,:)=calllib('bb_api','bbInitiate',devicePtr.Value,BB_SWEEPING,flag);
        %
    end
    function query_trace
        % Device returns trace given configuration settings & device mode
        binSizePtr=libpointer('doublePtr',0); %.Value is freq. bin bandwidth [Hz]
        message(10,:)=calllib('bb_api','bbQueryTraceInfo',devicePtr.Value,traceLenPtr,binSizePtr,startPtr);
    end
    function maxPtr=fetch_trace
        minPtr=libpointer('doublePtr',zeros(1,traceLenPtr.Value));
        maxPtr=libpointer('doublePtr',zeros(1,traceLenPtr.Value));
        message(11,:)=calllib('bb_api','bbFetchTrace',devicePtr.Value,traceLenPtr.Value,minPtr,maxPtr);
        time_stamps(1,:)=clock;
    end
    function max_vec = process
        % Reverse filter effects
        max_vec = maxPtr.Value+FLT201_fm_filter;
        % Convert to Linear
        max_vec = max_vec./10;
        max_vec = 10.^ max_vec;
        % Remove BB60C Device Harmonics
        max_vec(harmonic_idx)=max_vec(harmonic_idx)-bb60c_harmonics;
    end
end