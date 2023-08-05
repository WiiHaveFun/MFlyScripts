% Michael Chen - August 5, 2023
% This script generates plots to analyze Trade 2 for MX-9

%% Read data
n = 960;
dim4NumCases = 3;
dim5NumCases = 4;

[rc, st, ~] = extractData(n, "/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_Trade1", true, false);
rc = cell2mat(rc);
st = cell2mat(st);

%% Read CSV
% Display inches
% Make sure to convert static margin properly
parameters = readtable("/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_Trade1/MX-9_Trade1_inches.csv");
parametersMeters = readtable("/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_Trade1/MX-9_Trade1_meters.csv");

%% Plot AoA
AoA = [rc.alpha];

plot5D(parameters.fuselageLength, parameters.taperPositionRatio, parameters.taperRatio, parameters.transitionWidth, parameters.transitionSetbackRatio, ...
    AoA, n, dim4NumCases, dim5NumCases, "Fuselage length", "Taper Position Ratio", "Taper ratio", "Transition width", "Transition setback ratio", ...
    "AoA");

%% Plot AoA < 5
AoA = [rc.alpha];
AoA(AoA >= 5) = NaN;

plot5D(parameters.fuselageLength, parameters.taperPositionRatio, parameters.taperRatio, parameters.transitionWidth, parameters.transitionSetbackRatio, ...
    AoA, n, dim4NumCases, dim5NumCases, "Fuselage length", "Taper Position Ratio", "Taper ratio", "Transition width", "Transition setback ratio", ...
    "AoA");

%% Plot L/D with AoA < 5
AoA = [rc.alpha];
AoA(AoA >= 5) = NaN;

CL = [rc.CLtot];
CD = [rc.CDff];
LD = CL ./ CD;

plot5D(parameters.fuselageLength, parameters.taperPositionRatio, parameters.taperRatio, parameters.transitionWidth, parameters.transitionSetbackRatio, ...
    LD, n, dim4NumCases, dim5NumCases, "Fuselage length", "Taper Position Ratio", "Taper ratio", "Transition width", "Transition setback ratio", ...
    "L/D");

%% Get max L/D data for constraints
AoA = [rc.alpha];
Cma = [st.Cma];

CL = [rc.CLtot];
CD = [rc.CDff];
LD = CL ./ CD;

LD(AoA >= 5) = NaN;

runCase = find(LD == max(LD));

CM = [rc.Cmtot];
e = [rc.e];
Xnp = [st.NP];

disp(strcat("CL = ", string(CL(runCase))));
disp(strcat("CD = ", string(CD(runCase))));
disp(strcat("CL/CD = ", string(LD(runCase))));
disp(strcat("CM = ", string(CM(runCase))));
disp(strcat("e = ", string(e(runCase))));
disp(strcat("Xnp = ", string(Xnp(runCase))));
% disp(strcat("static margin = ", string(staticMargin(runCase))));
disp(strcat("alpha = ", string(AoA(runCase))));

disp(parameters(runCase, :));
disp(parametersMeters(runCase, :));