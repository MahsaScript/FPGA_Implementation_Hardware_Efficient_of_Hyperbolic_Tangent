problem = FunctionApproximation.Problem('atan2');%tansig=tanh
problem.InputTypes = [numerictype(0,4,2),  numerictype(0,8,4)];
problem.OutputType = fixdt(0,8,7);
problem.Options.Interpolation = "None";
problem.Options.AbsTol = 2^-4;
problem.Options.RelTol = 0;
problem.Options.WordLengths = 1:8;
solution = solve(problem);
compare(solution);
