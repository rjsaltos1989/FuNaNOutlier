%--------------------------------------------------------------------------
%NaNOD Algorithm
%--------------------------------------------------------------------------
%Authors: Wahid and Annavarapu
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
EDist = pdist2(Data,Data);

%--------------------------------------------------------------------------
%Stage 2: Weights and Kernel Computations
%--------------------------------------------------------------------------

%Initializations
Psi = zeros(n,1);
maxd = max(EDist,[],'all');
dlamb = zeros(n,1);

kdist = Dist(:,lambda);
ktdist = zeros(n,n);
KNNk = KNN(:,1:lambda);

%Weights and kernel width of the data points
parfor i = 1:n
    
    %Weights
    Psi(i) = abs(maxd - sum(EDist(i,:)))/maxd;
    
    %Kernel width
    dlamb(i) = mean(EDist(i,KNNr(i,:)),2);

    %ktdist matrix computation
    for j = 1:n
        if i ~= j
            ktdist(i,j) = max(kdist(j),Dist(i,KNN(i,:) == j));
        end
    end

    %Natural Influence Space
    [RNN{i},~] = find(KNNk==i);
    NIS{i} = union(KNNk(i,:),RNN{i});
end

%Weights Normalization
Psi = Psi/sum(Psi);

%Kernel width
theta = 1;
h = theta*(max(dlamb) + min(dlamb) - dlamb + 0.0001);

%Kernel-based Density
[~,p] = size(Data);
gamma = 2*Psi./((2*pi.*h).^p);

expd = zeros(n);
rho = zeros(n,1);

parfor i = 1:n
    expd(i,:) = exp(-(ktdist(i,:).^2)./(2*(h'.^2)));
    expd(i,:) = expd(i,:).*gamma';
end

parfor i = 1:n
    rho(i) = sum(expd(i,NIS{i}));
end

%--------------------------------------------------------------------------
%Stage 3: NaNOD Outlier Factor
%--------------------------------------------------------------------------

NaNOD = zeros(n,1);
parfor i = 1:n
    NaNOD(i) = sum(rho(NIS{i}))/(numel(NIS{i})*rho(i));
end

%--------------------------------------------------------------------------
%Stage 4: Outlier Detection
%--------------------------------------------------------------------------

%The outliers are the top n data points with higher NaNOD score

%Performance Evaluation
score = NaNOD;

%AUC-ROC
[FPR,TPR,~,AUC] = perfcurve(y,score,1);

%AUC-PR
[Recall,Prec,~,AUCPR] = perfcurve(y,score,1,'YCrit','ppv','XCrit','tpr');

Metrics = [AUC max(Prec(2:end)) AUCPR];
