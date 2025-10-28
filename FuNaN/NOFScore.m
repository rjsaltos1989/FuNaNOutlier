%--------------------------------------------------------------------------
%NOF Algorithm
%--------------------------------------------------------------------------
%Authors: Huang et al.
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
%Stage 2: K-Distances
%--------------------------------------------------------------------------

%K-distance
kdist = Dist(:,kappa);

%K-tilde distance
ktdist = zeros(n,n);
Nk = zeros(n,n);
KNNk = KNN(:,1:kappa);

parfor i = 1:n

    %ktdist matrix computation
    for j = 1:n
        if i ~= j
            ktdist(i,j) = max(kdist(j),Dist(i,KNN(i,:) == j));
            if Dist(i,KNN(i,:) == j) <= kdist(i)
                Nk(i,j) = 1;
            end
        end
    end

    %Natural Influence Space
    [RNN{i},~] = find(KNNk==i);
    NIS{i} = union(KNNk(i,:),RNN{i});
end

NIS = NIS';

%Local reachability density
ldr = sum(Nk,2)./(sum(Nk.*ktdist,2));

%--------------------------------------------------------------------------
%Stage 3: Natural Outlier Factor
%--------------------------------------------------------------------------

NOF = zeros(n,1);
parfor i = 1:n
    NOF(i) = sum(ldr(NIS{i}))/(numel(NIS{i})*ldr(i));
end

%--------------------------------------------------------------------------
%Stage 4: Outlier Detection
%--------------------------------------------------------------------------

%The outliers are the top n data points with higher NOF score
% top = 1;
% NOFList = sortrows(horzcat(transpose(1:n),NOF),2,"descend");
% Outliers = sort(NOFList(1:top,1));

%Performance Evaluation
[BadRecall,Recall,Threshold,AUC,OptROC] = perfcurve(y,NOF,1);
[Prec, tpr, fpr, thresh] = prec_rec(NOF, y);

Metrics = [AUC max(Prec)];





