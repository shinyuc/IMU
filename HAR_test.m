clear;close all; clc
ytotal(:,1) = [3*ones(30,1);4*ones(30,1);zeros(30,1)];
ytotal(:,2)= [zeros(60,1); ones(30,1)];
load('-mat','HAR_v1'); 
ypred = zeros(90,1);
for i = 1:90
    M = csvread([num2str(i),'.csv'],1,1);
    M = M'; M = M(1:6,1:600);
    j = 1;
    step = 0;
    fall = 0;
    while (j+99) <= 600
        window = M(:,j:(j+99));
       
        count = classify(net,window);
        res = double(string(count));
        %step = step + double(string(count));
        
        if res == 1
            j = j+100;
            step = step + 1;
        elseif res == 2
            j = j+150;
            fall = fall+1;
        else
            j = j+50; 
        end
           
    end
    ypred(i,1) = step;
    ypred(i,2) = fall;
end 
step_accuracy = sum(ypred(:,1) == ytotal(:,1))/numel(ytotal(:,1));
disp(["step counter accuracy is", step_accuracy])
fall_accuracy = sum(ypred(:,2) == ytotal(:,2))/numel(ytotal(:,2));
disp(["fall detection accuracy is", fall_accuracy])