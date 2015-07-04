
start = 20e6;
stop = 1e9;
freq_vec=linspace(start,stop,401408);
max_mat_log=-abs(10.*log10(max_mat));

figure(4)
imagesc(freq_vec/1e6,1:30,max_mat_log)
cmin=-90;%dBm
cmax=-40;%dBm
caxis([cmin cmax])
colorbar()
xlabel('Frequency [MHz]')
ylabel('Time [Minutes]')
title(sample_time(1,1:19))

% figure(2)
% plot3(freq_vec,1:minutes_capture,max_mat_log)
% xlabel('Frequency [MHz]')
% ylabel('Time [Minutes]')
% title(sample_time(1,1:19))