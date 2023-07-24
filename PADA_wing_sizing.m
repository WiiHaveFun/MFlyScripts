% Michael Chen - July 22, 2023
% This script generates a CSV for PADA wing sizing

%% Trade 1
%{
Pointed tip
One airfoil across entire span

Parameters to modify are
- wing root chord (8-12")
- wing span (24-36")
- taper ratio (0.25-1.0)
- sweep angle (0-20 deg)

Output
- sref, cref, bref
- root chord
- tip chord
- tip position (x, y)
%}

useMeters = false;

% In inches
% rootChord = 8:1:12; % old
% wingSpan = 24:4:36;
% taperRatio = 0.2:0.2:1;
% sweepAngle = 0:5:20;
rootChord = 8:1:12;
wingSpan = 28:4:36;
taperRatio = 0.2:0.2:1;
sweepAngle = 20:5:30;

if useMeters
    rootChord = rootChord / 39.37;
    wingSpan = wingSpan / 39.37;
end

numRunCases = length(rootChord) * length(wingSpan) * length(taperRatio) * length(sweepAngle);

disp(strcat("Num run cases = ", string(numRunCases)));

[rootChord, wingSpan, taperRatio, sweepAngle] = ndgrid(rootChord, wingSpan, taperRatio, sweepAngle);

% Tip chord from definition of taper ratio
tipChord = taperRatio .* rootChord;

% Wing area is trapezoidal
sref = wingSpan .* (rootChord + tipChord) ./ 2;

% Wing span
bref = wingSpan;

% MAC is integrated
syms y rootCh tipCh halfSpan S

% Define chord as a linear function
c(y, rootCh, tipCh, halfSpan) = rootCh - (rootCh - tipCh) / halfSpan * y;

% Integral for calculating mean aerodynamic chord
MAC(rootCh, tipCh, halfSpan, S) = 2 / S * int(c(y, rootCh, tipCh, halfSpan)^2, y, 0, halfSpan);

% Get output from symbolic function
cref = double(vpa(MAC(rootChord, tipChord, wingSpan / 2, sref)));

% Tip position y is half span
tipPositionY = wingSpan / 2;

% Tip position x is calculated from sweep angle about the quarter-chord
% line.
tipPositionX = tipPositionY .* tan(deg2rad(sweepAngle)) + rootChord / 4 - tipChord / 4;


% Reshape the matrices into column vectors
sref = reshape(sref, [], 1);
cref = reshape(cref, [], 1);
bref = reshape(bref, [], 1);
rootChord = reshape(rootChord, [], 1);
tipChord = reshape(tipChord, [], 1);
tipPositionX = reshape(tipPositionX, [], 1);
tipPositionY = reshape(tipPositionY, [], 1);
taperRatio = reshape(taperRatio, [], 1);
sweepAngle = reshape(sweepAngle, [], 1);

% Output a CSV
output = round([sref, cref, bref, rootChord, tipChord, tipPositionX, tipPositionY, taperRatio, sweepAngle], 4);
T = array2table(output);
T.Properties.VariableNames = ["sref", "cref", "bref", "rootChord", "tipChord", "tipPositionX", "tipPositionY", "taperRatio", "sweepAngle"];
writetable(T, 'QM-3_Trade1.csv');
