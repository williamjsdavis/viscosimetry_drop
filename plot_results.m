%% Plot results
clearvars, close all

%% Data

rR = [0.08, 0.1, 0.2, 0.3, 0.4, 0.5];

Udata = [4e-5, 4e-5, 2e-5, 1e-5, 1e-5, 5e-5];
Uerror = [4e-5, 4e-5, 2e-5, 1e-5, 1e-5, 2e-5];

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
delta_rho_fix = 1;

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
scatter(rR,pred_U_stokes,'ro')
plot(rR_range,range_U_stokes,'r')
scatter(rR,pred_U_stokesFE,'go')
plot(rR_range,range_U_stokesFE,'g')
set(gca,'fontsize', 18)



