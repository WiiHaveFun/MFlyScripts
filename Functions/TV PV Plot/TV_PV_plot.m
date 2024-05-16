%% Aircraft parameters and atmosphere

S = 1.5652; % m^2
W = 23 * 4.44822; % lbf to N

bankAngle = deg2rad(40); % deg to rad
climbAngle = deg2rad(5); % deg to rad

rho = 1.14; % kg/m^3

%% Import drag polar and thrust curve

% Drag polars
polar_CFD_MX = readtable("/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/Scaled/MX-9D_drag_polar_scaled.csv");
% polar_CFD_MX = readtable("/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/CFD Polars for MX-9 and QM-3 - MX-9D.csv");
% polar_CFD_MX = readtable("/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/Scaled/factor2/MX-9D/MX-9D_drag_polar_scaled.csv");
alpha_CFD_MX = polar_CFD_MX.alpha;
CD_CFD_MX = polar_CFD_MX.CD;
CL_CFD_MX = polar_CFD_MX.CL;

% Curve fit (bad)
% y = @(x) 2.5*0.0136119 + 0.0815117 .* x.^2 + 0.0945747 .* (x - 1).^2;
% CD_CFD_MX = y(CL_CFD_MX);

% Propulsion parameters
T = @(v) (50.9 - 1.0 * v - 0.0344 * v.^2) * (rho / 1.254).^(1/3);
%% Run

n = 1 / cos(bankAngle);

[V_cruise, T_cruise] = getThrustRequired(CL_CFD_MX, CD_CFD_MX, S, W, rho, 0);
[V_turn, T_turn] = getThrustRequired(CL_CFD_MX, CD_CFD_MX, S, W*n, rho, 0);
[V_climb, T_climb] = getThrustRequired(CL_CFD_MX, CD_CFD_MX, S, W, rho, climbAngle);

%% Plot
figure(3);
plot(V_cruise, T_cruise);
hold on;
plot(V_turn, T_turn);
plot(V_climb, T_climb);
plot(0:0.1:20, T(0:0.1:20));
xlim([0, 20]);
ylim([0, 100]);
legend("Cruise", "Turn", "Climb", "Thrust Available");

figure(4);
plot(V_cruise, V_cruise.*T_cruise);
hold on;
plot(V_turn, V_turn.*T_turn);
plot(V_climb, V_climb.*T_climb);
plot(0:0.1:20, (0:0.1:20).*T(0:0.1:20));
xlim([0, 20]);
ylim([0, 1000]);
legend("Cruise", "Turn", "Climb", "Thrust Available");

%% Function

function [velocity, thrustRequired] = getThrustRequired(CL, CD, sref, W, rho, gamma)
    velocity = sqrt(2 .* W ./ (rho .* sref .* CL));
    thrustRequired = 0.5 .* rho .* velocity.^2 .* sref .* CD;
    
    % Modify thrust for steady climb
    thrustRequired = thrustRequired + W .* sin(gamma);
end