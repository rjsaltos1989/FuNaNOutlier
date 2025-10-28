%--------------------------------------------------------------------------
%Dynamic Scanning Radius Algorithm
%--------------------------------------------------------------------------
%Authors: Xie et al.
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
%Stage 2: Dynamic Scanning Radius
%--------------------------------------------------------------------------

%Dynamic scanning radius
dsr = inf(n,1);
EDist = pdist2(Data,Data);
parfor i = 1:n
    dsr(i) = sum(EDist(i,NatN{i}))/numel(NatN{i});
end

%Dynamic scanning radius variation
sortdsr = sortrows(horzcat(transpose(1:n),dsr),2,'ascend');
rvar = zeros(n-1,1);

for i = 1:n-1
    rvar(i) = abs(sortdsr(i,2) - sortdsr(i+1,2))/sortdsr(i,2);
end

%Threshold beta
alpha = 2.5;
beta = mean(rvar,'omitnan') + alpha*std(rvar,'omitnan');

%--------------------------------------------------------------------------
%Stage 3: Outlier Detection
%--------------------------------------------------------------------------

score = dsr;
Outliers = unique(sort(vertcat(find(nb == 0),find(rvar >= beta) + 1)));

%Performance Evaluation

%AUC-ROC
[FPR,TPR,~,AUC] = perfcurve(y,score,1);

%AUC-PR
[Recall,Prec,~,AUCPR] = perfcurve(y,score,1,'YCrit','ppv','XCrit','tpr');

Metrics = [AUC max(Prec(2:end)) AUCPR];


