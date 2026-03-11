function C = generate_asymmetric_connectivity(N, PLD, mu_shift)
% GENERATE_ASYMMETRIC_CONNECTIVITY Builds an asymmetric connectivity matrix.
%
% Inputs:
%   N        - number of patches
%   PLD      - pelagic larval duration
%   mu_shift - directional dispersal shift
%
% Output:
%   C        - column-normalized connectivity matrix

    sigma = PLD / 10;
    C = zeros(N);

    for i = 1:N
        for j = 1:N
            % i: destination patch
            % j: source patch
            dist = i - j - mu_shift;
            C(i,j) = exp(-dist^2 / (2*sigma^2));
        end
    end

    % Normalize columns: each source patch exports 100% of its larvae
    C = C ./ sum(C,1);

end