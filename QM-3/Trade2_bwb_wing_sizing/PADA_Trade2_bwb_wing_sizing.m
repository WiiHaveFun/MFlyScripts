% Michael Chen - July 28, 2023
% This script generates a CSV for PADA wing sizing

%% Trade 2
%{
The plane has a rectangular fuselage (constant chord and fixed width)
The rest of the wing is swept and tapered
The start of the wing, after the fuselage, is a narrow transition region
with interpolated airfoils

Constants are
- wing/fuselage root chord (15")
- fuselage width (4") (includes both halves)

Parameters to modify are
- wing span (24"-36")
- taper ratio (0.25-1.0)
- sweep angle (0-20 deg)
- transition width (0.5"-2") (1"-4" for both sides)

Output
- sref, cref, bref
- tip chord
- tip position (x, y)
- transition end/wing start chord
- transition end/wing start position (x, y)
%}

useMeters = false;

% In inches
rootChord = 15;
fuselageWidth = 4;

wingSpan = 24:4:36;
taperRatio = 1.0:-0.2:0.2;
sweepAngle = 0:5:20;
transitionWidth = 0.5:0.5:2;

if useMeters
    rootChord = rootChord / 39.37;
    fuselageWidth = fuselageWidth / 39.37;
    wingSpan = wingSpan / 39.37;
    transitionWidth = transitionWidth / 39.37;
end

numRunCases = length(wingSpan) * length(taperRatio) * length(sweepAngle) * length(transitionWidth);
disp(strcat("Num run cases = ", string(numRunCases)));

[wingSpan, taperRatio, sweepAngle, transitionWidth] = ndgrid(wingSpan, taperRatio, sweepAngle, transitionWidth);

% Tip chord from definition of taper ratio
tipChord = taperRatio .* rootChord;

% Wing area is trapezoidal plus fuselage rectangle
% sref = wingSpan .* (rootChord + tipChord) ./ 2;
wingArea = (wingSpan - fuselageWidth) .* (rootChord + tipChord) ./ 2;
fuselageArea = fuselageWidth * rootChord;
sref = wingArea + fuselageArea;

% Wing span
bref = wingSpan;

% MAC is integrated
syms y rootCh tipCh fuselageEnd halfSpan S

% Define chord as a piecewise linear function
c(y, rootCh, tipCh, fuselageEnd, halfSpan) = piecewise(0 <= y & y < fuselageEnd, ...
    rootCh, ...
    fuselageEnd <= y & y <= halfSpan, ...
    rootCh - (rootCh - tipCh) / (halfSpan - fuselageEnd) * (y - fuselageEnd));

% Integral for calculating mean aerodynamic chord
MAC(rootCh, tipCh, fuselageEnd, halfSpan, S) = 2 / S * int(c(y, rootCh, tipCh, fuselageEnd, halfSpan)^2, y, 0, halfSpan);

% Get output from symbolic function
cref = double(vpa(MAC(rootChord, tipChord, fuselageWidth / 2, wingSpan / 2, sref)));

% Tip position y is half span
tipPositionY = wingSpan / 2;

% Tip position x is calculated from sweep angle about the quarter-chord
% line.
tipPositionX = (tipPositionY - fuselageWidth / 2) .* tan(deg2rad(sweepAngle)) + rootChord / 4 - tipChord / 4;

% Transition end position y
transitionEndPositionY = fuselageWidth / 2 + transitionWidth;

% Transition end chord is found with linear function
transitionEndChord = rootChord - (rootChord - tipChord) ./ (tipPositionY - fuselageWidth / 2) .* transitionWidth;

% Transition end position x is found using linear function
transitionEndPositionX = tipPositionX ./ (tipPositionY - fuselageWidth / 2) .* transitionWidth;

% Reshape the matrices into column vectors
sref = reshape(sref, [], 1);
cref = reshape(cref, [], 1);
bref = reshape(bref, [], 1);
tipChord = reshape(tipChord, [], 1);
tipPositionX = reshape(tipPositionX, [], 1);
tipPositionY = reshape(tipPositionY, [], 1);
transitionEndChord = reshape(transitionEndChord, [], 1);
transitionEndPositionX = reshape(transitionEndPositionX, [], 1);
transitionEndPositionY = reshape(transitionEndPositionY, [], 1);
taperRatio = reshape(taperRatio, [], 1);
sweepAngle = reshape(sweepAngle, [], 1);
transitionWidth = reshape(transitionWidth, [], 1);

% Output a CSV
output = round([sref, cref, bref, tipChord, tipPositionX, tipPositionY, transitionEndChord, transitionEndPositionX, transitionEndPositionY, taperRatio, sweepAngle, transitionWidth], 4);
T = array2table(output);
T.Properties.VariableNames = ["sref", "cref", "bref", "tipChord", "tipPositionX", "tipPositionY", "transitionEndChord", "transitionEndPositionX", "transitionEndPositionY", "taperRatio", "sweepAngle", "transitionWidth"];
writetable(T, 'QM-3_Trade2.csv');