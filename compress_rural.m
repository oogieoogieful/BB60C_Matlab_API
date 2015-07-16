close all;clear;clc;

% Configure & Initiate Device
bb_open;

% Load FM Filter & Harmonics Processing Data
load('processing_vars.mat');

% While Conditions
minutes_sample = .75;% mins. which are compressed (approx.)<--test 0.5 or 1min
samples = minutes_sample * 60 * 4; %innermost loop takes ~1/4 second <-- restest this
minutes_saved = 30;% minutes which are saved (approx.)
samples_capture = minutes_saved/minutes_sample;
times_run =2;% times_run*minutes_capture=whole recording length (approx.)
times = 0;

% Single Capture 
min_ptr=libpointer('doublePtr',zeros(1,traceLenPtr.Value));
max_ptr=libpointer('doublePtr',zeros(1,traceLenPtr.Value));

% Matrices without Compression
mat_max_sample=zeros(samples,traceLenPtr.Value);
%mat_min_sample=zeros(samples,traceLenPtr.Value);

% Compress Matrices for Whole Recording
max_mat  = zeros(samples_capture,traceLenPtr.Value);
std_mat  = zeros(samples_capture,traceLenPtr.Value);
mean_mat = zeros(samples_capture,traceLenPtr.Value);
%min_mat  = zeros(samples_capture,traceLenPtr.Value);

% Time Stamp
%time_vec=char(zeros(samples_capture,23));%<---Test this to replace
%sample_time

% These time stamps are suspect.
elapsed_time = tic; 
while times < times_run
    elapsed_time_capture = tic;
    sample_time=[];
    count_capture = 1;
    while count_capture < samples_capture +1 
        mat_max_sample = mat_max_sample - 1000; % this is to ensure that if it misses one it wont make a difference
        count = 1;
        elapsed_time_sample = tic;
        while count < samples + 1
            % Sweep for Max & Min trace
            trace=calllib('bb_api','bbFetchTrace',devicePtr.Value,traceLenPtr.Value,min_ptr,max_ptr);
            % Process Power Measurements
            % Reverse Effects of FLT201A/N FM Notch Filter
            max_vec = max_ptr.Value+FLT201_fm_filter;
            %max_vec=max_vec+FLT201_fm_filter;
            % LNA Pre-amp
            max_vec=max_vec-LNA_pam103;
            % Antenna
            max_vec=max_vec+combilog_AC_220;
            %min_vec = min_ptr.Value+power_filter;
            
            % Convert to Linear
            max_vec = max_vec./10;
            max_vec = 10.^ max_vec;
            % Remove BB60C Device Harmonics
            max_vec(harmonic_idx)=max_vec(harmonic_idx)-bb60c_harmonic_lin;
            
            % Save current sample to matrix
            mat_max_sample(count,:) = max_vec;
            %mat_min_sample(count,:)= min_vec;
            
            % Re-Calibrate Device to current temp. 
            state=calllib('bb_api','bbInitiate',devicePtr.Value,BB_SWEEPING,flag);
            count = count + 1;
        end
        % Compress each sample
        max_vec = max(mat_max_sample);%mW
        std_vec = std(mat_max_sample); %mW
        mean_vec = mean(mat_max_sample); %mW
        %min_veca = min(mat_min_sample);%dBm
        
        % Re-intialize Vars
        mat_max_sample=zeros(samples,traceLenPtr.Value); %<-- test!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        %mat_min_sample=zeros(samples,traceLenPtr.Value);
        
        % Time Stamp each compression
        sample_time=[sample_time;datestr(now,'dd-mm-yyyy HH:MM:SS FFF')];%?????????????????????
        
        % Store each compression
        max_mat(count_capture,:) = max_vec; %mW
        std_mat(count_capture,:) = std_vec;%mW
        mean_mat(count_capture,:) = mean_vec;%mW
        %min_mat(count_capture,:) = min_vec;
        
        count_capture = count_capture + 1;
    end
    % Save Appropriate Workspace Variables
    save(strrep(num2str(sample_time(1,11:19)),':',''),'times_run','minutes_sample','minutes_saved','samples_capture','sample_time','max_mat','std_mat','mean_mat');%,'min_mat');
    times = times + 1;
end
bb_close;