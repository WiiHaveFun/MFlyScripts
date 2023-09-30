%% Sizing Plot: Maneuver Function
% M-Fly Aero design
% Made by Jackson Lawson (jacklaws@umich.edu), Eric Sulewski (sulewski@umich.edu), and Daniel Efunwa (defunwa@umich.edu)
% 9/24/2023

%% Maneuver Function
function [TWmaneuver] = maneuver(Vturn, rho, WingLoading, ParasiticDrag, AspectRatio, e, BankAngle)
% Vturn = velocity of the aircraft at the turn (m/s)
% rho = air density (kg/m^3)
% WingLoading = wing loading vector (N/m^2)
% ParasiticDrag = parasitic drag of the aircraft
% AspectRatio = aspect ratio of planform
% e = efficiency of aircraft on the turn
% BankAngle = bank angle of turn (degrees)

% load factor calculation from given equation
n = 1 ./ (cosd(BankAngle));

% calculate dynamic pressure
q = 1/2 .* rho .* Vturn .^ 2;

% calculate thrust to weight ratio for maneuver
TWmaneuver = (q .* ParasiticDrag) ./ (WingLoading) + WingLoading .* (n.^2 / (q .* pi .* e .* AspectRatio));





