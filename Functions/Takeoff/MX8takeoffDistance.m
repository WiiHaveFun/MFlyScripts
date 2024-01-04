% Metric units, also make sure you have MATLAB Symbolic math installed
clear
close all

syms v
g = 9.81; % m/s2
W = 14.9685*g; % MTOW, 33 lbs
rho = 1.14; % Estimated air density kg/m3

% Dynamic thrust data
a = -0.0344; 
b = -1.0;
c = 50.9;
% thrustCurve = @(v) (50.9 - 1.0 * v - 0.0344 * v.^2) * (rho / 1.254).^(1/3);
T = a*v^2 + b*v + c; % Total Thrust

% Drag
CDo = .0964; % Universally accepted values for parasitic drag coefficient, good to run CFD for your plane to get actual value (MX8 was probably closer to .032)
CL = 0.5699; % CL               AoA = 0: 1.0493 AoA = 6: 1.5522
e = .9508; % Efficiency         AoA = 0: .8976  AoA = 6: .9682
Sref = 1.5652; % Wing area in m2
b = 3.0328; % Wingspan in m2
AR = (b^2)/Sref; % Aspect Ratio
K = 1./(pi.*AR.*e); % Induced drag factor
CD = CDo+K*CL^2; % Drag coefficient 
D = .5*rho*Sref*CD*v^2; % Total Drag

% Friction
L = .5*rho*Sref*CL*v^2;
mu = 0.0275; % Friction coefficient for a concrete runway (Estimated from Nicolai Table 10.3) 
Ff = mu*(W-L); % Total friction force

% Calculations
accel = (g/W)*(T-D-Ff);
Vstall = 10.919; % Stall speed
Vto = 1.1*Vstall; % Takeoff speed
Sg = int(v/accel, v, 0, Vto); % Total takeoff distance calculation

Sg = vpa(Sg, 3);
Sg = double(Sg);
Sgft = Sg*3.28084;

X = sprintf('The takeoff distance is %s m or %s ft', num2str(Sg), num2str(Sgft));
disp(X);




