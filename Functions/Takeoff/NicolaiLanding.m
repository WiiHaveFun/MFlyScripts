% Use metric units

% Environmental conditions
g = 9.81; % Acceleration due to gravity (m/s^2)
rho = 1.14; % Air density (kg/m^3) PARAMETER

% Aircraft parameters
W = 14.9685*g; % Aircraft weight (N) PARAMETER
sref = 1.5652; % Wing reference area (m^2) PARAMETER
mu = 0.0275; % Rolling friction coefficient

% Aerodynamic parameters
CL_Max = 1.3805;
CL_Ground = 1.3644;
CD_Ground = 0.2854;

% Drag and lift
D = @(v, CD) 0.5 * rho * v^2 * sref * CD;
L = @(v, CL) 0.5 * rho * v^2 * sref * CL;

% Stall velocity and takeoff velocity
VStall = sqrt(2 * W / (sref * rho * CL_Max));
VTD = 1.15 * VStall;

% Parameters to iterate over
S = 0; % horizontal distance (m)
V = VTD; % velocity (m/s)
t = 0; % time elapsed (s)

dt = 0.01; % (s)

%% Approach
% From 50 feet

% theta_approach = deg2rad(9);
% 
% S_A = 15.24 / tan(theta_approach);

V50 = 1.3 * VStall;

S_A = W / D(VTD, CD_Ground) * ((V50^2 - VTD^2) / (2 * g) + 15.24);
%% Takeoff run
% Iterate from standstill, to takeoff velocity
% Early rotation when lift is greater than weight

while V > 0
    if(W - L(V, CL_Ground) > 0)
        a = (-D(V, CD_Ground) - (W - L(V, CL_Ground)) * mu) * (g / W);
    else
        a = (-D(V, CD_Ground)) * (g / W);
    end

    V = V + a * dt;
    S = S + V * dt;
    t = t + dt;
end

S_G = S;

%% Plots

x = [0, S_A, S_A+S_G];
y = [15.24, 0, 0];

plot(x*39.37/12, y*39.37/12, LineWidth=3);
hold on
scatter(x*39.37/12, y*39.37/12);
axis equal