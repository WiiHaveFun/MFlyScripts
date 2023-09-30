%% Sizing Plot: Cruise Function
% M-Fly Aero design
% Made by Jackson Lawson (jacklaws@umich.edu), Eric Sulewski (sulewski@umich.edu), and Daniel Efunwa (defunwa@umich.edu)
% 9/24/2023

%% Cruise Function
function [TWcruise] = cruise(Velocity, rho, WingLoading, ParasiticDrag, AspectRatio, e)
% Inputs
% Velocity = velocity at cruise (m/s)
% rho = air density at cruise (kg/m^3)
% WingLoading = wing loading (N/m^2)
% ParasiticDrag = parasitic drag of the aircraft (unitless)
% AspectRatio = aspect ratio of planform (unitless)
% e = efficiency at cruise (unitless) 

% dynamic pressure calculation 
qcruise = 0.5.*rho.*(Velocity.^2); % (kg m^2/m^3 s^2 = Pa)

% given equation to calculate thrust to weight ratio for flight condition
TWcruise = ((qcruise.*ParasiticDrag)./WingLoading) + WingLoading.*(1./(qcruise.*pi.*e.*AspectRatio));  



