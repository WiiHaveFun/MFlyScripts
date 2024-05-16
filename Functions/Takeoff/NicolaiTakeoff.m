% Use metric units

% Environmental conditions
g = 9.81; % Acceleration due to gravity (m/s^2)
rho = 1.14; % Air density (kg/m^3) PARAMETER

% Aircraft parameters
% W = 14.9685*g; % Aircraft weight (N) PARAMETER
W = 33 * 4.44822; % lbf to N
sref = 1.5652; % Wing reference area (m^2) PARAMETER
mu = 0.0275; % Rolling friction coefficient

% Propulsion parameters
T = @(v) (50.9 - 1.0 * v - 0.0344 * v.^2) * (rho / 1.254).^(1/3);

% Aerodynamic parameters
CL_Max = 1.3805;
alpha_Ground = deg2rad(12.8);
CL_Ground = 1.3644;
CD_Ground = 0.2854;
% CD_Ground = 0.1759;
alpha_Rotate = deg2rad(7.5620);
CL_Rotate = 0.8 * CL_Max;
CD_Rotate = 0.1830;
% CD_Rotate = 0.1135;

% Drag and lift
D = @(v, CD) 0.5 * rho * v^2 * sref * CD;
L = @(v, CL) 0.5 * rho * v^2 * sref * CL;

% Stall velocity and takeoff velocity
VStall = sqrt(2 * W / (sref * rho * CL_Max));
VTO = 1.1 * VStall;

% Climb parameters
theta_climb = deg2rad(5); % rad
h_cruise = 150 * 12 / 39.37;

% Parameters to iterate over
S = 0; % horizontal distance (m)
h = 0; % vertical height (m)
V = 0; % velocity (m/s)
t = 0; % time elapsed (s)

dt = 0.01; % (s)

%% Takeoff run
% Iterate from standstill, to takeoff velocity
% Early rotation when lift is greater than weight

while V < VTO
    a = (T(V)*cos(alpha_Ground) - D(V, CD_Ground) - (W - L(V, CL_Ground) - T(V)*sin(alpha_Ground)) * mu) * (g / W);

    V = V + a * dt;
    S = S + V * dt;
    t = t + dt;

    if (W - L(V, CL_Ground) - T(V)*sin(alpha_Ground) < 0)
        disp("Early Rotation");
        break;
    end
end

S_G = S;

%% Rotation
% Assume instantaneous rotation
% Assume aircraft stays on the ground
% Finish when reaching takeoff velocity

t_rotation = t;

while V < VTO
    a = (T(V)*cos(alpha_Rotate) - D(V, CD_Rotate) - (W - L(V, CL_Rotate) - T(V)*sin(alpha_Rotate)) * mu) * (g / W);

    V = V + a * dt;
    S = S + V * dt;
    t = t + dt;
end

S_R = S - S_G;

%% Transition
% Constant velocity arc

R = V^2 / (0.15 * g);
S_TR = R * sin(theta_climb);
h_TR = S_TR * tan(theta_climb);

%% Climb
% Constant velocity climb to cruise altitude

S_CL = (h_cruise - h_TR) / tan(theta_climb);

t_TR = (S_TR + (S_CL / cos(theta_climb))) / V;

%% Plots

x = [0, S_G, S_G+S_R, S_G+S_R+S_TR, S_G+S_R+S_TR+S_CL];
y = [0, 0, 0, h_TR, h_cruise];

plot(x*39.37/12, y*39.37/12, LineWidth=3);
hold on
scatter(x*39.37/12, y*39.37/12);
axis equal