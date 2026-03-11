%% run_model.m
close all; clear; clc;

%% General parameters
N = 30; 
tspan = [0 2000];
mu_v = 0; 
mu_p = 0;

%% Connectivity matrices
cv = generate_asymmetric_connectivity(N, 30, mu_v);
cp = generate_asymmetric_connectivity(N, 30, mu_p);

%% Biological parameters
a = 0.8 * ones(N,1); 
h = 0.1 * ones(N,1);
mV = 0.005; 
mP = 0.05; 
phiV = 0.002; 
phiP = 0.022;
AV = ones(N,1); 
AP = ones(N,1);
f = 2.75 * ones(N,1); 
w = 0.05 * ones(N,1);

%% Initial conditions
V0 = zeros(N,1); 
V0(1) = 200;

P0 = zeros(N,1); 
P0(1) = 50;

y0 = [V0; P0];

options = odeset('RelTol',1e-10,'AbsTol',1e-12);

%% Solve the model
tic
[t,Y] = ode45(@(t,y) ecosystem_model(t,y,N,a,h,mV,mP,phiV,phiP,AV,AP,f,w,cv,cp),...
              tspan,y0,options);
toc

Y(Y < 0) = 0;

%% Remove transient (t >= 500)
start_index = find(t >= 500,1);
Y_filtered = Y(start_index:end,:);
t_filtered = t(start_index:end);

%% Metrics calculation
extinction_threshold = 1e-5;

amplitude_V = zeros(N,1);
amplitude_P = zeros(N,1);
period_V = zeros(N,1);
period_P = zeros(N,1);
extinction_risk_V = zeros(N,1);
extinction_risk_P = zeros(N,1);

for j = 1:N
    
    V = Y_filtered(:,j);
    P = Y_filtered(:,N+j);

    amplitude_V(j) = max(V) - min(V);
    amplitude_P(j) = max(P) - min(P);

    [~,locs_V] = findpeaks(V,t_filtered,'MinPeakProminence',5);
    [~,locs_P] = findpeaks(P,t_filtered,'MinPeakProminence',5);

    if length(locs_V) > 1
        period_V(j) = mean(diff(locs_V));
    else
        period_V(j) = NaN;
    end

    if length(locs_P) > 1
        period_P(j) = mean(diff(locs_P));
    else
        period_P(j) = NaN;
    end

    extinction_risk_V(j) = sum(V < extinction_threshold) / length(V);
    extinction_risk_P(j) = sum(P < extinction_threshold) / length(P);

end

%% Mean densities
mean_V = mean(Y_filtered(:,1:N));
mean_P = mean(Y_filtered(:,N+1:end));

mean_V = mean_V(6:25);
mean_P = mean_P(6:25);

%% Orbit classification
orbit_type = zeros(N,1);
threshold = 10;

for j = 1:N

    V = Y_filtered(:,j);
    P = Y_filtered(:,N+j);

    [pks_V,~] = findpeaks(V,t_filtered,'MinPeakProminence',5);
    [pks_P,~] = findpeaks(P,t_filtered,'MinPeakProminence',5);

    if length(pks_V) < 3 && length(pks_P) < 3
        orbit_type(j) = 0;
        continue
    end

    cond_V = false; 
    cond_P = false;

    if length(pks_V) >= 3
        d1_V = abs(pks_V(end) - pks_V(end-1));
        d2_V = abs(pks_V(end-1) - pks_V(end-2));
        cond_V = (d1_V > threshold) || (d2_V > threshold);
    end

    if length(pks_P) >= 3
        d1_P = abs(pks_P(end) - pks_P(end-1));
        d2_P = abs(pks_P(end-1) - pks_P(end-2));
        cond_P = (d1_P > threshold) || (d2_P > threshold);
    end

    if cond_V || cond_P
        orbit_type(j) = 2;
    else
        orbit_type(j) = 1;
    end

end

%% Focus region (patches 6–25)
PoE_V = extinction_risk_V(6:25);
PoE_P = extinction_risk_P(6:25);

orbit_type_rec = orbit_type(6:25);

patch_axis = 1:20;

%% Figure: Mean density and extinction risk
figure(1); clf;

subplot(2,1,1); hold on;

for k = 1:length(patch_axis)

    switch orbit_type_rec(k)
        case 0
            marker = 'o';
        case 1
            marker = '^';
        case 2
            marker = 's';
    end

    plot(patch_axis(k),mean_V(k),marker,...
        'MarkerSize',8,...
        'MarkerFaceColor','none',...
        'MarkerEdgeColor','k',...
        'LineWidth',1.5);

    plot(patch_axis(k),mean_P(k),marker,...
        'MarkerSize',8,...
        'MarkerFaceColor','k',...
        'MarkerEdgeColor','k',...
        'LineWidth',1.5);

end

xlabel('Patch','Interpreter','latex')
ylabel('Mean density','Interpreter','latex')
set(gca,'FontSize',18,'TickLabelInterpreter','latex')
grid on
ylim([0 400])
xticks([1 5 10 15 20])

subplot(2,1,2); hold on;

for k = 1:length(patch_axis)

    switch orbit_type_rec(k)
        case 0
            marker = 'o';
        case 1
            marker = '^';
        case 2
            marker = 's';
    end

    plot(patch_axis(k),PoE_V(k),marker,...
        'MarkerSize',8,...
        'MarkerFaceColor','none',...
        'MarkerEdgeColor','k',...
        'LineWidth',1.5);

    plot(patch_axis(k),PoE_P(k),marker,...
        'MarkerSize',8,...
        'MarkerFaceColor','k',...
        'MarkerEdgeColor','k',...
        'LineWidth',1.5);

end

xlabel('Patch','Interpreter','latex')
ylabel('PoE','Interpreter','latex')
ylim([0 1])
set(gca,'FontSize',18,'TickLabelInterpreter','latex')
grid on
xticks([1 5 10 15 20])