%% Sizing Plot: Cruise Function
% M-Fly Aero design
% Made by Jackson Lawson (jacklaws@umich.edu), Eric Sulewski (sulewski@umich.edu), and Daniel Efunwa (defunwa@umich.edu)
% 9/24/2023

%% Cruise Function
function [TWclimb] = climb(ParasiticDrag, AspectRatio, e, CL, ClimbAngle)
% ParasiticDrag = parasitic drag of aircraft
% AspectRatio = aspect ratio of planform
% e = efficiency at climb 
% CL = coefficient of lift at climb
% ClimbAngle = climb angle (degrees)

% calculate climb gradient percent
G = tand(ClimbAngle);

% calculate thrust to weight ratio from given equation
TWclimb = (ParasiticDrag + CL^2/(pi*AspectRatio*e)) / CL + G; 



