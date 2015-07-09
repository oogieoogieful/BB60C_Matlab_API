close all;

% Assign each file a unique code?
%metadata
time_stamp=sample_time(1,1:19);% time of 1st 'frame block'

start = 20e6;%Hz - make general?
stop = 1e9;%Hz - make general?

freq_bins=length(max_mat);
freq_vec=linspace(start,stop,freq_bins);%Hz

% Convert linear to log
max_mat_log=-abs(10.*log10(max_mat)); %losing precision when convert?
mean_mat_log=-abs(10.*log10(mean_mat));
std_mat_log=-abs(10.*log10(std_mat));

% Spectrogram
figure(1)
imagesc(freq_vec/1e6,1:minutes_saved,max_mat_log)
xlabel('Frequency [MHz]')
ylabel('Time [Minutes]')
title('Power in each Frequency Bin over Time')
cmin=-90;%dBm
cmax=-40;%dBm
caxis([cmin cmax])
h=colorbar();
xlabel(h,'Power [dBm]')


% Compress 30 min. recording to one frame
figure(2)
hold on;
plot(freq_vec/1e6,max(max_mat_log),'b')
plot(freq_vec/1e6,mean(mean_mat_log),'m')
axis([0 1000 -105 0])
xlabel('Frequency [MHz]')
ylabel('Power [dBm]')
title('Single Frame Summary of Whole Recording')
legend('Max Values','Mean Values')
hold off;

% histogram for each freq. bin or box plot?
%figure(3)
