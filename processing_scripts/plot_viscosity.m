%% Plot viscosity results
clearvars, close all

%% Data

%rR =     [0.1,    0.2,    0.3,    0.4,    0.5];
%Udata  = [0.0632, 0.1383, 0.1957, 0.2076, 0.2087];
%Uerror = [0.0029, 0.0103, 0.0056, 0.0031, 0.0034]*10;

set_rR = 0.3;
mu_vary = [0.0010, 0.0020, 0.0050, 0.0100];
Udata   = [1.1999, 0.7505, 0.3726, 0.1957];
Uerror =  [0.0881, 0.0710, 0.0086, 0.0056]*2;

%% Predictions
mu_range = logspace(-3.5,-1.5,100);

fU_stokes = @(delta_rho,mu,g,a) 2.0/9.0*delta_rho/mu*g*a*a;

F = @(a,R) 1.0-2.104*a/R+2.09*(a/R)^3-0.95*(a/R)^5;
E = @(a,Z) 1.0-9.0/8.0*(2*a/Z)+((9.0/8.0)*2*a/Z)^2;
fU_stokesFE = @(delta_rho,mu,g,a,R,Z) 2.0/9.0*delta_rho/mu*g*a*a*F(a,R)/E(a,Z);

% Fixed parameters
g_fix = 9.81;
mu_fix = 1e-2;
Z_fix = 2e-3;
R_fix = 1e-3;
a_fix = 0.3e-3;
delta_rho_fix = 13000;

% Fixed functions
ffU_stokes   = @(mu)   fU_stokes(delta_rho_fix,mu,g_fix,a_fix);
ffU_stokesFE = @(mu) fU_stokesFE(delta_rho_fix,mu,g_fix,a_fix,R_fix,Z_fix);

% Results
pred_U_stokes   = arrayfun(ffU_stokes,mu_vary);
pred_U_stokesFE = arrayfun(ffU_stokesFE,mu_vary);
range_U_stokes   = arrayfun(ffU_stokes,mu_range);
range_U_stokesFE = arrayfun(ffU_stokesFE,mu_range);

%% Figures

figure
hold on,box on
errorbar(mu_vary,Udata,Uerror,'ko',...
    'LineWidth',2,'CapSize',15,...
    'MarkerSize',20,'MarkerFaceColor','k')
plot(mu_range,range_U_stokes,'r','LineWidth',2)
plot(mu_range,range_U_stokesFE,'b','LineWidth',2)
%xlim([0,0.6])
%ylim([0,0.6])
legend('Data','Stokes','Stokes + correction','Location','SouthOutside')
xlabel('Viscosity \mu, Pa s')
ylabel('Terminal velocity, ms^{-1}')
set(gca,'fontsize', 24)

figure
hold on,box on
errorbar(mu_vary,Udata,Uerror,'ko',...
    'LineWidth',2,'CapSize',15,...
    'MarkerSize',20,'MarkerFaceColor','k')
plot(mu_range,range_U_stokes,'r','LineWidth',2)
plot(mu_range,range_U_stokesFE,'b','LineWidth',2)
xlim([0.5e-3,2e-2])
legend('Data','Stokes','Stokes + correction','Location','NorthEast')
xlabel('Viscosity \mu, Pa s')
ylabel('Terminal velocity, ms^{-1}')
set(gca,'fontsize', 24)
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')

