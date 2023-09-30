%% Sizing Plot: Main Function
% M-Fly Aero design
% Made by
% 9/24/2023
close all;
clear;
clc;

W = 14.06.*9.81; % 31 lbs in Newtons
T = 47.6; % 10.7 lbs of thrust in Newtons, tested static thrust

rho = 1.14; % Air density in Florida (kg/m^3), average, do a worst case
CLmax = 1.7394; % CLmax of the aircraft from AVL
CDstall = .16509 + .02787.*4; % CD of the aircraft at stall AoA from AVL, quadruple CD0 to account for manufacturing errors
% Tcurve = @(v) 47.6 - 1.99 .* v - .0277 .* (v .^ 2); % Thrust as a function of velocity (N, velocity in m/s)
Tcurve = @(v) 52.6 - 1.71 .* v;
Sref = 1.4976; % Wing reference area in m2
WSstall = stall(rho, CLmax, CDstall, Tcurve, Sref);

WSvector = linspace(0, 300, 3001);
Vcruise = 12; % Cruise velocity in m/s 
CD0 = .01964.*4; % Parasitic drag
AR = 6.14; % Wing aspect ratio
e = .952; % Efficiency at cruise
TWcruise = cruise(Vcruise, rho, WSvector, CD0, AR, e);

ks = 1.2; % Ratio of the flight speed in the climb segment to the stall speed
CLclimb = CLmax./(ks.^2); % CL at climb
TWclimb = climb(CD0, AR, e, CLclimb, 8);

Vturn = Vcruise; % Depends on your desired turn radius
TWturn = maneuver(Vturn, rho, WSvector, CD0, AR, e, 40);

dTO = 121.92; % Length of runway in m, 400 ft for autonomous
TWtakeoff = takeoff(dTO, rho, WSvector, CLmax);

plot(WSvector, TWtakeoff)
hold on
plot(WSvector, TWturn)
plot(WSvector, TWcruise)
yline(TWclimb, 'm')
xline(WSstall, 'g')
scatter(W/Sref, T/W)
xlim([0 300])
ylim([0 .5])
legend("Takeoff", "Turn", "Cruise", "Climb", "Stall", "Design");
hold off