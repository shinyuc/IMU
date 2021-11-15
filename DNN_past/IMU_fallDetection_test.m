clear;close all; clc
ytotal = [ones(30,1); zeros(30,1)];
load('-mat','IMU_drop_1'); 
ypred = zeros(30,1);
for i = 61:90
    M = csvread([num2str(i),'.csv'],1,1);
    M = M'; M = M(1:6,1:600);
    j = 1;
    step = 0;
    while (j+99) <= 600
        window = M(:,j:(j+99));
        count = classify(net,window);
        step = step + double(string(count));
        %disp(double(string(count)))
        if double(string(count)) == 1
            j = j+150;
        else
            j = j+25; 
        end
           
    end
    ypred(i-60,1) = step;
end 

for i = 1:30
    M = csvread([num2str(i),'.csv'],1,1);
    M = M'; [~,len]=size(M);
    if len < 600
        for col = len+1:600
            M(:,col) = M(:,len);
        end
    end
    M = M(1:6,1:600);
    j = 1;
    step = 0;
    while (j+99) <= 600
        window = M(:,j:(j+99));
        count = classify(net,window);
        step = step + double(string(count));
        %disp(double(string(count)))
        if double(string(count)) == 1
            j = j+150;
        else
            j = j+25; 
        end
           
    end
    ypred(i+30,1) = step;
end

accuracy = sum(ypred == ytotal)/numel(ytotal)