clc; close all
% window size 2 seconds
% sliding step 0.5 second
lenwindow = 2;
lenstep = 0.5;
sampel_rate = 50;
numwindow = 60;
cellnum = ((12 - lenwindow)/lenstep + 1)*numwindow;
xtotal = cell(cellnum,1);
for i = 1:60
    M = csvread([num2str(i),'.csv'],1,1);
    M = M';
    for j = 0:(12 - lenwindow)/lenstep
        xtotal{((i-1)*21+j+1),1} = M(1:6,...
            (j*lenstep*sampel_rate+1):(j*lenstep*sampel_rate+lenwindow*sampel_rate));
    end
end
% xtrain = xtotal(1:900,:);
% xvalidation = xtotal(901:1260,:);
disp("no bug")
% label y
label = csvread('label.csv',0,1);
label_1 = label/0.5+1;
indexSize = 30*3+30*4;
index = zeros(indexSize,1);
for i = 1:30
    for j = 1:3
        index((j+(i-1)*3),1) = (i-1)*21 + label_1(i,j);
    end
end

for i = 31:60
    for j = 1:4
        index(90+j+(i-31)*4,1) = (i-31)*21 + label_1(i,j) + 21*30;
    end
end
disp("no bug 2")
ytotal = zeros(cellnum,1);
for i = 1:length(index)
    ytotal(index(i),1) = 1;
end
disp("no bug 3")
% ytrain = ytotal(1:900,:);
% ytrain = categorical(ytrain);
% yvalidation = ytotal(901:1260,:);
% yvalidation = categorical(yvalidation);
cvp = cvpartition(ytotal,'Holdout',0.2);
xtrain = xtotal(cvp.training,:);
xvalidation = xtotal(cvp.test,:);
ytrain = ytotal(cvp.training,:);
ytrain = categorical(ytrain);
yvalidation =ytotal(cvp.test,:);
yvalidation = categorical(yvalidation);
disp("no bug 4")
%Create and Train LSTM Network
inputSize = 6;
numClasses = 2;
numHiddenUnits = 80;

layers = [ ...
    sequenceInputLayer(inputSize)
    
    lstmLayer(numHiddenUnits,'OutputMode','last')
    
    fullyConnectedLayer(30)
    batchNormalizationLayer
    reluLayer
        
    fullyConnectedLayer(10)
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

options = trainingOptions('adam', ...
    'InitialLearnRate',0.01, ...
    'MiniBatchSize',10, ...
    'MaxEpochs',10, ...
    'GradientThreshold',2, ...
    'Shuffle','every-epoch', ...
    'ValidationData',{xvalidation,yvalidation}, ...
    'Plots','training-progress', ...
    'Verbose',false);
net = trainNetwork(xtrain,ytrain,layers,options);
