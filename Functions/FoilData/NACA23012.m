function pp = NACA23012(plotData)
    % NACA23012 returns a piecewise polynomial for the NACA 23012 airfoil that
    % relates max lift coefficient to Reynolds number.
    %
    %   plotData = boolean that plots a graph of the data
    Re = [0.1e6, 0.13e6, 0.16e6, 0.2e6, 0.25e6, 0.275e6, 0.3e6, 0.35e6, 0.4e6, 0.45e6, 0.5e6, 0.625e6, 0.75e6, 0.875e6, 1e6];
    MaxCl = [1.1881, 1.2305, 1.2465, 1.2646, 1.2911, 1.3009, 1.3085, 1.3327, 1.3498, 1.3627, 1.3859, 1.4164, 1.4366, 1.4696, 1.4877];

    pp = spline(Re, MaxCl);

    if plotData
        x = linspace(Re(1), Re(end), 50);
        plot(Re, MaxCl, "o", x, ppval(pp, x), LineWidth=2);
        legend("data", "spline")
        xlabel("Reynolds Number");
        ylabel("Max Cl");
    end
end