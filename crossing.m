function [ind, zer] = crossing(V, x)
    % CROSSING - Finds where the function crosses zero.
    %
    % [ind, zer] = CROSSING(V, x) finds the indices `ind` in the vector `V` where
    % the values cross zero. If `x` is provided, it also returns the interpolated
    % values `zer` of `x` at these crossing points.
    %
    % Inputs:
    %   V - Vector of function values (e.g., LHS - RHS)
    %   x - (Optional) Corresponding x values for V (e.g., frequency)
    %
    % Outputs:
    %   ind - Indices of zero crossings
    %   zer - Interpolated x-values at zero crossings (if x is provided)

    ind = find(V(1:end-1) .* V(2:end) < 0); % Find indices where the sign changes

    if nargin > 1 % If x is provided
        zer = x(ind) - V(ind) .* (x(ind+1) - x(ind)) ./ (V(ind+1) - V(ind));
    else
        zer = [];
    end
end
