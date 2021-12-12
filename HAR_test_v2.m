clear;close all; clc
tic
ytotal(:,1) = [3*ones(20,1);4*ones(20,1);5*ones(20,1);zeros(20,1);zeros(20,1)];
ytotal(:,2)= [zeros(60,1); ones(20,1);zeros(20,1)];
load('-mat','HAR_v1');
ypred = zeros(80,1);
test = zeros(100,101);
for i = 1:100
    M = csvread(['E:\documents\matlab\IMU\test_data\test',num2str(i),'\NGIMU - 003CF4BA\sensors.csv'],1,1);
    M = M';
    [~,len] = size(M);
    
    if len < 600
        M(:,len+1:600) = M(:,len)*ones(1,600-len);
    end
    M = M(1:6,1:600);
    j = 1;
    step = 0;
    fall = 0;
    merge = -75;
    while (j+99) <= 600
        window = M(:,j:(j+99));
        
        count = classify(net,window);
        res = double(string(count));
        
        test(i,(j-1)/5+1)=res;
        if res == 0
            j = j+25;
            
        elseif res== 1
            step = step + 1;
            j = j+100;
        elseif res == 2
            fall = fall+1;
            j=j+150;
        end
        
    end
    
    
    
    
    ypred(i,1) = step;
    ypred(i,2) = fall;
end


stepacc2 = 1 - sum(abs(ypred(:,1)-ytotal(:,1)))/sum(ytotal(:,1));
disp("Step counter accuracy is "+num2str(stepacc2)+".")

fallacc1 = sum(ypred(:,2)==ytotal(:,2))/numel(ytotal(:,2));
disp("Fall detection accuracy is "+num2str(fallacc1)+".")
toc
% Step counter accuracy is 0.89.
% Step counter accuracy is 0.95417.
% Fall detection accuracy is 0.99.
% Elapsed time is 3.360820 seconds.