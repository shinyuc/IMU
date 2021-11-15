clear;close all; clc
ytotal = [3*ones(30,1);4*ones(30,1)];
load('-mat','IMU_CNN'); 
ypred = zeros(60,1);

for i = 1:60
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
            j = j+125;
        else
            j = j+25; 
        end
           
    end
    ypred(i,1) = step;
end
accuracy = sum(ypred == ytotal)/numel(ytotal)