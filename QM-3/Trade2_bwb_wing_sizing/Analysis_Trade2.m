% Michael Chen - July 30, 2023
% This script generates plots to analyze Trade 2 for QM-3

%% Read data
n1 = 400;
n2 = 100;

[rc, st, sf] = extractData(n1, "/Users/michaelchen/Documents/M-Fly/2023/QM-3/PADA_Trade2/Modified CLAF");
rc = cell2mat(rc);
st = cell2mat(st);

%% Read CSV
% Display inches
% Make sure to convert static margin properly
parameters = readtable("/Users/michaelchen/Documents/M-Fly/2023/QM-3/PADA_Trade2/QM-3_Trade2_inches.csv");
parametersMeters = readtable("/Users/michaelchen/Documents/M-Fly/2023/QM-3/PADA_Trade2/QM-3_Trade2_meters.csv");

%% Check for stall
fuselageClMax = 1.25882;
wingClMax = 1.19288;

fuselageStall = checkForStall(sf, n1, 1, fuselageClMax);
wingStall = checkForStall(sf, n1, 5, wingClMax);

%% Plot AoA
AoA = [rc.alpha];

plot4D(parameters.sweepAngle, parameters.bref, parameters.taperRatio, parameters.transitionWidth, AoA, n1, n2, ...
    "Sweep angle", "Wing span", "Taper ratio", "Transition width", "AoA");

%% Plot AoA < 8
AoA = [rc.alpha];
AoA(AoA >= 8) = NaN;

plot4D(parameters.sweepAngle, parameters.bref, parameters.taperRatio, parameters.transitionWidth, AoA, n1, n2, ...
    "Sweep angle", "Wing span", "Taper ratio", "Transition width", "AoA");

%% Plot CL/CD with AoA < 8 and statically stable
AoA = [rc.alpha];
Cma = [st.Cma];

CL = [rc.CLtot];
CD = [rc.CDff];
LD = CL ./ CD;

LD(AoA >= 8 | Cma >= 0) = NaN;

plot4D(parameters.sweepAngle, parameters.bref, parameters.taperRatio, parameters.transitionWidth, LD, n1, n2, ...
    "Sweep angle", "Wing span", "Taper ratio", "Transition width", "L/D");

%% Plot static margin with AoA < 8 and statically stable
AoA = [rc.alpha];
Cma = [st.Cma];

crefMeters = parameters.cref ./ 39.37;
x_cg = 0.1092; % 4.3 in 

staticMargin = ([st.NP] - x_cg) ./ crefMeters' .* 100;

staticMargin(AoA >= 8 | Cma >= 0) = NaN;

plot4D(parameters.sweepAngle, parameters.bref, parameters.taperRatio, parameters.transitionWidth, staticMargin, n1, n2, ...
    "Sweep angle", "Wing span", "Taper ratio", "Transition width", "Static margin");

%% Plot L/D with AoA < 8, statically stable, and with static margin between 10-15%
AoA = [rc.alpha];
Cma = [st.Cma];

CL = [rc.CLtot];
CD = [rc.CDff];
LD = CL ./ CD;

crefMeters = parameters.cref ./ 39.37;
x_cg = 0.1092; % 4.3 in 

staticMargin = ([st.NP] - x_cg) ./ crefMeters' .* 100;

LD(AoA >= 8 | Cma >= 0 | staticMargin < 10 | staticMargin > 15) = NaN;

plot4D(parameters.sweepAngle, parameters.bref, parameters.taperRatio, parameters.transitionWidth, LD, n1, n2, ...
    "Sweep angle", "Wing span", "Taper ratio", "Transition width", "L/D");

%% Get max L/D data for constraints
AoA = [rc.alpha];
Cma = [st.Cma];

CL = [rc.CLtot];
CD = [rc.CDff];
LD = CL ./ CD;

crefMeters = parameters.cref ./ 39.37;
x_cg = 0.1092; % 4.3 in 

staticMargin = ([st.NP] - x_cg) ./ crefMeters' .* 100;

LD(AoA >= 8 | Cma >= 0 | staticMargin < 10 | staticMargin > 15) = NaN;

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
disp(strcat("static margin = ", string(staticMargin(runCase))));
disp(strcat("alpha = ", string(AoA(runCase))));

disp(parameters(runCase, :));
disp(parametersMeters(runCase, :));