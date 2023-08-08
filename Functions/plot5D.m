function plot5D(x, y, z, dim4, dim5, c, numCases, dim4NumCases, dim5NumCases, labX, labY, labZ, lab4, lab5, labC)
    % plot4D creates a several scatter3 plots displaying 4 dimensions of
    % data

    numCasesPerPlot = numCases / dim4NumCases / dim5NumCases;

    t = tiledlayout(dim5NumCases, dim4NumCases);

    for i = 1:numCasesPerPlot:numCases
        nexttile
    
        scatter3(x(i:i + numCasesPerPlot - 1), y(i:i + numCasesPerPlot - 1), z(i:i + numCasesPerPlot - 1), 100, c(i:i + numCasesPerPlot - 1), 'filled');
        view(-20,70)
        xlabel(labX)
        ylabel(labY)
        zlabel(labZ)
    
        cb = colorbar;
        cb.Label.String = labC;

        colormap jet
    
        title(strcat(lab4, " " , string(dim4(i)), ", ", lab5, " " , string(dim5(i)), ", "));
    end    
end