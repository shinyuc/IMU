clc; clear; close all
% set window size as 2 seconds
% sample rate is 50 Hz
% In validation period, the sliding window length is 0.5 s
% data augmentation each step sliding +/-1, +/-2, and 0 samples
% dimensions 6*(50*2) = 6*100
% total xdata 
% xdata including 1050 positive samples and 1080 negative samples
label = csvread('label.csv',0,1);
xtotal = cell(2130,1);
ytotal = [ones(1050,1); zeros(1080,1)];

% positive samples of xtotal
for i = 1:60
    M = csvread([num2str(i),'.csv'],1,1);
    M = M'; M = M(1:6,:);
    if i <= 30
        for j = 1:3
            index = label(i,j)*50-3;
            for k = 1:5
                xtotal{((i-1)*3+j-1)*5+k,1} = M(:,index+k:index+k+99);
            end
        end
    elseif i >30
        for j = 1:4
            index = label(i,j)*50-3;
            for k = 1:5
                xtotal{((i-31)*4+90+j-1)*5+k,1} = M(:,index+k:index+k+99);
            end
        end 
    end
end
% negative samples of xtotal
for i = 1:30
    N = csvread([num2str(i),'.csv'],1,1);
    N = N'; N = N(1:6,:);
    mark_1 = label(i,2)*50-50;
    mark_2 = label(i,3)*50-50;
    for j = 1:6
        for k = 1:6
            frame_1 = N(:,(mark_1-j):(mark_1-j+49));
            frame_2 = N(:,(mark_2-k):(mark_2-k+49));
            xtotal{1050+36*(i-1)+6*(j-1)+k,1} = [frame_1,frame_2];
        end
    end
end
% process dataset
ytotal = categorical(ytotal);
cvp = cvpartition(ytotal,'Holdout',0.2);
xtrain = xtotal(cvp.training,:);
xvalidation = xtotal(cvp.test,:);
ytrain = ytotal(cvp.training,:);
yvalidation =ytotal(cvp.test,:);
%Create and Train LSTM Network
inputSize = 6;
numClasses = 2;
numHiddenUnits = 128;

layers = [ ...
%     imageInputLayer([6 100 1],'Normalization','none')
    sequenceInputLayer(6,'Name','sequence')
%     convolution2dLayer([1,5],64)
%     batchNormalizationLayer
%     reluLayer
%     
%     convolution2dLayer([1,5],64)
%     batchNormalizationLayer
%     reluLayer
    
%     convolution2dLayer([1,5],64)
%     batchNormalizationLayer
%     reluLayer
%     
%     convolution2dLayer([1,5],64)
%     batchNormalizationLayer
%     reluLayer
%     
        
    lstmLayer(numHiddenUnits,'OutputMode','last')
    tanhLayer
    
    lstmLayer(numHiddenUnits,'OutputMode','last')
    tanhLayer
    
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

% YPred = classify(net,imdsValidation);
% YValidation = imdsValidation.Labels;
% accuracy = sum(YPred == YValidation)/numel(YValidation)
YPred = classify(net,xtotal);
accuracy = sum(YPred == ytotal)/numel(ytotal)     