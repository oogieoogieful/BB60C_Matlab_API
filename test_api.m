function test_api
% We are creating nested-functions to configure sweep moode, fetch, process
% and compress power data from Signal Hound BB60C Spectrum Analyzer
% 	3.0 USB on 64-bit Window 7 computer
% 	86 BB API Version 3.0.4 (included with Spike 64 bit 3.0.8 download)
% 	32-bit Matlab
% 	Drivers CDM v2.12.00 WHQL Certified.exe
% 	
% Equipment: (See equipment_schematic.PNG on github)
% 	Com Power Combilog Antenna AC-220 25MHz - 2GHz
% 	FLT201A/N FM Notch Filter
% 	DC Power Block
    
clear;close all;clc;

% path to dll & lib
addpath('C:\Program Files\Signal Hound\Spike\api\bb_series\x86');
% path to header 
addpath('C:\Program Files\Signal Hound\Spike\api\bb_series');

connect_msg=cell([2,19]);%<-- figure out max length

% Check if Library Loaded
if (libisloaded('bb_api' )== 0)
    loadlibrary('bb_api','bb_api.h')
end

% Open Device - .Value is device number - used in every function
device_ptr=libpointer('int32Ptr',0);
connect_msg(1,:)=calllib('bb_api','bbOpenDevice',device_ptr);

close_test;

% config_sweep_test;
    function close_test
        connect_msg(2,:)=calllib('bb_api','bbCloseDevice',device_ptr.Value);
    end
%     function config_sweep_test
%         % each config function or 1 whole one?
%     end
% compress_test
% %     function close
% %     function compress_test
% %         re_init
% %         printer
% %         
% %         function re_init
% %             state=calllib('bb_api','bbInitiate',device_ptr.Value,BB_SWEEPING,flag);
% %         end
% %         
% %         function printer
% %         end
% %     end

end