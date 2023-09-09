function [ppCruiseVel, ppMTOW] = findMTOWCruiseVel(alpha, CL, CD, thrustCurve, density, sref)
    % FINDMTOWCRUISEVEL takes drag polar points and a thrust curve
    % and calculates the MTOW and cruise velocity as a function of angle of
    % attack.
    %
    %   alpha = Angle of attack
    %   CL = Lift coefficient
    %   CD = Drag coefficient (parasitic + induced)
    %   thrustCurve = A function of thrust (N) vs. velocity (m/s)
    %   density = Air density (kg/m^3)
    %   sref = Wing surface area (m^2)
    %   
    %   Returns two piecewise polynomials (splines) with MTOW (kg) and 
    %   cruise velocity (m/s) vs. angle of attack
    %
    % Written by: Michael Chen, miclchen@umich.edu

    %% Find cruise velocity based on intersection of drag and thrust
    cruiseVel = NaN(length(CD),1);

    for i=1:length(CD)
        dragCurve = @(v) 0.5 * CD(i) * density * v.^2 * sref;
        cruiseVel(i) = fzero(@(v) thrustCurve(v) - dragCurve(v), 1);
    end

    %% Find MTOW based on CL and cruise velocity
    liftCurve = @(cL, v) 0.5 * cL * density .* v.^2 * sref;
    MTOW = liftCurve(CL, cruiseVel) / 9.81;

    %% Create splines
    ppCruiseVel = spline(alpha, cruiseVel);
    ppMTOW = spline(alpha, MTOW);
    