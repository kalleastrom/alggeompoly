% test demo

[gt,rawdata] = simulator_relpose_5p();  % Generate ground truth and rawdata
[data]=preprocess_relpose_5p(rawdata);  % Pre-process rawdata to data for minimal problem.
sols = solver_relpose_5p(data);         % Solve the minimal problem
[rawsols]=postprocess_relpose_5p(rawdata,data,sols);  
                                        % Post-process the solutions 
[besterr,err] = benchmark_relpose_5p(rawsols,gt);       
                                        % Compare solution with ground truth

disp(err);

