% Michael Chen - July 23, 2023
% This script generates plots to analyze Trade 1 for QM-3

%% Read data
n1 = 225;
n2 = 75;

[rc, st, sf] = extractData(n1, "/Users/michaelchen/Documents/M-Fly/2023/QM-3/PADA_Trade1", true, true);
rc = cell2mat(rc);
st = cell2mat(st);

%% Read CSV
parameters = readtable("/Users/michaelchen/Documents/M-Fly/2023/QM-3/PADA_Trade1/QM-3_Trade1_2_meters.csv");

%% Check for stall
ClMax = 1.19288;

stallIndex = [];

for i = 1:n1
    stripForces = sf{i}(1).strip;
    stripForces = cell2mat(stripForces);

    if (any([stripForces.cl] > ClMax))
        stallIndex = [stallIndex, i];
        disp(strcat("case ", string(i), " is stalled."));
    end
end

%% Plot AoA
AoA = [rc.alpha];
t = tiledlayout(1,3);

for i = 1:n2:n1
    nexttile

    scatter3(parameters.rootChord(i:i + n2 - 1), parameters.bref(i:i + n2 - 1), parameters.taperRatio(i:i + n2 - 1), 100, AoA(i:i + n2 - 1), 'filled');
    view(-20,70)
    xlabel('Root chord')
    ylabel('Wing span')
    zlabel('Taper ratio')

    cb = colorbar;
    cb.Label.String = 'AoA';

    title(strcat("Sweep angle ", string(parameters.sweepAngle(i))));
end

%% Plot AoA < 8
AoA = [rc.alpha];
AoA(AoA >= 8) = NaN;
t = tiledlayout(1,3);

for i = 1:n2:n1
    nexttile

    scatter3(parameters.rootChord(i:i + n2 - 1), parameters.bref(i:i + n2 - 1), parameters.taperRatio(i:i + n2 - 1), 100, AoA(i:i + n2 - 1), 'filled');
    view(-20,70)
    xlabel('Root chord')
    ylabel('Wing span')
    zlabel('Taper ratio')

    cb = colorbar;
    cb.Label.String = 'AoA';

    title(strcat("Sweep angle ", string(parameters.sweepAngle(i))));
end

%% Plot CL/CD with AoA < 8 and statically stable
AoA = [rc.alpha];
Cma = [st.Cma];

CL = [rc.CLtot];
CD = [rc.CDind];
LD = CL ./ CD;

LD(AoA >= 8 | Cma >= 0) = NaN;

t = tiledlayout(1,3);

colormap jet

for i = 1:n2:n1
    nexttile

    scatter3(parameters.rootChord(i:i + n2 - 1), parameters.bref(i:i + n2 - 1), parameters.taperRatio(i:i + n2 - 1), 100, LD(i:i + n2 - 1), 'filled');
    view(-20,70)
    xlabel('Root chord')
    ylabel('Wing span')
    zlabel('Taper ratio')

    cb = colorbar;
    cb.Label.String = 'L/D ratio';

    title(strcat("Sweep angle ", string(parameters.sweepAngle(i))));
end

%% Plot static margin with AoA < 8 and statically stable
AoA = [rc.alpha];
Cma = [st.Cma];

x_cg = 0.1092; % 4.3 in 

staticMargin = ([st.NP] - x_cg) ./ parameters.cref' .* 100;

staticMargin(AoA >= 8 | Cma >= 0) = NaN;

t = tiledlayout(1,3);

colormap jet

for i = 1:n2:n1
    nexttile

    scatter3(parameters.rootChord(i:i + n2 - 1), parameters.bref(i:i + n2 - 1), parameters.taperRatio(i:i + n2 - 1), 100, staticMargin(i:i + n2 - 1), 'filled');
    view(-20,70)
    xlabel('Root chord')
    ylabel('Wing span')
    zlabel('Taper ratio')

    cb = colorbar;
    cb.Label.String = 'Static margin';

    title(strcat("Sweep angle ", string(parameters.sweepAngle(i))));
end

%% Plot L/D with AoA < 8, statically stable, and with static margin between 10-15%
AoA = [rc.alpha];
Cma = [st.Cma];

CL = [rc.CLtot];
CD = [rc.CDind];
LD = CL ./ CD;

x_cg = 0.1092; % 4.3 in 

staticMargin = ([st.NP] - x_cg) ./ parameters.cref' .* 100;

LD(AoA >= 8 | Cma >= 0 | staticMargin < 10 | staticMargin > 15) = NaN;

t = tiledlayout(1,3);

colormap jet

for i = 1:n2:n1
    nexttile

    scatter3(parameters.rootChord(i:i + n2 - 1), parameters.bref(i:i + n2 - 1), parameters.taperRatio(i:i + n2 - 1), 100, LD(i:i + n2 - 1), 'filled');
    view(-20,70)
    xlabel('Root chord')
    ylabel('Wing span')
    zlabel('Taper ratio')

    cb = colorbar;
    cb.Label.String = 'L/D ratio';

    title(strcat("Sweep angle ", string(parameters.sweepAngle(i))));
end

%% Get max L/D data for constraints
AoA = [rc.alpha];
Cma = [st.Cma];

CL = [rc.CLtot];
CD = [rc.CDind];
LD = CL ./ CD;

x_cg = 0.1092; % 4.3 in 

staticMargin = ([st.NP] - x_cg) ./ parameters.cref' .* 100;

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