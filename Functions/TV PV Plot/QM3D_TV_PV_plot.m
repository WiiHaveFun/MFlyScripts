%% Aircraft parameters and atmosphere

S = 0.1068; % m^2
W = 1 * 4.44822; % lbf to N

bankAngle = deg2rad(60); % deg to rad
climbAngle = deg2rad(-15); % deg to rad

rho = 1.14; % kg/m^3

%% Import drag polar and thrust curve

% Drag polars
polar_CFD_QM = readtable("/Users/michaelchen/Documents/M-Fly/2023/CFD/Polars/Scaled/QM-3D_drag_polar_scaled.csv");
alpha_CFD_QM = polar_CFD_QM.alpha(6:end);
CD_CFD_QM = polar_CFD_QM.CD(6:end);
CL_CFD_QM = polar_CFD_QM.CL(6:end);

% Propulsion parameters
T = @(v) (3.63 - 0.0694 * v - 5.11e-4 * v.^2);
%% Run

n = 1 / cos(bankAngle);

[V_cruise, T_cruise] = getThrustRequired(CL_CFD_QM, CD_CFD_QM, S, W, rho, 0);
[V_turn, T_turn] = getThrustRequired(CL_CFD_QM, CD_CFD_QM, S, W*n, rho, 0);
[V_climb, T_climb] = getThrustRequired(CL_CFD_QM, CD_CFD_QM, S, W, rho, climbAngle);

%% Plot
figure(3);
plot(V_cruise, T_cruise);
hold on;
plot(V_turn, T_turn);
plot(V_climb, T_climb);
plot(0:0.1:40, T(0:0.1:40));
xlim([0, 25]);
ylim([0, 4]);
legend("Cruise", "Turn", "Climb", "Thrust Available");

figure(4);
plot(V_cruise, V_cruise.*T_cruise);
hold on;
plot(V_turn, V_turn.*T_turn);
plot(V_climb, V_climb.*T_climb);
plot(0:0.1:40, (0:0.1:40).*T(0:0.1:40));
xlim([0, 25]);
ylim([0, 50]);
legend("Cruise", "Turn", "Climb", "Thrust Available");

%% Function

function [velocity, thrustRequired] = getThrustRequired(CL, CD, sref, W, rho, gamma)
    velocity = sqrt(2 .* W ./ (rho .* sref .* CL));
    thrustRequired = 0.5 .* rho .* velocity.^2 .* sref .* CD;
    
    % Modify thrust for steady climb
    thrustRequired = thrustRequired + W .* sin(gamma);
end