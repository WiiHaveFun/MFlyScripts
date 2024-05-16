[x,t] = getThickness("/Users/michaelchen/Documents/M-Fly/2023/AeroDesignMeetings/Airfoils/NACA_23112.dat", 1000);
[x1, x2, c] = findUsefulChord(x, t, 1, 6, 12, 1000);
plot(c, x2-x1, "LineWidth", 3);
hold on;
yline(3.067, "LineWidth", 3);

xlabel("Chord [in]");
ylabel("Useful Length [in]");