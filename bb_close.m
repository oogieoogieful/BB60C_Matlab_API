% function bb_close
% clear;clc;close all;
% CLOSE DEVICE
connect_msg(2,:)=calllib('bb_api','bbCloseDevice',devicePtr.Value)
%connect_msg(1,:)=calllib('bb_api','bbCloseDevice',0)
