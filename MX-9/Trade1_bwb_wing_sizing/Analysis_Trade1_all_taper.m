% Michael Chen - August 5, 2023
% This script generates plots to analyze Trade 2 for MX-9

%% Read data
n = 240;
dim4NumCases = 4;

[rc, st, ~] = extractData(n, "/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_Trade1/All_Taper", true, false);
rc = cell2mat(rc);
st = cell2mat(st);

%% Read CSV
% Display inches
% Make sure to convert static margin properly
parameters = readtable("/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_Trade1/MX-9_Trade1_all_taper_inches.csv");
parametersMeters = readtable("/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_Trade1/MX-9_Trade1_all_taper_meters.csv");

%% Plot AoA
AoA = [rc.alpha];

plot4D(parameters.fuselageLength, parameters.transitionWidth, parameters.taperRatio, parameters.transitionSetbackRatio, ...
    AoA, n, dim4NumCases, "Fuselage length", "Transition width", "Taper ratio", "Transition setback ratio", ...
    "AoA");

%% Plot AoA < 5
AoA = [rc.alpha];
AoA(AoA >= 5) = NaN;

plot4D(parameters.fuselageLength, parameters.transitionWidth, parameters.taperRatio, parameters.transitionSetbackRatio, ...
    AoA, n, dim4NumCases, "Fuselage length", "Transition width", "Taper ratio", "Transition setback ratio", ...
    "AoA");

%% Plot L/D with AoA < 5
AoA = [rc.alpha];

CL = [rc.CLtot];
CD = [rc.CDff];
LD = CL ./ CD;

LD(AoA >= 5) = NaN;

plot4D(parameters.fuselageLength, parameters.transitionWidth, parameters.taperRatio, parameters.transitionSetbackRatio, ...
    LD, n, dim4NumCases, "Fuselage length", "Transition width", "Taper ratio", "Transition setback ratio", ...
    "L/D");

%% Plot L/D with AoA < 5 and transition setback ratio of 1.0
AoA = [rc.alpha];

CL = [rc.CLtot];
CD = [rc.CDff];
LD = CL ./ CD;

LD(AoA >= 5 | parameters.transitionSetbackRatio' ~= 1.0) = NaN;

plot4D(parameters.fuselageLength, parameters.transitionWidth, parameters.taperRatio, parameters.transitionSetbackRatio, ...
    LD, n, dim4NumCases, "Fuselage length", "Transition width", "Taper ratio", "Transition setback ratio", ...
    "L/D");

%% Get max L/D data for constraints
AoA = [rc.alpha];
Cma = [st.Cma];

CL = [rc.CLtot];
CD = [rc.CDff];
LD = CL ./ CD;

LD(AoA >= 5 | parameters.transitionSetbackRatio' ~= 1.0) = NaN;

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