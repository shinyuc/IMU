% this is the final version
clc; close all;clear

for i = 4:4
    mark = zeros(1,91);
    M = csvread(['C:\Users\Shiyu Cheng\Desktop\',num2str(i),'\NGIMU - 003CF4BA\sensors.csv'],1,1);
    
    M = M';
    [~,len] = size(M);
    
    if len < 4500
        M(:,len+1:4500) = M(:,len)*ones(1,4500-len);
    end
    M = M(1:6,1:4500);
    
    avg = zeros(6,90);
    for second = 1:90
        for j = 1: 50
            avg(:,second) = M(:,50*(second-1)+j).^2 + avg(:,second);
        end
    end
    avg = avg/50;
    avg_sum = zeros(1,90);
    for col = 1:90
        avg_sum(col) =(avg(:,col))'*avg(:,col);
    end
    avg_sum(91) = 0;
%     record(i,:) = avg_sum;
    step = 0;
    fall = 0;
    count1 = 0;
    count2 = 0;
    
    for test = 2:89
        
        if avg_sum(test) - avg_sum(test-1) > 5 || avg_sum(test) - avg_sum(test+1)>5
            mark(test) = 1;
        end
        
        if avg_sum(test) - avg_sum(test-1) > 1e4 || avg_sum(test) - avg_sum(test+1)>1e4
            mark(test) = 2;
        end
        
        
        
        
        
        
    end
    for j = 1:91
        if mark(j) ~= 0
            if mark(j) == 1
                count1 = count1 +1;
            elseif mark(j) == 2
                count2 = count2 + 1;
            end
        else
            if count2 ~= 0
                fall = fall+1;
            elseif count1 ~=0
                step = step+1;
            end
            
            count1 = 0; count2 =  0;
        end
    end
    disp(mark)
    disp(step)
    disp(fall)
    
end
% ytotal(:,1) = [3*ones(20,1);4*ones(20,1);5*ones(20,1);zeros(20,1)];
% ytotal(:,2) = [zeros(60,1);ones(20,1)];
% 
% step_accuracy = 1- sum(abs(result(1:60,1)-ytotal(1:60,1)))/numel(ytotal(1:60,1));
% disp("Step counter accuracy is " + num2str(step_accuracy*100)+"%.")
% 
% fall_accuracy = 1- sum(abs(result(61:80,2)-ytotal(61:80,2)))/numel(ytotal(61:80,2));
% disp("Fall detection accuracy is " + num2str(fall_accuracy*100)+"%.")

% Step counter accuracy is 73.33%.
% Fall detection accuracy is 80%.