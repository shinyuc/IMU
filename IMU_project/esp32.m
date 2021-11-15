clc; close all;clear
% window size 2 seconds
% sliding step 0.5 second
lenwindow = 2;
lenstep = 0.5;
sampel_rate = 50;
numwindow = 60;
cellnum = ((12 - lenwindow)/lenstep + 1)*numwindow;
xtotal = cell(cellnum,1);
result = zeros(60,1);
step_threshold = 5;
fall_threshold = 10;
record = zeros(90,12);
for i = 1:90
    M = csvread([num2str(i),'.csv'],1,1);
    M = M';
    M = M(1:6,:);
    avg = zeros(6,12);
    for second = 1:12
        for j = 1: 50
            avg(:,second) = M(:,50*(second-1)+j).^2 + avg(:,second);
        end
    end
    avg = avg/50;
    avg_sum = zeros(1,12);
    for col = 1:12
        avg_sum(col) =(avg(:,col))'*avg(:,col);
    end
    record(i,:) = avg_sum;
    step = 0;
    fall = 0;
    %         for test = 2:11
    %             if avg_sum(test) - avg_sum(test-1)>1e4 && avg_sum(test) - avg_sum(test+1)>1e4
    %                 fall = fall+1;
    %
    %
    %             elseif avg_sum(test) - avg_sum(test-1)>5 && avg_sum(test) - avg_sum(test+1)>5
    %                 step = step+1;
    %             end
    %         end
    
    for test = 2:11
        
        if avg_sum(test) - avg_sum(test-1)>5 && avg_sum(test) - avg_sum(test+1)>5
            step = step+1;
        end
        
        
        if avg_sum(test) - avg_sum(test-1)>1e4 && avg_sum(test) - avg_sum(test+1)>1e4
            fall = fall+1;
            step = step-1;
        end
            
            
        
    end
    
    
    
    %disp(step)
    result(i,1) = step;
    result(i,2) = fall;
end
ytotal(:,1) = [3*ones(30,1);4*ones(30,1);zeros(30,1)];
ytotal(:,2) = [zeros(60,1);ones(30,1)];
% step_accuracy = sum(result(1:60,1) == ytotal(1:60,1))/numel(ytotal(1:60,1));
step_accuracy = sum(result(:,1) == ytotal(:,1))/numel(ytotal(:,1));
disp("Step counter accuracy is " + num2str(step_accuracy)+".")

fall_accuracy = sum(result(:,2) == ytotal(:,2))/numel(ytotal(:,2));
disp("Fall detection accuracy is " + num2str(fall_accuracy)+".")
% fall detection
