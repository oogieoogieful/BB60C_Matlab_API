
start = 20e6;
stop = 1e9;
freq_vec=linspace(start,stop,traceLen_ptr.Value);
imagesc(freq_vec/1e6,1:minutes_capture,comp_mat)
xlabel('Frequency [MHz]')
ylabel('Time [Minutes]')
title(sample_time(1,1:19))