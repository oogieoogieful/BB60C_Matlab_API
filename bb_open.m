clear;close all;clc;

addpath('C:\Program Files\Signal Hound\Spike\api\bb_series\x86');
addpath('C:\Program Files\Signal Hound\Spike\api\bb_series');

if (libisloaded('bb_api' )== 0)
    loadlibrary('bb_api','bb_api.h')
end

device_ptr=libpointer('int32Ptr',0);
%device_ptr=int32(0);
connect_msg=calllib('bb_api','bbOpenDevice',device_ptr);

%********************CONFIGURATIONs SETTING********************************
% See bb_api.h for configuration values

BB_MIN_AND_MAX=uint32(zeros(1,1));
BB_LOG_SCALE=uint32(zeros(1,1));
%  bbConfigureAcquisition() & Configuring the detector and linear/log scaling
settings(1,:)=calllib('bb_api','bbConfigureAcquisition',device_ptr.Value,BB_MIN_AND_MAX,BB_LOG_SCALE);

% bbConfigureCenterSpan() – Configuring the frequency range
% start=float(20e6); %Hz
% stop=float(1e9); %Hz
%span=start-stop;
%center=span/2+start;
center=double(510e6); %Hz
span=double(980e6); %Hz
settings(2,:)=calllib('bb_api','bbConfigureCenterSpan',device_ptr.Value,center,span);

%  bbConfigureLevel() – Configuring reference level and internal attenuators
ref=double(-30); %dBm
atten=double(-1);%if negative the attenuation is auto ?????????????????????????????????
settings(3,:)=calllib('bb_api','bbConfigureLevel',device_ptr.Value,ref,atten);

% bbConfigureGain() – Configuring internal amplifiers
BB_AUTO_GAIN=int32(-1); %-1 is auto
settings(4,:)=calllib('bb_api','bbConfigureGain',device_ptr.Value,BB_AUTO_GAIN);

%  bbConfigureSweepCoupling() – Configuring RBW/VBW/sweep time
rbw=double(10e3); %Hz
vbw=double(10e3); %Hz
swp_time=double(0.1); %sec
BB_NON_NATIVE=uint32(1); %????????????????????????????????????????
BB_NO_SPUR_REJECT=uint32(0); %?????????????????????????????????
settings(5,:)=calllib('bb_api','bbConfigureSweepCoupling',device_ptr.Value,rbw,vbw,swp_time,BB_NON_NATIVE,BB_NO_SPUR_REJECT);

%  bbConfigureWindow() – Configuring window functions for certain RBWs
BB_FLAT_TOP=uint32(3);% b/c BB_NON_NATIVE, SEE documentation ??????????????????????????
settings(6,:)=calllib('bb_api','bbConfigureWindow',device_ptr.Value,BB_FLAT_TOP);

% %  bbConfigureProcUnits()– Configure VBW processing
BB_POWER=uint32(2); %????????????????????????????????????
settings(7,:)=calllib('bb_api','bbConfigureProcUnits',device_ptr.Value,BB_POWER);
%*************************************************************************



%*********************Initialize DEVICE - SWEEPING MODE *******************
BB_SWEEPING=uint32(0);
flag=uint32(0); % this can be use to time stamp data with external GPS
state=calllib('bb_api','bbInitiate',device_ptr.Value,BB_SWEEPING,flag);
%**************************************************************************

% bbQueryTraceInfo() - 
dummy=0;
traceLen_ptr=libpointer('uint32Ptr',0);
%traceLen=uint32(dummy);
binSize_ptr=libpointer('doublePtr',0);
%binSize=double(dummy);
start_ptr=libpointer('doublePtr',0);

query=calllib('bb_api','bbQueryTraceInfo',device_ptr.Value,traceLen_ptr,binSize_ptr,start_ptr);