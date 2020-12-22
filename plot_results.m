%% Plot results
clearvars, close all

%% Data

rR =     [0.1,    0.2,    0.3,    0.4,    0.5];
Udata  = [0.0632, 0.1383, 0.1957, 0.2076, 0.2087];
Uerror = [0.0029, 0.0103, 0.0056, 0.0031, 0.0034]*10;

%% Predictions
rR_range = linspace(0,1,100);

fU_stokes = @(delta_rho,mu,g,a) 2.0/9.0*delta_rho/mu*g*a*a;

F = @(a,R) 1.0-2.104*a/R+2.09*(a/R)^3-0.95*(a/R)^5;
E = @(a,Z) 1.0-9.0/8.0*(2*a/Z)+((9.0/8.0)*2*a/Z)^2;
fU_stokesFE = @(delta_rho,mu,g,a,R,Z) 2.0/9.0*delta_rho/mu*g*a*a*F(a,R)/E(a,Z);

% Fixed parameters
g_fix = 9.81;
mu_fix = 1e-2;
Z_fix = 2e-3;
R_fix = 1e-3;
delta_rho_fix = 13000;

% r vector
r_vec = R_fix*rR;
r_range = R_fix*rR_range;

% Fixed functions
ffU_stokes   = @(r)   fU_stokes(delta_rho_fix,mu_fix,g_fix,r);
ffU_stokesFE = @(r) fU_stokesFE(delta_rho_fix,mu_fix,g_fix,r,R_fix,Z_fix);

% Results
pred_U_stokes   = arrayfun(ffU_stokes,r_vec);
pred_U_stokesFE = arrayfun(ffU_stokesFE,r_vec);
range_U_stokes   = arrayfun(ffU_stokes,r_range);
range_U_stokesFE = arrayfun(ffU_stokesFE,r_range);

%% Figures

figure
hold on,box on
errorbar(rR,Udata,Uerror,'ko',...
    'LineWidth',2,'CapSize',15,...
    'MarkerSize',20,'MarkerFaceColor','k')
plot(rR_range,range_U_stokes,'r','LineWidth',2)
plot(rR_range,range_U_stokesFE,'b','LineWidth',2)
xlim([0,0.6])
ylim([0,0.6])
legend('Data','Stokes','Stokes + correction','Location','NorthWest')
xlabel('Sphere to cylinder ratio, r/R')
ylabel('Terminal velocity, ms^{-1}')
set(gca,'fontsize', 24)

figure
hold on,box on
errorbar(rR,Udata,Uerror,'ko',...
    'LineWidth',2,'CapSize',15,...
    'MarkerSize',20,'MarkerFaceColor','k')
plot(rR_range,range_U_stokes,'r','LineWidth',2)
plot(rR_range,range_U_stokesFE,'b','LineWidth',2)
xlim([0,0.6])
legend('Data','Stokes','Stokes + correction','Location','SouthEast')
xlabel('Sphere to cylinder ratio, r/R')
ylabel('Terminal velocity, ms^{-1}')
set(gca,'fontsize', 24)
set(gca, 'YScale', 'log')


