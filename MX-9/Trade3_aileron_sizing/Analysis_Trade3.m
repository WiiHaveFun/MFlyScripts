% Michael Chen - September 22, 2023
% This script generates plots to analyze Trade 3 for MX-9

%% Read data
n = 160;

[rc, st, ~] = extractData(n, "/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_Trade3/StraightHinge/25", true, false);
rc = cell2mat(rc);
st = cell2mat(st);

[rc2, st2, ~] = extractData(n, "/Users/michaelchen/Documents/M-Fly/2023/MX-9/PA_Trade3/ConstantChordHinge/25", true, false);
rc2 = cell2mat(rc2);
st2 = cell2mat(st2);

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

surfaces2 = [rc2.surface];
aileronSurf2 = surfaces2({surfaces2.name} == "Aileron");
aileronAngle2 = [aileronSurf2.angle];

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, aileronAngle, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "Aileron Angle");

hold on

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, aileronAngle2, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "Aileron Angle");

hold off

%% Plot rudder deflection 
surfaces = [rc.surface];
rudderSurf = surfaces({surfaces.name} == "Rudder");
rudderAngle = [rudderSurf.angle];

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, rudderAngle, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "Rudder Angle");

%% Plot aileron deflection with elevator deflection < 15
surfaces = [rc.surface];

aileronSurf = surfaces({surfaces.name} == "Aileron");
aileronAngle = [aileronSurf.angle];

elevatorSurf = surfaces({surfaces.name} == "Elevator");
elevatorAngle = [elevatorSurf.angle];

rudderSurf = surfaces({surfaces.name} == "Rudder");
rudderAngle = [rudderSurf.angle];

aileronAngle(elevatorAngle > 15) = NaN;

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, aileronAngle, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "Aileron Angle");

%% Plot straight hinge area
surfaces = [rc.surface];
elevatorSurf = surfaces({surfaces.name} == "Elevator");
elevatorAngle = [elevatorSurf.angle];

straightHingeArea = [parameters.totalAileronAreaStraight];

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, straightHingeArea, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "Straight Hinge Area");

%% Plot constant chord hinge area
surfaces = [rc.surface];
elevatorSurf = surfaces({surfaces.name} == "Elevator");
elevatorAngle = [elevatorSurf.angle];

constantChordHingeArea = [parameters.totalAileronAreaConstant];

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, constantChordHingeArea, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "Constant Chord Hinge Area");

%% Plot straight hinge aileron minus constant hinge aileron
surfaces = [rc.surface];
aileronSurf = surfaces({surfaces.name} == "Aileron");
aileronAngle = [aileronSurf.angle];

surfaces2 = [rc2.surface];
aileronSurf2 = surfaces2({surfaces2.name} == "Aileron");
aileronAngle2 = [aileronSurf2.angle];

aileronDiff = aileronAngle - aileronAngle2;

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, aileronDiff, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "Straight hinge aileron - constant hinge aileron");

%% Plot spanwise efficiency
efficiency = [rc.e];
efficiency2 = [rc2.e];

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, efficiency, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "e");

hold on

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, efficiency2, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "e");

hold off

%% Plot area divided by deflection
surfaces = [rc.surface];
aileronSurf = surfaces({surfaces.name} == "Aileron");
aileronAngle = [aileronSurf.angle];

surfaces2 = [rc2.surface];
aileronSurf2 = surfaces2({surfaces2.name} == "Aileron");
aileronAngle2 = [aileronSurf2.angle];

straightHingeArea = [parameters.totalAileronAreaStraight]';
constantChordHingeArea = [parameters.totalAileronAreaConstant]';

score = (straightHingeArea / max(straightHingeArea)) .* (aileronAngle / max(aileronAngle2));
score2 = (constantChordHingeArea / max(straightHingeArea)) .* (aileronAngle2 / max(aileronAngle2));

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, score, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "score");

hold on

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, score2, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "score");

hold off

%% Plot far field drag
drag = [rc.CDff];
drag2 = [rc2.CDff];

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, drag, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "CDi");

hold on

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, drag2, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "CDi");

hold off

%% Plot L/D
CL = [rc.CLtot];
CD = [rc.CDff];
LD = CL./CD;

CL2 = [rc2.CLtot];
CD2 = [rc2.CDff];
LD2 = CL2./CD2;

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, LD, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "L/D");

hold on

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, LD2, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "L/D");

hold off

%% Plot aileron deflection for 0.43 aileron span / wingspan
surfaces = [rc.surface];
aileronSurf = surfaces({surfaces.name} == "Aileron");
aileronAngle = [aileronSurf.angle];

surfaces2 = [rc2.surface];
aileronSurf2 = surfaces2({surfaces2.name} == "Aileron");
aileronAngle2 = [aileronSurf2.angle];

aSpanPerWS = parameters.aileronSpanPerWingspan;

aileronAngle(aSpanPerWS ~= 0.35) = NaN;
aileronAngle2(aSpanPerWS ~= 0.35) = NaN;

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, aileronAngle, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "Aileron deflection");

hold on

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, aileronAngle2, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "Aileron deflection");

hold off

%% Plot L/D deflection for 0.43 aileron span / wingspan
CL = [rc.CLtot];
CD = [rc.CDff];
LD = CL./CD;

CL2 = [rc2.CLtot];
CD2 = [rc2.CDff];
LD2 = CL2./CD2;

aSpanPerWS = parameters.aileronSpanPerWingspan;

LD(aSpanPerWS ~= 0.35) = NaN;
LD2(aSpanPerWS ~= 0.35) = NaN;

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, LD, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "L/D");

hold on

plot2D(parameters.aileronSpanPerWingspan, parameters.aileronChordPerWingChord, LD2, ...
    "Total Aileron Span / Wingspan", "Aileron End Chord / Wing Chord", "L/D");

hold off
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

%% Decision is go with Raymer. 40% span and 25% chord looks about the right size, with relatively small deflections.