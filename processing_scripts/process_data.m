%% Processes drop data
clearvars, close all

%% Import data

test_data = importdata('./results/drop_r3_mu1e2.txt');

%% Scales
t_scale = 7.4e-2; % To milliseconds
%t_scale = 1;
x_scale = 1; % Millimeters

%% Process
t = t_scale*test_data(:,1);
r = x_scale*test_data(:,2);
y = x_scale*test_data(:,3);
z = x_scale*test_data(:,4);
se = test_data(:,5);

figure
plot(t,se)

%% Cut time

t_max = 1;

i_max = find(t>t_max,1);

t_cut = t(1:i_max);
r_cut = r(1:i_max);
y_cut = y(1:i_max);
z_cut = z(1:i_max);
se_cut = se(1:i_max);

%% Get velocity
z_smoothed = smooth(z_cut,10);

dzdt = -gradient(z_cut,t_cut);
dzdt_smoothed = -gradient(z_smoothed,t_cut);


figure
hold on
box on
plot(t_cut,z_smoothed)
plot(t_cut,z_cut)
legend('Smoothed','Data')

figure
hold on
box on
plot(t_cut,dzdt_smoothed)
plot(t_cut,dzdt)
legend('Smoothed','Data')

figure
subplot(5,1,1)
plot(t_cut,r_cut)
title('Sphere raduis')
subplot(5,1,2)
plot(t_cut,y_cut)
title('Y position')
subplot(5,1,3)
plot(t_cut,z_cut)
title('Z position')
subplot(5,1,4)
plot(t_cut,dzdt_smoothed)
ylim([0,inf])
title('Z velocity')
subplot(5,1,5)
plot(t_cut,se_cut)
title('Sphere error')
xlabel('Time')

%% Get terminal velocity

Njack = 5;
max_jackknife = jackknife(dzdt_smoothed,Njack,0.1);

max_mean = mean(max_jackknife);
max_std = std(max_jackknife);
max_meanU = max_mean + 2*max_std;
max_meanL = max_mean - 2*max_std;

figure
hold on,box on
plot(t_cut,dzdt_smoothed,'r','LineWidth',2)
plot(t_cut,max_mean*ones(size(t_cut)),'k','LineWidth',2)
plot(t_cut,max_meanU*ones(size(t_cut)),'k--','LineWidth',2)
plot(t_cut,max_meanL*ones(size(t_cut)),'k--','LineWidth',2)
xlabel('Time, milliseconds')
ylabel('Z velocity, m/s')
legend('Data','Mean','2\sigma','Location','SouthEast')
set(gca,'fontsize', 24)

%% Functions
function out_max = jackknife(data,N,frac)
% Jackknife the max
Ndata = numel(data);
inds = 1:Ndata;

Nsample = floor(frac*Ndata);
out_max = zeros(N,1);
for i = 1:N
    isample = randi(Ndata,[Nsample,1]);
    sample = data(isample);
    out_max(i) = max(sample);
end
end
