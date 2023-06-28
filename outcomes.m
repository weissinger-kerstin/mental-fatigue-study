function [sd, speed, sampL, sampM] = outcomes(data, Ntasks, m, r, fc, order)
% [sd, speed, sampL, sampM] = outcomes(data, n_tasks, m, r)

% Function 'outcomes' removes the offset and filters the COP time-series.
% In a next step the COP outcome measures are computed from the processed
% COP time-series (for both directions, i.e., ML & AP as well as time-points,
% i.e., pre & post)

%   Input parameters:
% data      COP time series for all n_tasks
% n_tasks   number of tasks
% m         template length for calculating sample entropy, vector (1x2)
% r         similarity tolerance for calculating sample entropy vector (1x2)

%   Output parameters:
% sd        sway variability (standard deviation) values
% speed     mean speed values
% sampL     sample entropy values using parameters according to Lake et al. (2002)
% sampM     sample entropy values using parameters according to Montesino et al. (2018)

% Kerstin Weissinger, Margit Midtgaard Bach 15.06.2023
%%

arguments
    data (:,:) {mustBeNumeric}
    Ntasks (1,1) double
    m (1,2) double
    r (1,2) double
    fc (1,1) double = 12.5; %default value is 12.5
    order (1,1) double = 2; %default value is 2
end

%% Pre-allocating for speed
sampL = NaN(1,Ntasks*4);
sampM = NaN(1,Ntasks*4);

%%
% Filter parameters
fs=100;
dt=1/fs;
Wn=fc/(fs/2);
[B,A]=butter(order,Wn);

%% Filtering and removing offset
data=data-mean(data);
dataf=filtfilt(B, A, data);

%% Calculting COP variability, i.e., standard deviation
sd = std(dataf);

%% Calculating COP mean speed
speed=mean(abs(diff(dataf)))/dt;

%% Calculating sample entropy
for t = 1:Ntasks*4
    sampL(:,t) = sampen(dataf(:,t), m(1), r(1));
    sampM(:,t) = sampen(dataf(:,t), m(2), r(2));
end

end

% ---- eof -------
