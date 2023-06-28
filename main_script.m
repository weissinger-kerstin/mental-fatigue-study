% Kerstin Weissinger, Margit Midtgaard Bach 15.06.2023

addpath('Data/');
addpath("violinplot_matlab/");


%%
clear; close all;

%% General parameters
Nexp = 21; % n experimental group
Ncon = 22; % n control group
Nsubj = Nexp+Ncon; % total number of subjects
 
Ntasks = 6;
Ndirection = 2;
Ntimepoint = 2;

%% Sample entropy parameters (according to Lake et al., 2002 and Montesinos et al., 2018).
m = [3, 4]; % m(1) = Lake's, m(2) = Montesino's method
r = [0.05, 0.25]; % r(1) = Lake's, r(2) = Montesino's method


%% Defining the variables for outcome measures
% structure of matrix: 
% rows: (1:Nexp,:) = experimental group, (Ncon:end,:) = control group
% columns: (:,1:6) xpre, (:, 7:12) ypre, (:, 13:18) xpost, (:,19:24) ypost

sd = NaN(Nsubj,Ntasks*Ndirection*Ntimepoint); % variability (standard deviation)
speed = NaN(Nsubj,Ntasks*Ndirection*Ntimepoint); % mean speed 
sampL = NaN(Nsubj,Ntasks*Ndirection*Ntimepoint); % regularity (sample entropy) acc. to Lake's method
sampM = NaN(Nsubj,Ntasks*Ndirection*Ntimepoint); % regularity (sample entropy) acc. to Montesinos's method
outcomes_wins = {sd, speed, sampL, sampM};
changescores = {sd, speed, sampL, sampM};

%% Calculating outcome measures and their change scores

% If outcome measures are not saved as a mat-file, they will be calculated.

if ~isfile('Outcome_measures.mat')

    for n = 1:Nsubj % total subjects
        % Read the tables of either experimental condition or control condition
        if n <= Nexp
            data = readtable (['Data/E', num2str(n),'.txt']);
        else
            n1= n-Nexp;
            data = readtable (['Data/C', num2str(n1),'.txt']);
        end

        data = data{:,:};
        %Calculating raw outcome measures (variability, speed, sampen) per participant
        [sd(n,:), speed(n,:), sampL(n,:), sampM(n,:)] = outcomes (data, Ntasks, m, r);

    end

    save('outcome_measures.mat', 'data', 'sd', 'speed', 'sampL', 'sampM'); 
else
    load('outcome_measures.mat')
end

% Combining outcome measures in a cell
outcomes_raw = {sd, speed, sampL, sampM};
% Winsorizing the raw outcome measures and calculating change scores
for v = 1:numel(outcomes_raw)
    outcomes_wins{v} = winsorizing(outcomes_raw{v}, Nexp, Ncon, Ntasks);
    changescores{v} = changescore(outcomes_wins{v},Ntasks); % cell containing changescores of {1} sd, {2} speed, {3} sampL, {4} sampM
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Graphics 

%% VAS scales

VASmat = readtable ('Data/AVASscales.txt');
VASmat = VASmat{:,:};

colour = [0, 0, 255; 167, 198, 243]/255; % blue lighter
titles = {'MF-levels post intervention', 'Rel. change of MF-levels'};
figure('Name', 'Subjective Measures', 'NumberTitle','off', 'Renderer','painters')
tiledlayout(1,2, 'TileSpacing','compact', 'Padding','compact')

VAS = NaN(Ncon,2);
for v = 1:2
    VAS(1:Nexp,1)=VASmat(1:Nexp,v); VAS(1:Ncon,2)=VASmat(Ncon:end,v);
    nexttile
    vi = violinplot(VAS,'','ShowMean',true,'BoxColor',[0 0 0]);
    Plot_settings(vi, colour);
    set(gca, 'xtick', ''); 
    xlim([0.5 2.5]);
    if v == 1; ylim([0 100]); else; ylim([-50 50]); end
    set(gca, 'ytick', ylim, 'yticklabel', ylim);
    ylabel(titles(v))
end 

%% Change scores

