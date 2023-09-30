%% Sizing Plot: Stall Function
% M-Fly Aero design
% Made by Jackson Lawson (jacklaws@umich.edu), Eric Sulewski (sulewski@umich.edu), and Daniel Efunwa (defunwa@umich.edu)
% 9/24/2023

%% Stall Function
function [WSstall] = stall(rho, CLmax, CDstall, Tcurve, Sref)
% Inputs
% rho = air density at cruise (kg/m^3)
% CLmax = CL at stall, from AVL (unitless)
% CDmax = CD at stall, from AVL (unitless)
% Tcurve = Thrust as a function of velocity (N, velocity in m/s)
% Sref = Reference area of the wing (m^2)

% Drag Curve at stall
dc = @(v) .5.*CDstall.*rho.*(v^2).*Sref;        % Drag curve from MotoCalc or actual data
Vcruise = fzero(@(v) Tcurve(v) - dc(v), 1);     % Cruise velocity by setting thrust equal to drag
Vcruise

WSstall = 0.5.*rho.*CLmax.*(Vcruise.^2);        % Stall wing loading at cruise speed

end