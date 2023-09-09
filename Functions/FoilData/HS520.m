function pp = HS520(plotData)
    % HS520 returns a piecewise polynomial for the HS520 airfoil that
    % relates max lift coefficient to Reynolds number.
    %
    %   plotData = boolean that plots a graph of the data
    Re = [0.1e6, 0.13e6, 0.16e6, 0.2e6, 0.25e6, 0.275e6, 0.3e6, 0.35e6, 0.4e6, 0.45e6, 0.5e6, 0.625e6, 0.75e6, 0.875e6, 1e6];
    MaxCl = [1.1403, 1.1722, 1.1679, 1.1929, 1.2028, 1.1989, 1.2208, 1.2516, 1.2639, 1.2695, 1.2861, 1.3513, 1.3941, 1.4278, 1.4447];

    pp = spline(Re, MaxCl);

    if plotData
        x = linspace(Re(1), Re(end), 50);
        plot(Re, MaxCl, "o", x, ppval(pp, x), LineWidth=2);
        legend("data", "spline")
        xlabel("Reynolds Number");
        ylabel("Max Cl");
    end
end