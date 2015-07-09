clear;close all;clc;

% path to .dll & .lib
addpath('C:\Program Files\Signal Hound\Spike\api\bb_series\x86');
% path to header
addpath('C:\Program Files\Signal Hound\Spike\api\bb_series');

% Check if Library Loaded
if (libisloaded('bb_api' )== 0)
    loadlibrary('bb_api','bb_api.h')
end

% Open Device - .Value is device number - used in every function
devicePtr=libpointer('int32Ptr',0);
connect_msg(1,:)=calllib('bb_api','bbOpenDevice',devicePtr);

%********************CONFIGURATIONS SETTING********************************
% See bb_api.h for configuration values

%  bbConfigureAcquisition() & Configuring the detector and linear/log scaling
BB_MIN_AND_MAX=uint32(0);
BB_LOG_SCALE=uint32(0);
settings(1,:)=calllib('bb_api','bbConfigureAcquisition',devicePtr.Value,BB_MIN_AND_MAX,BB_LOG_SCALE);

% bbConfigureCenterSpan() – Configuring the frequency range
start=20e6; %Hz
stop=1e9; %Hz
center=double((stop-start)/2+start); %Hz
span=double(stop-start); %Hz
settings(2,:)=calllib('bb_api','bbConfigureCenterSpan',devicePtr.Value,center,span);

%  bbConfigureLevel() – Configuring reference level and internal attenuators
ref=double(-30); %dBm
atten=double(-1);%if negative the attenuation is auto ?????????????????????????????????
settings(3,:)=calllib('bb_api','bbConfigureLevel',devicePtr.Value,ref,atten);

% bbConfigureGain() – Configuring internal amplifiers
BB_AUTO_GAIN=int32(-1); %??????????????????????????????????????????????????
settings(4,:)=calllib('bb_api','bbConfigureGain',devicePtr.Value,BB_AUTO_GAIN);

%  bbConfigureSweepCoupling() – Configuring RBW/VBW/sweep time
rbw=double(10e3); %Hz
vbw=double(10e3); %Hz
swp_time=double(0.01); %sec
BB_NON_NATIVE=uint32(1); %????????????????????????????????????????
BB_NO_SPUR_REJECT=uint32(0); %?????????????????????????????????
settings(5,:)=calllib('bb_api','bbConfigureSweepCoupling',devicePtr.Value,rbw,vbw,swp_time,BB_NON_NATIVE,BB_NO_SPUR_REJECT);

%  bbConfigureWindow() – Configuring window functions for certain RBWs
BB_FLAT_TOP=uint32(3);% b/c BB_NON_NATIVE, SEE documentation ??????????????????????????
settings(6,:)=calllib('bb_api','bbConfigureWindow',devicePtr.Value,BB_FLAT_TOP);

% %  bbConfigureProcUnits()– Configure VBW processing
BB_POWER=uint32(2); %????????????????????????????????????
BB_LOG=uint32(0);
settings(7,:)=calllib('bb_api','bbConfigureProcUnits',devicePtr.Value,BB_LOG);
%*************************************************************************

%*********************Initialize DEVICE - SWEEPING MODE *******************
% This function may be used to calibrate device to it current temperature.
BB_SWEEPING=uint32(0); % aquisition mode
flag=uint32(0); 
state=calllib('bb_api','bbInitiate',devicePtr.Value,BB_SWEEPING,flag);
%**************************************************************************

% bbQueryTraceInfo() - 
traceLenPtr=libpointer('uint32Ptr',0); % # of frequency bins
binSizePtr=libpointer('doublePtr',0); % ??????????????????????????????????
startPtr=libpointer('doublePtr',0);% ?????????????????????????????????????
query=calllib('bb_api','bbQueryTraceInfo',devicePtr.Value,traceLenPtr,binSizePtr,startPtr);