titles = {'SD', 'Speed', 'SampL', 'SampM'};
conditions = {'EO', 'EC', 'DT','EO', 'EC', 'DT'};

color = [72, 7, 7; 190, 137, 137; 88, 88, 7; 221, 221, 143; 9, 9, 72; 154, 154, 207; ...
        72, 7, 7; 190, 137, 137; 88, 88, 7; 221, 221, 143; 9, 9, 72; 154, 154, 207]/255;
plot_order = [1 7 2 8 3 9 4 10 5 11 6 12];

changeML=NaN(Ncon,Ntasks*2);
changeAP=NaN(Ncon,Ntasks*2);

for v = 1:numel(changescores)
    changeML(1:Nexp,1:Ntasks) = changescores{v}(1:Nexp,1:Ntasks); % experimental group
    changeML(1:Ncon,Ntasks+1:Ntasks*2) = changescores{v}(Ncon:end,1:Ntasks); % control group
    changeAP(1:Nexp,1:Ntasks) = changescores{v}(1:Nexp,Ntasks+1:Ntasks*2); % experimental group
    changeAP(1:Ncon,Ntasks+1:Ntasks*2) = changescores{v}(Ncon:end,Ntasks+1:Ntasks*2); % control group

    figure('Name', sprintf('%s', titles{v}), 'NumberTitle','off', 'Renderer','painters')
    tiledlayout(2,1, 'TileSpacing','compact', 'Padding','compact')
    
    % violin plot in ML-direction (1:6 exp + 7:12 con group)
    nexttile 
    % The patch colours the difference between hip-broad and tandem stance.
    % Grey background is tandem, white background is hip-broad.
    patch([6.5 12.51 12.51 6.5], [-1.185 -1.185 1.2 1.2], [227, 227, 227]/255, 'EdgeColor', 'none', 'facealpha', 0.5)
    vi = violinplot(changeML(1:Nexp,plot_order),'','ShowMean',true,'BoxColor',[0 0 0]);
    Plot_settings(vi, color);
    set(gca, 'xtick', '')
    set(gca, 'ytick', [-1,0,1], 'yticklabel', [-1,0,1])
    ylabel('ML');

    % violin plot in AP-direction (1:6 exp + 7:12 con group)
    nexttile 
    % The patch colours the difference between hip-broad and tandem stance.
    % Grey background is tandem, white background is hip-broad.
    patch([6.5 12.51 12.51 6.5], [-1.185 -1.185 1.2 1.2], [227, 227, 227]/255, 'EdgeColor', 'none', 'facealpha', 0.5)
    vi = violinplot(changeAP(:,plot_order),'','ShowMean',true,'BoxColor',[0 0 0]);
    Plot_settings(vi, color);
    ylabel('AP');
    set(gca, 'xtick', 1.5:2:12, 'xticklabel', conditions)
    ax = gca;
    ax.XAxis.TickLength = [0 0];
    set(gca, 'ytick', [-1,0,1], 'yticklabel', [-1,0,1])
end 

%% pre COP trajectory
exmP= readtable('Data/E2.txt'); exmP = exmP{:,:}; %exemplary participant

fs=100; dt=1/fs; fc=12.5; order=2; Wn=fc/(fs/2); [B,A]=butter(order,Wn);
exmPf=filtfilt(B,A, exmP-mean(exmP));

figure('Name', 'COP trajectory (pre)', 'NumberTitle','off', 'Renderer','painters')
tiledlayout(2,1, 'TileSpacing','compact', 'Padding','compact')

for i = 1:6
    subplot(2,3,i)
    plot(exmPf(:,i), exmPf(:, i+6), 'Color', [0.4 0.4 0.4])
    axis([-35 35 -35 35])
    title(conditions{i},'FontSize', 11)
    xlabel('ML [mm]', 'FontSize', 11)
    ylabel('AP [mm]','FontSize', 11)
end 

t1=text(-250, 67, 'Hip-broad stance','FontWeight','bold', 'FontSize',12.5); set(t1, 'Rotation', 90)
t2=text(-250, -30, 'Tandem stance','FontWeight','bold', 'FontSize', 12.5); set(t2, 'Rotation', 90)
set(gcf, 'Position', [458  333  709  429]);