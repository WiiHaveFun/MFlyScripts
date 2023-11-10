% Michael Chen - August 7, 2023
% This script generates a CSV for PA tail sizing

%% Tip Chord Change
%{
The plane has a rectangular fuselage.
The plane has a trapezoidal transition region.
The plane has a fully tapered wing.

Constants are
- wingspan (9.95')
- wing chord (2')
- fuselage area (1000 in^3)
- fuselage length (54")
- fuselage width (4.1917")
- transition region width (3")
- elevator chord ratio (0.5)
- CG position (quarter MAC)
- horizontal tail AR (5)
- taper ratio (0.5)
- H-tail volume coeff (0.45)

- sref, cref, bref () () ()
- tip chord
- transition end/wing start position (y)
- fuselage end position/transition start position (y)

- wing setback ratio (0.78)
- tail length (quarter MAC wing - quarter MAC tail) (57")


Output
- leading edge position (x)
- cg position (x)
- tail position (x)
- tail tip position (y)
- tail chord
%}

clear

useMeters = true;

fuselageLength = 54;
fuselageWidth = 4.1917;
transitionWidth = 3;
wingChord = 24;
wingspan = 9.95 * 12;

cgMinXRatio = 0.4;
cgPositionRatio = 1.0;
hTailAR = 5;

taperRatio = 0.5;
transitionSetbackRatio = 0.78;
hTailLength = 57;
hTailCoeff = 0.45;

numRunCases = length(taperRatio) * length(transitionSetbackRatio) * length(cgPositionRatio) * length(hTailAR) * length(hTailLength) * length(hTailCoeff);
disp(strcat("Num run cases = ", string(numRunCases)));

[taperRatio, transitionSetbackRatio, cgPositionRatio, hTailAR, hTailLength, hTailCoeff] = ndgrid(taperRatio, transitionSetbackRatio, cgPositionRatio, hTailAR, hTailLength, hTailCoeff);

if useMeters
    fuselageLength = fuselageLength / 39.37;
    fuselageWidth = fuselageWidth / 39.37;
    transitionWidth = transitionWidth / 39.37;
    wingChord = wingChord / 39.37;
    wingspan = wingspan / 39.37;
    hTailLength = hTailLength / 39.37;
end

% Tip chord from definition of taper ratio
tipChord = wingChord * taperRatio;

% Leading edge of the wing is straight
leadingEdgeX = (fuselageLength - wingChord) .* transitionSetbackRatio;

% Fuselage end positoin y
fuselageEndY = fuselageWidth / 2;

% Transition end position y
transitionEndY = fuselageEndY + transitionWidth;

% Wing area is trapezoidal
% Transition is trapezoidal
% Fuselage is rectangular
wingArea = ((wingspan / 2 - transitionEndY) .* (wingChord + tipChord) / 2) * 2;
transitionArea = (transitionWidth .* (wingChord + fuselageLength) / 2) * 2;
fuselageArea = fuselageLength * fuselageWidth;
sref = wingArea + transitionArea + fuselageArea;

% Wing span
bref = wingspan;

% MAC is integrated
syms y fuselageL fuselageEnd transitionEnd wingCh tipCh halfSpan S

% Define chord as a piecewise linear function
c1(fuselageL) = fuselageL;
c2(y, fuselageL, fuselageEnd, transitionEnd, wingCh) = fuselageL - (fuselageL - wingCh) / (transitionEnd - fuselageEnd) * (y - fuselageEnd);
c3(y, wingCh, transitionEnd, tipCh, halfSpan) = wingCh - (wingCh - tipCh) / (halfSpan - transitionEnd) * (y - transitionEnd);

% Integral for calculating mean aerodynamic chord
MAC(fuselageL, fuselageEnd, transitionEnd, wingCh, tipCh, halfSpan, S) = 2 / S * (int(c1(fuselageL)^2, y, 0, fuselageEnd) ...
    + int(c2(y, fuselageL, fuselageEnd, transitionEnd, wingCh)^2, y, fuselageEnd, transitionEnd) ...
    + int(c3(y, wingCh, transitionEnd, tipCh, halfSpan)^2, y, transitionEnd, halfSpan));

% Get output from symbolic function
cref = double(vpa(MAC(fuselageLength, fuselageEndY, transitionEndY, wingChord, tipChord, wingspan / 2, sref)));

% CG position is interpolated between 0.4 fuselage length and quarter MAC;
cgMinX = fuselageLength * cgMinXRatio;
quarterMACX = leadingEdgeX + cref * 0.25;
cgPositionX = cgMinX + (quarterMACX - cgMinX) .* cgPositionRatio;

% Use volume tail coefficient method to get tail surface area
hTailArea = hTailCoeff .* cref .* sref ./ hTailLength;

% Use aspect ratio to get tail span and chord
hTailSpan = sqrt(hTailAR .* hTailArea);
hTailTipY = hTailSpan / 2;
hTailChord = hTailSpan ./ hTailAR;

% Tail x position is based on quarter wing chord to quarter tail chord
% distance
hTailX = quarterMACX + hTailLength - hTailChord * 0.25;

% Reshape the matrices into column vectors
sref = reshape(sref, [], 1);
cref = reshape(cref, [], 1);
tipChord = reshape(tipChord, [], 1);

leadingEdgeX = reshape(leadingEdgeX, [], 1);
cgPositionX = reshape(cgPositionX, [], 1);
hTailX = reshape(hTailX, [], 1);
hTailTipY = reshape(hTailTipY, [], 1);
hTailChord = reshape(hTailChord, [], 1);

taperRatio = reshape(taperRatio, [], 1);
transitionSetbackRatio = reshape(transitionSetbackRatio, [], 1);
cgPositionRatio = reshape(cgPositionRatio, [], 1);
hTailAR = reshape(hTailAR, [], 1);
hTailLength = reshape(hTailLength, [], 1);
hTailCoeff = reshape(hTailCoeff, [], 1);

% Output a CSV
output = round([sref, cref, tipChord, leadingEdgeX, cgPositionX, hTailX, hTailTipY, hTailChord, taperRatio, transitionSetbackRatio, cgPositionRatio, hTailAR, hTailLength, hTailCoeff], 4);
T = array2table(output);
T.Properties.VariableNames = ["sref", "cref", "tipChord", "leadingEdgeX", "cgPositionX", "hTailX", "hTailTipY", "hTailChord", "taperRatio", "transitionSetbackRatio", "cgPositionRatio", "hTailAR", "hTailLength", "hTailCoeff"];
writetable(T, 'MX-9_TipChordChange.csv');