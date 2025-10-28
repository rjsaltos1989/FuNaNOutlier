%--------------------------------------------------------------------------
%Natural Density III
%--------------------------------------------------------------------------
%Authors: Yang et al.
%Matlab Implementation: Ramiro Saltos
%Version: 1.0.0
%Date: July 29, 2024
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%Stage 0: Loading the data
%--------------------------------------------------------------------------
% clear;
% myPath = '/Users/ramirojavier/Mi Unidad/MATLAB/DataOut/';
% dataset = 'Motivation.mat';
% load(strcat(myPath,dataset));

%--------------------------------------------------------------------------
%Stage 1: Initialization
%--------------------------------------------------------------------------

NaNSearch;

%--------------------------------------------------------------------------
%Stage 2: Natural Density
%--------------------------------------------------------------------------

rho = zeros(n,1);
EDist = pdist2(Data,Data);
parfor i = 1:n
    if ~isempty(NatN{i})
        rho(i) = (kappa + max(lambda,mode(nb)))/(2*sum(EDist(i,NatN{i})));
    end
end

%--------------------------------------------------------------------------
%Stage 3: Outlier Detection
%--------------------------------------------------------------------------

%Performance Evaluation
score = 1./rho;

%AUC-ROC
[FPR,TPR,~,AUC] = perfcurve(y,score,1);

%AUC-PR
[Recall,Prec,~,AUCPR] = perfcurve(y,score,1,'YCrit','ppv','XCrit','tpr');

Metrics = [AUC max(Prec(2:end)) AUCPR];