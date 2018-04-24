% test demo

problem = 'relpose_5p';
simfun = ['simulator_' problem];
prefun = ['preprocess_' problem];
solfun = ['solver_' problem];
posfun = ['postprocess_' problem];
benfun = ['benchmark_' problem];

[gt,rawdata] = feval(simfun)            % Generate ground truth and rawdata
[data]=feval(prefun,rawdata);           % Pre-process rawdata to data for minimal problem.
sols = feval(solfun,data);              % Solve the minimal problem
[rawsols]=feval(posfun,rawdata,data,sols) 
                                        % Post-process the solutions 
[besterr,err] = feval(benfun,rawsols,gt);       
                                        % Compare solution with ground truth

disp(besterr);

