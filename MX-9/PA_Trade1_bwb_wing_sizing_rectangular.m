% Michael Chen - August 3, 2023
% This script generates a CSV for PA wing sizing

%% Trade 1
%{
The plane has a rectangular fuselage (constant chord and fixed width)
There is a trapezoidal transition region connecting the fuselage and wing
The wing is rectangular/tapered/partially tapered.

This version is for rectangular wings (i.e no taper).

Constants are
- wingspan (9.95')
- wing chord (2')
- fuselage area (1000 in^3)

Parameters to modify are
- fuselage length (3'-5')
- taper position ratio (0-1.0)
- taper ratio (0.2-1.0)
- transition width (3"-6") (6"-12" for both sides)
- transition setback ratio (0-1.0)

Output
- sref, cref, bref
- tip chord
- tip position (y)
- leading edge position (x)
- transition end/wing start position (y)
- fuselage chord
- fuselage end position/transition start position (y)
%}

useMeters = false;

% In inches
wingspan = 9.95 * 12;
wingChord = 24;
fuselageArea = 1000; % in^3
NACA23012UnitArea = 0.0818122; % in^2 for 1" chord

fuselageLength = 36:4:60;
% taperPositionRatio = 1.0; % 1.0 means no taper, 0.0 mean all taper
% taperRatio = 1.0;
transitionWidth = 3:1.5:6;
transitionSetbackRatio = 0.4:0.2:1.0; % 0.0 means wing at front, 1.0 means wing at back

if useMeters
    wingspan = wingspan / 39.37;
    wingChord = wingChord / 39.37;
    fuselageArea = fuselageArea / 39.37 / 39.37 / 39.37;
    NACA23012UnitArea = NACA23012UnitArea / 39.37 / 39.37;
    fuselageLength = fuselageLength / 39.37;
    transitionWidth = transitionWidth / 39.37;
end

numRunCases = length(fuselageLength) * length(transitionWidth) * length(transitionSetbackRatio);
disp(strcat("Num run cases = ", string(numRunCases)));