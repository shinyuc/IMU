clc; clear; close all
label = csvread('label.csv',0,1);
label_1 = csvread('label_1.csv');
xtotal = zeros(6,100,1,1980);
for i = 61:90
    M = csvread([num2str(i),'.csv'],1,1);
    M = M'; M = M(1:6,:);
    for j = 1:30
        index = label_1(j,1);
        mark = index*50;
        for k = mark-14:mark+15
            window = M(:,k:k+99);
            xtotal(:,:,1,30*(i-61)+j) = window;
        end
    end
end

for i = 1:30
    N = csvread([num2str(i),'.csv'],1,1);
    N = N'; N = N(1:6,:);
    mark_1 = label(i,2)*50-50;
    mark_2 = label(i,3)*50-50;
    for j = 1:6
        for k = 1:6
            frame_1 = N(:,(mark_1-j):(mark_1-j+49));
            frame_2 = N(:,(mark_2-k):(mark_2-k+49));
            xtotal(:,:,1,900+36*(i-1)+6*(j-1)+k) = [frame_1,frame_2];
        end
    end
end

ytotal = [ones(900,1); zeros(1080,1)];
ytotal = categorical(ytotal);
cvp = cvpartition(ytotal,'Holdout',0.2);
xtrain = xtotal(:,:,1,cvp.training);
xvalidation = xtotal(:,:,1,cvp.test);
ytrain = ytotal(cvp.training,:);
yvalidation =ytotal(cvp.test,:);

numClasses = 2;

layers = [ ...
    imageInputLayer([6 100 1],'Normalization','none')

    convolution2dLayer([1,5],64)
    %batchNormalizationLayer
    reluLayer
    
    convolution2dLayer([1,5],64)
    %batchNormalizationLayer
    reluLayer
    
    convolution2dLayer([1,5],64)
    %batchNormalizationLayer
    reluLayer
    
    convolution2dLayer([1,5],64)
    %batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(128)
    %batchNormalizationLayer
    reluLayer
        
    fullyConnectedLayer(128)
    %batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

options = trainingOptions('adam', ...
    'InitialLearnRate',0.01, ...
    'MiniBatchSize',20, ...
    'MaxEpochs',15, ...
    'GradientThreshold',2, ...
    'Shuffle','every-epoch', ...
    'ValidationData',{xvalidation,yvalidation}, ...
    'Plots','training-progress', ...
    'Verbose',false);

net = trainNetwork(xtrain,ytrain,layers,options);


YPred = classify(net,xtotal);
accuracy = sum(YPred == ytotal)/numel(ytotal)     