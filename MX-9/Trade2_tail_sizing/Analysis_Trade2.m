% Michael Chen - August 6, 2023
% This script generates plots to analyze Trade 2 for MX-9

%% Read data
n = 900;
dim4NumCases = 4;
dim5NumCases = 3;

[rc, st, ~] = extractData(n, "/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_Trade2/TailUpAnInch", true, false);
rc = cell2mat(rc);
st = cell2mat(st);

%% Read CSV
% Display inches
% Make sure to convert static margin properly
parameters = readtable("/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_Trade2/MX-9_Trade2_inches.csv");
parametersMeters = readtable("/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_Trade2/MX-9_Trade2_meters.csv");

%% Plot AoA
AoA = [rc.alpha];

plot5D(parameters.transitionSetbackRatio, parameters.cgPositionRatio, parameters.hTailAR, parameters.hTailLength, parameters.hTailCoeff, ...
    AoA, n, dim4NumCases, dim5NumCases, "Transition setback ratio", "CG position ratio", "Tail AR", "Tail length", "Tail coeff", ...
    "AoA");

%% Plot elevator deflection 
elevatorSurf = [rc.surface];
elevatorAngle = [elevatorSurf.angle];

plot5D(parameters.transitionSetbackRatio, parameters.cgPositionRatio, parameters.hTailAR, parameters.hTailLength, parameters.hTailCoeff, ...
    elevatorAngle, n, dim4NumCases, dim5NumCases, "Transition setback ratio", "CG position ratio", "Tail AR", "Tail length", "Tail coeff", ...
    "Elevator angle");

%% Plot AoA < 6
AoA = [rc.alpha];
AoA(AoA >= 6) = NaN;

plot5D(parameters.transitionSetbackRatio, parameters.cgPositionRatio, parameters.hTailAR, parameters.hTailLength, parameters.hTailCoeff, ...
    AoA, n, dim4NumCases, dim5NumCases, "Transition setback ratio", "CG position ratio", "Tail AR", "Tail length", "Tail coeff", ...
    "AoA");

%% Plot elevator deflection with AoA < 6
AoA = [rc.alpha];

elevatorSurf = [rc.surface];
elevatorAngle = [elevatorSurf.angle];
elevatorAngle(AoA >= 6) = NaN;

plot5D(parameters.transitionSetbackRatio, parameters.cgPositionRatio, parameters.hTailAR, parameters.hTailLength, parameters.hTailCoeff, ...
    elevatorAngle, n, dim4NumCases, dim5NumCases, "Transition setback ratio", "CG position ratio", "Tail AR", "Tail length", "Tail coeff", ...
    "Elevator angle");

%% Plot elevator deflection with AoA < 6 and elevator < 15 deg
AoA = [rc.alpha];

elevatorSurf = [rc.surface];
elevatorAngle = [elevatorSurf.angle];
elevatorAngle(AoA >= 6 | elevatorAngle >= 15) = NaN;

plot5D(parameters.transitionSetbackRatio, parameters.cgPositionRatio, parameters.hTailAR, parameters.hTailLength, parameters.hTailCoeff, ...
    elevatorAngle, n, dim4NumCases, dim5NumCases, "Transition setback ratio", "CG position ratio", "Tail AR", "Tail length", "Tail coeff", ...
    "Elevator angle");
%% Plot L/D with AoA < 6 and elevator < 15 deg and statically stable
AoA = [rc.alpha];
Cma = [st.Cma];

elevatorSurf = [rc.surface];
elevatorAngle = [elevatorSurf.angle];

CL = [rc.CLtot];
CD = [rc.CDff];
LD = CL ./ CD;

LD(AoA >= 6 | elevatorAngle >= 15 | Cma >= 0) = NaN;

plot5D(parameters.transitionSetbackRatio, parameters.cgPositionRatio, parameters.hTailAR, parameters.hTailLength, parameters.hTailCoeff, ...
    LD, n, dim4NumCases, dim5NumCases, "Transition setback ratio", "CG position ratio", "Tail AR", "Tail length", "Tail coeff", ...
    "L/D");

%% Plot static margin < 25 with AoA < 6 and elevator < 15 deg and statically stable
AoA = [rc.alpha];
Cma = [st.Cma];

elevatorSurf = [rc.surface];
elevatorAngle = [elevatorSurf.angle];

crefMeters = 0.6033;
x_cg = parameters.cgPositionX ./ 39.37;

staticMargin = ([st.NP] - x_cg') ./ crefMeters .* 100;

staticMargin(AoA >= 8 | elevatorAngle >= 15 | Cma >= 0 | staticMargin >= 25) = NaN;

plot5D(parameters.transitionSetbackRatio, parameters.cgPositionRatio, parameters.hTailAR, parameters.hTailLength, parameters.hTailCoeff, ...
    staticMargin, n, dim4NumCases, dim5NumCases, "Transition setback ratio", "CG position ratio", "Tail AR", "Tail length", "Tail coeff", ...
    "Static margin");

%% Plot L/D with static margin < 25 with AoA < 6 and elevator < 15 deg and statically stable
AoA = [rc.alpha];
Cma = [st.Cma];

elevatorSurf = [rc.surface];
elevatorAngle = [elevatorSurf.angle];

CL = [rc.CLtot];
CD = [rc.CDff];
LD = CL ./ CD;

crefMeters = 0.6033;
x_cg = parameters.cgPositionX ./ 39.37;

staticMargin = ([st.NP] - x_cg') ./ crefMeters .* 100;

LD(AoA >= 8 | elevatorAngle >= 15 | Cma >= 0 | staticMargin >= 25) = NaN;

plot5D(parameters.transitionSetbackRatio, parameters.cgPositionRatio, parameters.hTailAR, parameters.hTailLength, parameters.hTailCoeff, ...
    LD, n, dim4NumCases, dim5NumCases, "Transition setback ratio", "CG position ratio", "Tail AR", "Tail length", "Tail coeff", ...
    "L/D");

%% Get max L/D data for constraints
AoA = [rc.alpha];
Cma = [st.Cma];

elevatorSurf = [rc.surface];
elevatorAngle = [elevatorSurf.angle];

CL = [rc.CLtot];
CD = [rc.CDff];
LD = CL ./ CD;

crefMeters = 0.6033;
x_cg = parameters.cgPositionX ./ 39.37;

staticMargin = ([st.NP] - x_cg') ./ crefMeters .* 100;

LD(AoA >= 8 | elevatorAngle >= 15 | Cma >= 0 | staticMargin >= 25) = NaN;

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
disp(strcat("elevator = ", string(elevatorAngle(runCase))));

disp(parameters(runCase, :));
disp(parametersMeters(runCase, :));