function plot2D(x, y, z, labX, labY, labZ)
    % plot2D creates a scatter3 plots displaying 2 dimensions of
    % data    
    
    scatter3(x, y, z, 100, z, 'filled');
    view(-20,70)
    xlabel(labX)
    ylabel(labY)
    zlabel(labZ)

    cb = colorbar;
    cb.Label.String = labZ;

    colormap jet
end