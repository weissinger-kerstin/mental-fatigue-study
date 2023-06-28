function original = winsorizing(original, Nexp, Ncon, Ntasks, out)
%original = winsorizing(original, exp, con, tasks)

% Function 'winsorizing' replaces the score of an outlier with a determined minimum/maximum. 
% Specifically, if, x < mean-2∙SD or x > mean+ 2∙SD, x is replaced by the minimum or maximum value, i.e.,
% mean-2∙SD, mean+2∙SD, respectively.

%   Input parameters:
        % original  COP time-series data
        % exp       number of subjects in experimental group
        % con       number of subjects in control group
        % Ntasks     number of tasks

%   Output parameters:
        % original  COP time-series data (winsorized)

% % Kerstin Weissinger, Margit Midtgaard Bach - 15.06.2023
%%
arguments
    original (:,:) {mustBeNumeric}
    Nexp (1,1) double
    Ncon (1,1) double
    Ntasks (1,1) double
    out (1,1) double = 2; % determines a value as an outlier below/above 2*SD from the mean. Default = 2
end

% Checking whether the values are within the determined boundaries which
% differs for experimental and control group

subj = Nexp + Ncon;

for s = 1:subj
    for t = 1:Ntasks*4
        if s <= Nexp
            upbound = mean(original(1:Nexp,t)) + std(original(1:Nexp,t))*out;
            lowbound = mean(original(1:Nexp,t)) - std(original(1:Nexp,t))*out;
        else
            upbound = mean(original(Ncon:end,t)) + std(original(Ncon:end,t))*out;
            lowbound = mean(original(Ncon:end,t)) - std(original(Ncon:end,t))*out;
        end
        if original(s,t) > upbound
            original(s,t) = upbound;
        elseif original(s,t) < lowbound
            original(s,t) = lowbound;
        end
    end
end

end
% ------eof------
