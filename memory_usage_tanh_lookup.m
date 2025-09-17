nTol = 32; % Initialize variables
solutions = cell(1,nTol);
objectiveValues = cell(1,nTol);
constraintValues = cell(1,nTol);
memoryUnits = 'bytes';

% Options for absolute tolerance
absTol = 2.^linspace(-12,-4,nTol);

% Relative tolerance is set to 0
relTol = 0;

% Initialize options
options = FunctionApproximation.Options( ...
    'RelTol', relTol, ...
    'BreakpointSpecification', 'EvenSpacing', ...
    'Display', false, ...
    'WordLengths', 16);

% Setup the approximation problem
problem = FunctionApproximation.Problem( ...
    @(x) 1 - exp(-x), ...
    'InputTypes',numerictype(0,16), ...
    'OutputType',numerictype(1,16,14), ...
    'InputLowerBounds',0, ...
    'InputUpperBounds',5, ...
    'Options',options);

% Execute to find solutions with different tolerances
for iTol = 1:nTol
    problem.Options.AbsTol = absTol(iTol);
    solution = solve(problem);
    objectiveValues{iTol} = arrayfun(@(x) x.totalMemoryUsage(memoryUnits), solution.AllSolutions);
    constraintValues{iTol} = arrayfun(@(x) x.Feasible, solution.AllSolutions);
    solutions{iTol} = solution;
end


% Plot results

h = figure();
hold on;

for iTol = 1:nTol
    for iObjective = 1:numel(objectiveValues{iTol})
        if constraintValues{iTol}(iObjective)
            markerColor = 'g';
        else
            markerColor = 'r';
        end
        plot(absTol(iTol),objectiveValues{iTol}(iObjective), ...
            'Marker', '.' ,'LineStyle', 'none', ...
            'MarkerSize', 24, ...
            'MarkerEdgeColor', markerColor)
    end
end

xlabel('AbsTol')
ylabel(['MemoryUsage (',memoryUnits,')'])
h.Children.XScale = 'log';
h.Children.YMinorGrid = 'on';
grid on
box on
hold off;