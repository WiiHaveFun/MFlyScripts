function sizingPlot(weight, thrust, rho, CLMax, CDStall, thrustCurve, sref, vCruise, CD0, AR, e, dTO, convertToImperial)
    % SIZINGPLOT generates a sizing plot
    %
    %   weight = aircraft weight (N)
    %   thrust = thrust (N)
    %   rho = air density (kg/m^3)
    %   CLMax = At stall from AVL
    %   CDStall = At stall from AVL
    %   thrustCurve = Function handle of thrust in Newtons as a function of velocity (m/s)
    %   sref = wing area (m^2)
    %   vCruise = cruise velocity (m/s)
    %   CD0 = parasitic drag by subtracting CDi (AVL) from CD (CFD)
    %   AR = aspect ratio
    %   e = efficiency at cruise
    %   dtO = takeoff distance (m)
    %
    % Written by: Michael Chen, miclchen@umich.edu

    WSvector = linspace(0, 300, 3001);
    WSstall = stall(rho, CLMax, CDStall, thrustCurve, sref);

    TWcruise = cruise(vCruise, rho, WSvector, CD0, AR, e);

    ks = 1.2; % Ratio of the flight speed in the climb segment to the stall speed
    CLclimb = CLMax./(ks.^2); % CL at climb
    TWclimb = climb(CD0, AR, e, CLclimb, 5);

    Vturn = vCruise; % Depends on your desired turn radius
    TWturn = maneuver(Vturn, rho, WSvector, CD0, AR, e, 40);

    TWtakeoff = takeoff(dTO, rho, WSvector, CLMax);

    if(convertToImperial)
        WSvector = WSvector * 0.020885; % Convert N/m^2 lb/ft^2
        WSstall = WSstall * 0.020885; % Convert N/m^2 to lb/ft^2
        weight = weight * 0.224809; % Convert N to lb
        thrust = thrust * 0.224809; % Convert N to lb
        sref = sref * 10.7639; % Convert m^2 to ft^2
    end

    area([WSstall, 300], [0.5, 0.5], "FaceColor", "r", "FaceAlpha", 0.1, "EdgeAlpha", 0, 'HandleVisibility', 'off');
    hold on
    area(WSvector, TWtakeoff, "FaceColor", "r", "FaceAlpha", 0.1, "EdgeAlpha", 0, 'HandleVisibility', 'off');
    area(WSvector, TWturn, "FaceColor", "r", "FaceAlpha", 0.1, "EdgeAlpha", 0, 'HandleVisibility', 'off');
    area(WSvector, TWcruise, "FaceColor", "r", "FaceAlpha", 0.1, "EdgeAlpha", 0, 'HandleVisibility', 'off');
    area(WSvector, ones(1,length(WSvector)) * TWclimb, "FaceColor", "r", "FaceAlpha", 0.1, "EdgeAlpha", 0, 'HandleVisibility', 'off');
    plot([WSstall, WSstall], [0, 1000], 'g', LineWidth=3)
    % xline(WSstall, 'g', LineWidth=3)
    hold on
    plot(WSvector, TWtakeoff, LineWidth=3)
    plot(WSvector, TWturn, LineWidth=3)
    plot(WSvector, TWcruise, LineWidth=3)
    % yline(TWclimb, 'm', LineWidth=3)
    plot([0, 1000], [TWclimb, TWclimb], 'm', LineWidth=3)
    scatter(weight/sref, thrust/weight, 100, "filled")
    if(convertToImperial)
        xlim([0, 6])
        ylim([0, 0.5])
        xlabel("W/S [lb/ft^{2}]", "FontSize", 14);
        ylabel("T/W");
    else
        xlim([0, 300])
        ylim([0, 0.5])
        xlabel("W/S [N/m^{2}]", "FontSize", 14);
        ylabel("T/W");
    end
    
    legend("Stall", "Takeoff", "40° Banked Turn", "Cruise", "5° Climb", "MTOW Design");
    % xlabel("W/S", "FontSize", 14);
    % ylabel("T/W", "FontSize", 14);
    set(gca, "FontSize", 14);
    hold off

