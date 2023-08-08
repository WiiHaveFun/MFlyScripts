% Michael Chen - August 3, 2023
% This script generates a CSV for PA wing sizing

%% Trade 1
%{
The plane has a rectangular fuselage (constant chord and fixed width)
There is a trapezoidal transition region connecting the fuselage and wing
The wing is rectangular/tapered/partially tapered.

Constants are
- wingspan (9.95')
- wing chord (2')
- fuselage area (1000 in^3)
- fuselage length (54")
- transition width (3")

Parameters to modify are
- taper ratio (0.2-0.6)
- transition setback ratio (0.6-1.0)

Output
- sref, cref, bref
- tip chord
- leading edge position (x)
- taper start position (y)
- transition end/wing start position (y)
- fuselage chord
- fuselage end position/transition start position (y)
%}

clear

useMeters = true;

% In inches
wingspan = 9.95 * 12;
wingChord = 24;
fuselageVolume = 1000; % in^3
NACA23012UnitArea = 0.0818122; % in^2 for 1" chord and m^2 for 1m chord

fuselageLength = 54;
% taperPositionRatio = 0.8:-0.2:0.2; % 1.0 means no taper, 0.0 mean all taper
taperRatio = 0.6:-0.01:0.2;
transitionWidth = 3;
transitionSetbackRatio = 0.6:0.05:1.0; % 0.0 means wing at front, 1.0 means wing at back

if useMeters
    wingspan = wingspan / 39.37;
    wingChord = wingChord / 39.37;
    fuselageVolume = fuselageVolume / 39.37 / 39.37 / 39.37;
    fuselageLength = fuselageLength / 39.37;
    transitionWidth = transitionWidth / 39.37;
end

numRunCases = length(fuselageLength) * length(taperRatio) * length(transitionWidth) * length(transitionSetbackRatio);
disp(strcat("Num run cases = ", string(numRunCases)));

[fuselageLength, taperRatio, transitionWidth, transitionSetbackRatio] = ndgrid(fuselageLength, taperRatio, transitionWidth, transitionSetbackRatio);

% Tip chord from definition of taper ratio
tipChord = wingChord * taperRatio;

% Leading edge of the wing is straight
leadingEdgeX = (fuselageLength - wingChord) .* transitionSetbackRatio;

% Fuselage width keeping internal volume constant
fuselageWidth = fuselageVolume / (NACA23012UnitArea * fuselageLength .^ 2);
fuselageEndY = fuselageWidth / 2;

% Transition end position y
transitionEndY = fuselageEndY + transitionWidth;

% % Taper start position is found using ratio and wing width
% taperStartY = (wingspan / 2 - transitionEndY) .* taperPositionRatio + transitionEndY;

% Wing area is trapezoidal
% Transition is trapezoidal
% Fuselage is rectangular
wingArea = ((wingspan / 2 - transitionEndY) .* (wingChord + tipChord) / 2) * 2;
transitionArea = (transitionWidth .* (wingChord + fuselageLength) / 2) * 2;
fuselageArea = fuselageLength .* fuselageWidth;
sref = wingArea + transitionArea + fuselageArea;

% Wing span
bref = ones(numRunCases, 1) * wingspan;

% MAC is integrated
syms y fuselageL fuselageEnd transitionEnd wingCh tipCh halfSpan S

% Define chord as a piecewise linear function
c1(fuselageL) = fuselageL;
c2(y, fuselageL, fuselageEnd, transitionEnd, wingCh) = fuselageL - (fuselageL - wingCh) / (transitionEnd - fuselageEnd) * (y - fuselageEnd);
% c3(wingCh) = wingCh;
% c4(y, wingCh, taperStart, tipCh, halfSpan) = wingCh - (wingCh - tipCh) / (halfSpan - taperStart) * (y - taperStart);
c3(y, wingCh, transitionEnd, tipCh, halfSpan) = wingCh - (wingCh - tipCh) / (halfSpan - transitionEnd) * (y - transitionEnd);

% Integral for calculating mean aerodynamic chord
% MAC(fuselageL, fuselageEnd, transitionEnd, wingCh, taperStart, tipCh, halfSpan, S) = 2 / S * (int(c1(fuselageL)^2, y, 0, fuselageEnd) ...
%     + int(c2(y, fuselageL, fuselageEnd, transitionEnd, wingCh)^2, y, fuselageEnd, transitionEnd) ...
%     + int(c3(wingCh)^2, y, transitionEnd, taperStart) ...
%     + int(c4(y, wingCh, taperStart, tipCh, halfSpan)^2, y, taperStart, halfSpan));
MAC(fuselageL, fuselageEnd, transitionEnd, wingCh, tipCh, halfSpan, S) = 2 / S * (int(c1(fuselageL)^2, y, 0, fuselageEnd) ...
    + int(c2(y, fuselageL, fuselageEnd, transitionEnd, wingCh)^2, y, fuselageEnd, transitionEnd) ...
    + int(c3(y, wingCh, transitionEnd, tipCh, halfSpan)^2, y, transitionEnd, halfSpan));

% Get output from symbolic function
cref = double(vpa(MAC(fuselageLength, fuselageEndY, transitionEndY, wingChord, tipChord, wingspan / 2, sref)));

% Reshape the matrices into column vectors
sref = reshape(sref, [], 1);
cref = reshape(cref, [], 1);
bref = reshape(bref, [], 1);
tipChord = reshape(tipChord, [], 1);
leadingEdgeX = reshape(leadingEdgeX, [], 1);
% taperStartY = reshape(taperStartY, [], 1);
transitionEndY = reshape(transitionEndY, [], 1);
fuselageLength = reshape(fuselageLength, [], 1);
fuselageEndY = reshape(fuselageEndY, [], 1);

taperRatio = reshape(taperRatio, [], 1);
% taperPositionRatio = reshape(taperPositionRatio, [], 1);
transitionWidth = reshape(transitionWidth, [], 1);
transitionSetbackRatio = reshape(transitionSetbackRatio, [], 1);

% Output a CSV
output = round([sref, cref, bref, tipChord, leadingEdgeX, transitionEndY, fuselageLength, fuselageEndY, taperRatio, transitionWidth, transitionSetbackRatio], 4);
T = array2table(output);
T.Properties.VariableNames = ["sref", "cref", "bref", "tipChord", "leadingEdgeX", "transitionEndY", "fuselageLength", "fuselageEndY", "taperRatio", "transitionWidth", "transitionSetbackRatio"];
writetable(T, 'MX-9_Trade1_all_taper.csv');