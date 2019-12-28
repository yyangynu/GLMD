function [assignments] = lap_wrapper(costs, dummy)
% [assignments] = lap_wrapper(costs, dummy)
% Wrapper function to call a C++ implementation of the Jonker Volgenant
% Algorithm to solve the Linear Assignment Problem. This wrapper ensures
% that the cost matrix given as input is square and padds the matrix by
% extra dummy values. assignments has the same size as costs. 

% The LAP algorithm expects no mixed signs of entries. Thus make all
% entries positive by subtracting the minimum element from the       
% matrix. Make the matrix square by adding dummy entries, and       
% prevent unwanted matches which we consider impossible, by further 
% extending with dummy entries as required. The final size of the    
% cost matrix we feed to the algorithm is                                
% (2 * max(size(costs)))-by-(2 * max(size(costs)))

min_cost = min([costs(:); dummy]);

% Special case: if any of the dimensions of min_cost are zero, then
% force it to be a scalar so that the code below correcly operates on 
% cost matrices with a zero dimension. 

if(any(size(min_cost) == 0))
  min_cost = 0;
end

% Ensure all entries are of positive sign
costs = costs - min_cost;

% The dummy has also changed
dummy = dummy - min_cost;

% Make the matrix square by adding dummies
nrows = size(costs, 1);
ncols = size(costs, 2);

if(nrows == ncols)
  lap_costs = costs;
end

if(nrows < ncols)
  lap_costs = [costs; ones(ncols - nrows, ncols) * dummy];
end

if(ncols < nrows)
  lap_costs = [costs, ones(nrows, nrows - ncols) * dummy];
end

% Add further dummies to avoid matching unlikely pairs. 
lap_costs = [lap_costs, ones(size(lap_costs)) * dummy;
	     ones(size(lap_costs)) * dummy, ones(size(lap_costs)) * dummy];

% Run the LAP assignment algorithm
assignments = lap(lap_costs);
assignments = assignments(1:nrows, 1:ncols); % Crop out dummy matches
