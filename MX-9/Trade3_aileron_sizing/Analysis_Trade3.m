% Michael Chen - September 22, 2023
% This script generates plots to analyze Trade 3 for MX-9

%% Read data
n = 160;

[rc, st, ~] = extractData(n, "/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_Trade3/StraightHinge/25", true, false);
rc = cell2mat(rc);
st = cell2mat(st);

%% Read CSV
% Display inches
% Make sure to convert static margin properly
parameters = readtable("/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_Trade3/MX-9_Trade3_inches.csv");

%% Plot AoA
AoA = [rc.alpha];

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, AoA, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "AoA");

%% Plot elevator deflection 
surfaces = [rc.surface];
elevatorSurf = surfaces({surfaces.name} == "Elevator");
elevatorAngle = [elevatorSurf.angle];

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, elevatorAngle, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "Elevator Angle");

%% Plot aileron deflection 
surfaces = [rc.surface];
aileronSurf = surfaces({surfaces.name} == "Aileron");
aileronAngle = [aileronSurf.angle];

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, aileronAngle, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "Aileron Angle");

%% Plot rudder deflection 
surfaces = [rc.surface];
rudderSurf = surfaces({surfaces.name} == "Rudder");
rudderAngle = [rudderSurf.angle];

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, rudderAngle, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "Rudder Angle");

%% Plot AoA < 5
AoA = [rc.alpha];
AoA(AoA >= 5) = NaN;

plot4D(parameters.transitionSetbackRatio, parameters.hTailLength, parameters.taperRatio, parameters.hTailCoeff, ...
    AoA, n, dim4NumCases, "Transition setback ratio", "Tail length", "Taper ratio", "Tail coeff", ...
    "AoA");

%% Plot elevator deflection with AoA < 5
AoA = [rc.alpha];

elevatorSurf = [rc.surface];
elevatorAngle = [elevatorSurf.angle];
elevatorAngle(AoA >= 5) = NaN;

plot4D(parameters.transitionSetbackRatio, parameters.hTailLength, parameters.taperRatio, parameters.hTailCoeff, ...
    elevatorAngle, n, dim4NumCases, "Transition setback ratio", "Tail length", "Taper ratio", "Tail coeff", ...
    "Elevator angle");

%% Plot elevator deflection with AoA < 5 and elevator < 15 deg
AoA = [rc.alpha];

elevatorSurf = [rc.surface];
elevatorAngle = [elevatorSurf.angle];
elevatorAngle(AoA >= 5 | elevatorAngle >= 15) = NaN;

plot4D(parameters.transitionSetbackRatio, parameters.hTailLength, parameters.taperRatio, parameters.hTailCoeff, ...
    elevatorAngle, n, dim4NumCases, "Transition setback ratio", "Tail length", "Taper ratio", "Tail coeff", ...
    "Elevator angle");

%% Plot L/D with AoA < 5 and elevator < 15 deg and statically stable
AoA = [rc.alpha];
Cma = [st.Cma];

elevatorSurf = [rc.surface];
elevatorAngle = [elevatorSurf.angle];

CL = [rc.CLtot];
CD = [rc.CDff];
LD = CL ./ CD;

LD(AoA >= 5 | elevatorAngle >= 15 | Cma >= 0) = NaN;

plot4D(parameters.transitionSetbackRatio, parameters.hTailLength, parameters.taperRatio, parameters.hTailCoeff, ...
    LD, n, dim4NumCases, "Transition setback ratio", "Tail length", "Taper ratio", "Tail coeff", ...
    "L/D");

%% Plot static margin < 25 with AoA < 5 and elevator < 15 deg and statically stable
AoA = [rc.alpha];
Cma = [st.Cma];

elevatorSurf = [rc.surface];
elevatorAngle = [elevatorSurf.angle];

crefMeters = parameters.cref ./ 39.37;
x_cg = parameters.cgPositionX ./ 39.37;

staticMargin = ([st.NP] - x_cg') ./ crefMeters' .* 100;

staticMargin(AoA >= 5 | elevatorAngle >= 15 | Cma >= 0 | staticMargin >= 25) = NaN;

plot4D(parameters.transitionSetbackRatio, parameters.hTailLength, parameters.taperRatio, parameters.hTailCoeff, ...
    staticMargin, n, dim4NumCases, "Transition setback ratio", "Tail length", "Taper ratio", "Tail coeff", ...
    "staticMargin");

%% Plot L/D with static margin < 25 with AoA < 6 and elevator < 15 deg and statically stable
AoA = [rc.alpha];
Cma = [st.Cma];

elevatorSurf = [rc.surface];
elevatorAngle = [elevatorSurf.angle];

CL = [rc.CLtot];
CD = [rc.CDff];
LD = CL ./ CD;

crefMeters = parameters.cref ./ 39.37;
x_cg = parameters.cgPositionX ./ 39.37;

staticMargin = ([st.NP] - x_cg') ./ crefMeters' .* 100;

LD(AoA >= 5 | elevatorAngle >= 15 | Cma >= 0 | staticMargin >= 25) = NaN;

plot4D(parameters.transitionSetbackRatio, parameters.hTailLength, parameters.taperRatio, parameters.hTailCoeff, ...
    LD, n, dim4NumCases, "Transition setback ratio", "Tail length", "Taper ratio", "Tail coeff", ...
    "L/D");

%% Get max L/D data for constraints
AoA = [rc.alpha];
Cma = [st.Cma];

elevatorSurf = [rc.surface];
elevatorAngle = [elevatorSurf.angle];

CL = [rc.CLtot];
CD = [rc.CDff];
LD = CL ./ CD;

crefMeters = parameters.cref ./ 39.37;
x_cg = parameters.cgPositionX ./ 39.37;

staticMargin = ([st.NP] - x_cg') ./ crefMeters' .* 100;

LD(AoA >= 5 | elevatorAngle >= 15 | Cma >= 0 | staticMargin >= 25) = NaN;

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