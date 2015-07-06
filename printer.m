close all;

start = 20e6;
stop = 1e9;
freq_vec=linspace(start,stop,401408)/1e6;%MHz

% Convert linear to log
max_mat_log=-abs(10.*log10(max_mat));
mean_mat_log=-abs(10.*log10(mean_mat));
std_mat_log=-abs(10.*log10(std_mat));

minutes_saved=30;
num_frame=length(sample_time);

% Create movie with recording
figure(1);
vidObj=VideoWriter('signal.avi');
vidObj.FrameRate=num_frame/100;

open(vidObj);
set(gcf,'Renderer','zbuffer');

%frame=zeros(num_frame,1);
 for i=1:num_frame
     plot(freq_vec,max_mat_log(i,:),'b',freq_vec,mean_mat_log(i,:),'m')
     axis([0 1000 -100 0])
     xlabel('Frequency [MHz]')
     ylabel('Power [dBm]')
     title(sample_time(1,:))
     legend('Max Compression of Max Trace','Mean Compression of Max Trace')
     frame=getframe(gcf);
     writeVideo(vidObj,frame);
 end
 
close(vidObj);

% Spectrogram
figure(2)
imagesc(freq_vec,1:minutes_saved,max_mat_log)
cmin=-90;%dBm
cmax=-40;%dBm
caxis([cmin cmax])
colorbar()
xlabel('Frequency [MHz]')
ylabel('Time [Minutes]')
title(sample_time(1,1:19))

% Compress 30 min. recording to one frame
figure(3)
hold on;
plot(freq_vec,max(max_mat_log),'b')
plot(freq_vec,mean(mean_mat_log),'m')
%plot(freq_vec,max(mean_mat_log),'k')
axis([0 1000 -100 0])
xlabel('Frequency [MHz]')
ylabel('Power [dBm]')
title(sample_time(1,1:19))
legend('Max of 30 min. recording','Mean of 30 min. recordin','Max of Mean')
hold off;
% histogram