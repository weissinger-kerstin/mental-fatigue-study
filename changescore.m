function changeSc = changescore(outcome, Ntasks)
% changeSc = changescore(outcome, Ntasks)

% Function 'changescore' assesses the change of COP time-series pre vs.
% post intervention, by calculating the arithmetic means. 
%
%   Input parameters:
        % outcome   cell, containing the outcome measures sway variablity,
        %           mean speed and sample entropy according to Lake's and Montesino's method. 
        % tasks     number of tasks

%   Output parameters:
        % changeSc  change scores (for each outcome measure respectively)

% Kerstin Weissinger, Margit Midtgaard Bach - 15.06.2023

%%
%Pre-allocating for speed
changeSc = NaN(size(outcome,1), Ntasks*2);

% Calculating the change from pre- to post for each task ((t+Ntasks*2)-t)
for t = 1:Ntasks*2
    changeSc(:,t) = (outcome(:,t+Ntasks*2)-outcome(:,t)) ./ ((outcome(:,t+Ntasks*2)+outcome(:,t))*0.5);
end

end
% ------eof------



