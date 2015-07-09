close all;clear;clc;
% Fetch a single trace
bb_open;
minPtr=libpointer('doublePtr',zeros(1,traceLenPtr.Value));
maxPtr=libpointer('doublePtr',zeros(1,traceLenPtr.Value));
trace=calllib('bb_api','bbFetchTrace',devicePtr.Value,traceLenPtr.Value,minPtr,maxPtr);
plot(maxPtr.Value)
ylabel('Power')
xlabel('Indices')
bb_close;