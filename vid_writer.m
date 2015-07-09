close all;

time_stamp=sample_time(1,1:19); %1st time_stamp block

start = 20e6;%Hz
stop = 1e9;%Hz
freq_vec=linspace(start,stop,401408)/1e6;%MHz

% Convert linear to log
max_mat_log=-abs(10.*log10(max_mat));
mean_mat_log=-abs(10.*log10(mean_mat));
std_mat_log=-abs(10.*log10(std_mat));

% Create movie with recording
figure(1);
vidObj=VideoWriter('signal.avi');
vidObj.FrameRate=samples_capture/100;

open(vidObj);
set(gcf,'Renderer','zbuffer');

%frame=zeros(num_frame,1);
 for i=1:samples_capture
     plot(freq_vec,max_mat_log(i,:),'b',freq_vec,mean_mat_log(i,:),'m')
     axis([0 1000 -105 0])
     xlabel('Frequency [MHz]')
     ylabel('Power [dBm]')
     title(time_stamp)
     legend('Max ...','Mean ...')
     frame=getframe(gcf);
     writeVideo(vidObj,frame);
 end
 
close(vidObj);