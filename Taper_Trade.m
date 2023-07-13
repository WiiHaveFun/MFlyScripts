% Michael Chen - July 13, 2023
% This script generates a CSV for taper trade studies
% It calculates the mean aerodynamic chord for different combinations of 
% taper

warning("off", "symbolic:piecewise:CouldNotCheckIntegrand");

useMeters = false;

% In inches
rootChord = 23;
tipChord = [20, 15, 10, 5]; 

% Position 0 means where the wing root is, not the center line of the plane
% Use TRANSLATE keyword in AVL to shift wing root section
% Allows for easier bounds of integration
taperPosition = [40, 30, 20, 10, 0];
tipPosition = [45, 50];

% Correction for bref (wingspan)
fuselageWidth = 10;

if useMeters
    rootChord = rootChord / 39.37;
    tipChord = tipChord ./ 39.37;

    taperPosition = taperPosition ./ 39.37;
    tipPosition = tipPosition / 39.37;

    fuselageWidth = fuselageWidth / 39.37;
end

% Creates matrix with all possible combinations
[tipChord, taperPosition, tipPosition] = meshgrid(tipChord, taperPosition, tipPosition);

% Calculate wing area and wing span
sref = 2 .* (rootChord .* taperPosition + (tipChord + rootChord) .* (tipPosition - taperPosition) * 0.5);
bref = tipPosition * 2 + fuselageWidth;

% Setup for symbolic functions
syms y rootCh tipCh taperPos tipPos S

% Define chord as a piece wise function
% Start with straight rectangular, then a trapezoidal taper
c(y, rootCh, tipCh, taperPos, tipPos) = piecewise(0 <= y & y < taperPos, ...
    rootCh, ...
    taperPos <= y & y <= tipPos, ...
    rootCh - (rootCh - tipCh) / (tipPos - taperPos) * (y - taperPos));

% Integral for calculating mean aerodynamic chord
MAC(rootCh, tipCh, taperPos, tipPos, S) = 2 / S * int(c(y, rootCh, tipCh, taperPos, tipPos)^2, y, 0, tipPos);

% Get output from symbolic function
MAC_output = double(vpa(MAC(rootChord, tipChord, taperPosition, tipPosition, sref)));

% Reshape the matrices into a column vectors
tipChord = reshape(tipChord, [], 1);
taperPosition = reshape(taperPosition, [], 1);
tipPosition = reshape(tipPosition, [], 1);
sref = reshape(sref, [], 1);
MAC_output = reshape(MAC_output, [], 1);
bref = reshape(bref, [], 1);

% Output a CSV
output = round([tipChord, taperPosition, tipPosition, sref, MAC_output, bref], 4);
T = array2table(output);
T.Properties.VariableNames = ["tipChord", "taperPosition", "halfSpan", "sref", "cref", "bref"];
writetable(T, 'output.csv');