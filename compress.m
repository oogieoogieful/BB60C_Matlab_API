close all;clear;clc;
% Configure & Initiate Device
bb_open;
% Load FM Filter & Harmonics Processing Data
load('processing_data.mat');

% Initialize Variables
minutes_sample = .25;% mins. which are compressed (approx.)
samples = minutes_sample * 60 * 4; %innermost loop takes ~1/4 second
minutes_capture = 30;% minutes which are saved (approx.)
samples_capture = minutes_capture/minutes_sample;
times_run = 2;% times_run*minutes_capture=whole recording length (approx.)
times = 0;
elapsed_time = tic;

% Single Capture 
min_ptr=libpointer('doublePtr',zeros(1,traceLen_ptr.Value));
max_ptr=libpointer('doublePtr',zeros(1,traceLen_ptr.Value));

% Matrices without Compression
mat_max_sample=zeros(samples,traceLen_ptr.Value);
%mat_min_sample=zeros(samples,traceLen_ptr.Value);

% Compress Matrices for Whole Recording
max_mat  = zeros(samples_capture,traceLen_ptr.Value);
%min_mat  = zeros(samples_capture,traceLen_ptr.Value);
std_mat  = zeros(samples_capture,traceLen_ptr.Value);
mean_mat = zeros(samples_capture,traceLen_ptr.Value);
%time_vec=char(zeros(samples_capture,23));%<---Test this to replace
%sample_time
while times < times_run
    elapsed_time_capture = tic;
    sample_time=[];
    count_capture = 1;
    while count_capture < samples_capture +1 
        mat_max_sample = mat_max_sample - 1000; % this is to ensure that if it misses one it wont make a difference
        count = 1;
        elapsed_time_sample = tic;
        while count < samples
            % Sweep for Max & Min trace
            trace=calllib('bb_api','bbFetchTrace',device_ptr.Value,traceLen_ptr.Value,min_ptr,max_ptr);
            % Power Measurements
            % Reverse Effects of FLT201A/N FM Notch Filter
            max_vec = max_ptr.Value+power_filter;
            %min_vec = min_ptr.Value+power_filter;
            %max_vec = max_ptr.Value;
            %min_vec = min_ptr.Value;
            
            % Convert to Linear
            max_vec = max_vec./10;
            max_vec = 10.^ max_vec;
            % Remove BB60C Device Harmonics
            max_vec(harmonic_idx)=max_vec(harmonic_idx)-linear_power_harmonic;
            % Save current sample to matrix
            mat_max_sample(count,:) = max_vec;
            %mat_min_sample(count,:)= min_vec;
            % Re-Calibrate Device
            state=calllib('bb_api','bbInitiate',device_ptr.Value,BB_SWEEPING,flag);
            count = count + 1;
        end
        max_vec = max(mat_max_sample);%mW
        %min_vec = min(mat_min_sample);%dBm
        clear mat_min;
        std_vec = std(mat_max_sample);
        mean_vec = mean(mat_max_sample);
        clear mat_max;
        sample_time=[sample_time;datestr(now,'dd-mm-yyyy HH:MM:SS FFF')];
        max_mat(count_capture,:) = max_vec;
        %min_mat(count_capture,:) = min_vec;
        std_mat(count_capture,:) = std_vec;
        mean_mat(count_capture,:) = mean_vec;
        count_capture = count_capture + 1;
    end
    save(strrep(num2str(sample_time(1,11:19)),':',''),'sample_time','max_mat','std_mat','mean_mat');%,'min_mat');
    times = times + 1;
end
bb_close;