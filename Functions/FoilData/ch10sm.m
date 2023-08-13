function pp = ch10sm(plotData)
    % Returns spline/piecewise polynomial relating Reynolds number to max Cl
    Re = [0.1e6, 0.13e6, 0.16e6, 0.2e6, 0.25e6, 0.275e6, 0.3e6, 0.35e6, 0.4e6, 0.45e6, 0.5e6, 0.625e6, 0.75e6, 0.875e6, 1e6];
    MaxCl = [1.6781, 1.7873, 1.8888, 1.9552, 2.0094, 2.0193, 2.0260, 2.0285, 2.0261, 2.0267, 2.0291, 2.0358, 2.0409, 2.0411, 2.0433];

    pp = spline(Re, MaxCl);

    if plotData
        x = linspace(Re(1), Re(end), 50);
        plot(Re, MaxCl, x, ppval(pp, x), LineWidth=2);
        xlabel("Reynolds Number");
        ylabel("Max Cl");
    end
end