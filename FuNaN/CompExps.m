%--------------------------------------------------------------------------
%Outlier Detection Computational Experiments
%--------------------------------------------------------------------------
%Authors: Saltos, R., Weber, R., and W. Pedrycz
%Matlab Implementation: Ramiro Saltos
%Version: 1.0.0
%Date: July 04, 2025
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%Stage 0: Loading the data
%--------------------------------------------------------------------------

clear;
myPath = '/Users/ramirojavier/Mi Unidad/MATLAB/DataOut/';
Datasets = {'Cluto','Motivation','Zelnik2','Zelnik4','Zelnik6','SmtpS','BankNote',...
    'Annthyroid','Mammo','Thyroid','Vertebral','Rice','Glass','ShuttleS','Vowels',...
    'PenDigits','Lympho','WBC'};

ndata = numel(Datasets);
Results = zeros(ndata,4);
pbar = waitbar(0, 'Starting');

for expid = 1:ndata
    
    % Progress bar for the experiments
    waitbar(expid/ndata, pbar, sprintf('Progress: %d %%', floor(expid/ndata*100)));
    
    % Load the current dataset
    load(strcat(myPath,Datasets{expid},'.mat'));

    % Run the NaN method
    start = tic;
    WFRDAMain;
    time = toc(start);

    % Save the results
    Results(expid,:) = [Metrics time];

    % Clear workspace
    clearvars -except 'Datasets' 'ndata' 'Results' 'expid' 'pbar' 'myPath';
end

close(pbar)