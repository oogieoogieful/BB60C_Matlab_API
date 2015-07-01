minutes_sample = 1;
minutes_capture = 120;
minutes_run = 720;
elapsed_time = tic;
while toc(elapsed_time) < minutes_run * 60
elapsed_time_capture = tic;
min_mat=[];
comp_mat=[];
sample_time=[];
while toc(elapsed_time_capture) < minutes_capture * 60
    mat=[];
    elapsed_time_sample = tic;
    while toc(elapsed_time_sample) < minutes_sample * 60
        bb_fetch;
        vec=max_ptr.Value;
        mat=[mat;vec];
        state=calllib('bb_api','bbInitiate',device_ptr.Value,BB_SWEEPING,flag);
    end
    vec = max(mat);
    minvec = min(mat);
    min_mat = [min_mat;minvec];
    min_mat = [min_mat;min_mat];
    min_mat = min(min_mat);
    clear mat;
    sample_time=[sample_time;datestr(now,'dd-mm-yyyy HH:MM:SS FFF')];
    comp_mat = [comp_mat;vec];
    save(strrep(num2str(sample_time(1,11:19)),':',''), 'comp_mat','sample_time');
end
end