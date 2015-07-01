min_ptr=libpointer('doublePtr',zeros(1,traceLen_ptr.Value));
max_ptr=libpointer('doublePtr',zeros(1,traceLen_ptr.Value));
trace=calllib('bb_api','bbFetchTrace',device_ptr.Value,traceLen_ptr.Value,min_ptr,max_ptr);
