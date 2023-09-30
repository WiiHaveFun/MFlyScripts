%% Sizing Plot: Takeoff Function
% M-Fly Aero design
% Made by Jackson Lawson (jacklaws@umich.edu), Eric Sulewski (sulewski@umich.edu), and Daniel Efunwa (defunwa@umich.edu)
% 9/24/2023

%% Takeoff Function
function [TWtakeoff] = takeoff(dTO, rho, WingLoading, CLmax)
% dTO = Takeoff distance requirement (m)
    % Hi-Lift = 100 ft = 30.48 m
    % Advanced = 400 ft = 121.92 m
    % Autonomous = 600 ft = 182.88 m 
% rho = air density (kg/m^3)
% WingLoading = wing loading vector (N/m^2)
% CLmax = CL at stall, from AVL (unitless) 

% safety factor used to add drag and variable thrust effects
SF = 1.67; 

% stall speed to takeoff speed safety factor
k = 1.1;

% calculate thrust to weight ratio for maneuver
TWtakeoff = SF .* ((k.^2)./(9.81.*rho.*dTO.*CLmax)) .* WingLoading;
