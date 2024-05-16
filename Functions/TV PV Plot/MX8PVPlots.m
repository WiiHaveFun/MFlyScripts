%% PV Plots

clear
close all

%Formatting
set(groot,'defaultLineLineWidth',1.25)
set(groot,'defaultTextInterpreter','latex')
set(groot,'defaultAxesTitleFontSize',1)
set(groot,'defaultAxesLabelFontSize',1)
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultTextFontSize',14)
set(groot,'defaultAxesFontSize',14)
set(groot,'defaultLegendInterpreter','latex')

hp_ftlbs = 1./550;

rho = 0.0022278758051497; % slugs/ft^3
g = 32.17; % ft/s^2
V = linspace(0, 65, 100);
V_met = linspace(0, 19.8, 100);

span = 9.95; % ft
S = 16.8476; % ft^2
W = 23; % fully loaded weight, lbs
AR = span^2 ./ S;
e = 0.9808; % Cruise e (AVL) (update based on where K is used, but if the plot isnt good dont worry)
K = 1/(pi*AR*e);
CD0 = 0.0849149;
Vstall = 35.82; % ft/s

% Dynamic Thrust
Tstatic = 11.09; % lbs

% Dynamic Thrust curve coefficients (Check units, your going to have to do some weird conversions based on the units from your prop lead) 
a = -0.0344; % This is in kg/m
b = -1.0; % This is in kg/s
c = 50.9; % This is in N
alpha = (a*V_met.^2 + b*V_met + c); 
q = 1./2.*rho.*V.^2;
alpha = alpha.*0.2248; % Thrust, lbs
Tavailable = alpha;
Pavailable = Tavailable.*V;
TavailableStall = Tavailable(abs(V - Vstall) == min(abs(V - Vstall)));
PavailableStall = Pavailable(abs(V - Vstall) == min(abs(V - Vstall)));

% Cruise
Tcruise = (K./q.*W.^2./S + CD0.*q.*S);
%Pcruise = V./alpha .* (K./q.*W.^2./S + CD0.*q.*S);
Pcruise = V .* (K./q.*W.^2./S + CD0.*q.*S);

% Banked Turn
phiBank = 40;
nBank = 1./cosd(phiBank);
Tbank = (nBank.^2.*K./q.*W.^2./S + CD0.*q.*S);
%Pbank = V./alpha .* Tbank;
Pbank = V .* Tbank;

% Climb Angle
thetaClimb = 5; % climb angle - cruise angle (play with it)
v_climb = 34; % Also from AVL check c1 at bank angle 
e_climb = 0.9682; % from AVL @ CL_climb

Tclimb = (K./q.*W.^2./S + CD0.*q.*S + W.*sind(thetaClimb));
%Pclimb = V./alpha .* Tclimb;
Pclimb = V .* Tclimb;

% Plotting
TVplot = figure(1);
hold on

fill([Vstall, Vstall, V(V > Vstall), V(end)], [0, TavailableStall, Tavailable(V > Vstall), 0], [0.6 0.8 1], 'FaceAlpha', 0.5, 'EdgeColor', 'none')
tCruise = plot(V,Tcruise,'b');
tBank = plot(V,Tbank,'m');
tClimb = plot(V,Tclimb,'k');
tAvailable = plot(V,Tavailable,'r');
tStall = plot([Vstall Vstall],[0 TavailableStall],'--r');
text(48,2.5,'Operational','HorizontalAlignment','center','VerticalAlignment','middle')
xlim([0 max(V)])
ylim([0 2.*max(Tavailable)])
xlabel('Airspeed (ft/s)')
ylabel('Thrust (lbs)')
%legend('45{\circ} Banked Turn', '9{\circ} Climb', 'Cruise', 'Available', 'Stall');
% legend([tBank tClimb tCruise tAvailable tStall],['$' num2str(phiBank) '^{\circ}$ Banked Turn'],['$' num2str(thetaClimb) '^{\circ}$ Climb'],'Cruise','Available','Stall','Location','Northeast','Units','normalized', 'FontSize', 9.5)
% legend('boxoff')
hold off

%set(gcf,'units','inches','position',[3 4 3.25 2.15])
%print('P_v_diagram_thrust.eps','-painters','-depsc')

PVplot = figure(2);
hold on %fix weird line below



fill([Vstall, Vstall, V(V > Vstall), V(end)], [0, PavailableStall.*hp_ftlbs, Pavailable(V > Vstall).*hp_ftlbs, 0],[0.6 0.8 1],'FaceAlpha',0.5,'EdgeColor','none')
hCruise = plot(V,Pcruise.*hp_ftlbs,'b');
hBank = plot(V,Pbank.*hp_ftlbs,'m');
hClimb = plot(V,Pclimb.*hp_ftlbs,'k');
hAvailable = plot(V,Pavailable.*hp_ftlbs,'r');
hStall = plot([Vstall Vstall],[0 PavailableStall.*hp_ftlbs],'--r');
text(48,0.1,'Operational','HorizontalAlignment','center','VerticalAlignment','middle')
xlim([0 max(V)])
ylim([0 2.*max(Pavailable.*hp_ftlbs)])
xlabel('Airspeed (ft/s)')
ylabel('Power (hp)')
%legend([tBank tClimb tCruise tAvailable tStall],['$' num2str(phiBank+15) '^{\circ}$ Banked Turn'],['$' num2str(thetaClimb+7) '^{\circ}$ Climb'],'Cruise','Available','Stall','Location','Northeast','Units','normalized', 'FontSize', 9.5)
%legend([hBank hClimb hCruise hAvailable hStall],'$40^{\circ}$ Banked Turn','$6^{\circ}$ Climb','Cruise','Available','Stall','Location','Northeast', 'Units', 'normalized', 'FontSize', 9.5); %'none','Units','normalized','Position',[0.45 0.74 0.1 0.1])
%legend('boxoff')
legend([hBank hClimb hCruise hAvailable hStall],['$' num2str(phiBank) '^{\circ}$ Banked Turn'],['$' num2str(thetaClimb) '^{\circ}$ Climb'],'Cruise','Available','Stall','Location','Northeast','Units','normalized', 'FontSize', 11)
legend('boxoff')

set(TVplot,'units','inches','position',[5 6 5 2.8])
set(PVplot,'units','inches','position',[10 6 5 2.8])

%%
saveas(TVplot, 'MX8TVPlot.epsc');
saveas(TVplot, 'MX8TVPlot.png');
saveas(PVplot, 'MX8PVPlot.epsc');
saveas(PVplot, 'MX8PVPlot.png');
%set(gcf,'units','inches','position',[3 4 3.25 2.15])
%print('P_v_diagram_power.eps','-painters','-depsc')
% 


