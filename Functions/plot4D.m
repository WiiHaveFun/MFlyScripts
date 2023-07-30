function plot4D(x, y, z, dim4, c, numCases, dim4Length, labX, labY, labZ, lab4, labC)
    % plot4D creates a several scatter3 plots displaying 4 dimensions of
    % data

    dim4NumCases = numCases / dim4Length;

    t = tiledlayout(1, dim4NumCases);

    

    for i = 1:dim4Length:numCases
        nexttile
    
        scatter3(x(i:i + dim4Length - 1), y(i:i + dim4Length - 1), z(i:i + dim4Length - 1), 100, c(i:i + dim4Length - 1), 'filled');
        view(-20,70)
        xlabel(labX)
        ylabel(labY)
        zlabel(labZ)
    
        cb = colorbar;
        cb.Label.String = labC;

        colormap jet
    
        title(strcat(lab4, " " , string(dim4(i))));
    end    
end