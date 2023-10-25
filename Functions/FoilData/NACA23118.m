function pp = NACA23118(plotData)
    % NACA23012 returns a piecewise polynomial for the NACA 23118 airfoil that
    % relates max lift coefficient to Reynolds number.
    %
    %   plotData = boolean that plots a graph of the data
    Re = [3e4, 4e4, 6e4, 8e4, 0.1e6, 0.13e6, 0.16e6, 0.2e6, 0.25e6, 0.275e6, 0.3e6, 0.35e6, 0.4e6, 0.45e6, 0.5e6, 0.625e6, 0.75e6, 0.875e6, 1e6];
    MaxCl = [0.7659, 0.7688, 0.8834, 1.0201, 1.1059, 1.2027, 1.2333, 1.2588, 1.2800, 1.2850, 1.2954, 1.3148, 1.3283, 1.3496, 1.3676, 1.4014, 1.4326, 1.4623, 1.4835];

    pp = spline(Re, MaxCl);

    if plotData
        x = linspace(Re(1), Re(end), 100);
        plot(Re, MaxCl, "o", x, ppval(pp, x), LineWidth=2);
        legend("data", "spline")
        xlabel("Reynolds Number");
        ylabel("Max Cl");
    end
end