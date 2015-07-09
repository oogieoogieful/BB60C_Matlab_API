close all;

filename=sample_time(1,1:19);

start = 20e6;%Hz
stop = 1e9;%Hz
freq_vec=linspace(start,stop,401408)/1e6;%MHz

% Convert linear to log
max_mat_log=-abs(10.*log10(max_mat));
mean_mat_log=-abs(10.*log10(mean_mat));
std_mat_log=-abs(10.*log10(std_mat));

minutes_saved=30; %make this more general
minutes_sample=0.25;% make this more general
sec_sample=minutes_sample*60;

num_frame=length(sample_time(:,1));

% Create movie with recording
figure(1);
vidObj=VideoWriter('M_1_2015_07_03.avi');
vidObj.FrameRate=num_frame/100;

open(vidObj);
set(gcf,'Renderer','zbuffer');

%frame=zeros(num_frame,1);
 for i=1:num_frame
     plot(freq_vec,max_mat_log(i,:),'b',freq_vec,mean_mat_log(i,:),'m')
     axis([0 1000 -105 0])
     xlabel('Frequency [MHz]')
     ylabel('Power [dBm]')
     title(filename)
     legend('Max Compression of Max Trace','Mean Compression of Max Trace')
     frame=getframe(gcf);
     writeVideo(vidObj,frame);
 end
 
close(vidObj);