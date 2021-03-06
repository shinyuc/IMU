% this is the final version
clc; close all;clear
time_label_1 = zeros(80,6);% step detection
time_label_2 = zeros(80,6);% fall detection
ypred = zeros(80,2);
ytotal(:,1) = [3*ones(20,1);4*ones(20,1);5*ones(20,1);zeros(20,1)];
ytotal(:,2) = [zeros(60,1);ones(20,1)];
act_time = csvread('label_2.csv');
for i = 1:80
   
    mark = zeros(1,13);
    M = csvread(['E:\documents\matlab\IMU\test_data\test',num2str(i),'\NGIMU - 003CF4BA\sensors.csv'],1,1);
    
    M = M';
    [~,len] = size(M);
    
    if len < 600
        M(:,len+1:600) = M(:,len)*ones(1,600-len);
    end
    M = M(1:6,1:600);
    
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
    avg_sum(13) = 0;
%     record(i,:) = avg_sum;
    step = 0;
    fall = 0;
    count1 = 0;
    count2 = 0;
    
    for test = 2:11
        
        if avg_sum(test) - avg_sum(test-1) > 5 || avg_sum(test) - avg_sum(test+1)>5
            mark(test) = 1;
        end
        
        if avg_sum(test) - avg_sum(test-1) > 1e4 || avg_sum(test) - avg_sum(test+1)>1e4
            mark(test) = 2;
        end
        
        
        
        
        
        
    end
    
    label_1 = [];
    label_2 = [];
    
    for j = 1:13
        if mark(j) ~= 0
            %             disp(j)
            if mark(j-1) ==0
                label = j-1;
            end
            
            if mark(j) == 1
                count1 = count1 +1;
            elseif mark(j) == 2
                count2 = count2 + 1;
            end
            
        else
            if count2 ~= 0
                fall = fall+1;
                label_2 = [label_2 label];
            elseif count1 ~=0
                step = step+1;
                label_1 = [label_1 label];
            end
            
            count1 = 0; count2 =  0;
        end
    end
    
    ypred(i,1) = step;
    ypred(i,2) = fall;
    time_label_1(i,1:length(label_1)) = label_1;
    time_label_2(i,1:length(label_2)) = label_2;
    %disp(mark)
end

for i = 1:80
    % step detection
    num_pred_1 = ypred(i,1);
    num_actual_1= ytotal(i,1);
    act_time_buffer = act_time(i,1:num_actual_1);
    % 50% threshold 2/3 seconds difference
    TP = 0; FN = 0; FP = 0;
    for j = 1:num_pred_1
        pre_time = time_label_1(i,j) ;
        difference = min(abs(act_time_buffer - pre_time));
        if difference <=2/3
            TP = TP+1;
        end
    end
    if TP <= num_actual_1
        FN = num_actual_1 - TP;
    else
        FN = 0;
    end
    
    if TP <= num_pred_1
        FP = num_pred_1 - TP;
    else
        FP = 0;
    end
    matrix_1(i,:) = [TP FN FP];
    
    % fall detection
    num_pred_2 = ypred(i,2);
    num_actual_2= ytotal(i,2);
    
    act_time_buffer_2 = act_time(i,1:num_actual_2);
    % 50% threshold 2/3 seconds difference
    TP = 0; FN = 0; FP = 0;
    for j = 1:num_pred_2
        pre_time = time_label_2(i,j) ;
        difference = min(abs(act_time_buffer_2 - pre_time));
        if difference <=2/3
            TP = TP+1;
        end
    end
    if TP <= num_actual_2
        FN = num_actual_2 - TP;
    else
        FN = 0;
    end
    
    if TP <= num_pred_2
        FP = num_pred_2 - TP;
    else
        FP = 0;
    end
    matrix_2(i,:) = [TP FN FP];
end




% for step detection
precision_step = sum(matrix_1(:,1))/(sum(matrix_1(:,1)+matrix_1(:,3)));
recall_step = sum(matrix_1(:,1))/(sum(matrix_1(:,1)+matrix_1(:,2)));
disp("Step detection precision is: " + num2str(precision_step*100)+"%.")

disp("Step detection recall is: " + num2str(recall_step*100)+"%.")
% for fall detection
precision_fall = sum(matrix_2(:,1))/(sum(matrix_2(:,1)+matrix_2(:,3)));
recall_fall = sum(matrix_2(:,1))/(sum(matrix_2(:,1)+matrix_2(:,2)));
disp("Fall detection precision is: " + num2str(precision_fall*100)+"%.")
disp("Fall detection recall is: " + num2str(recall_fall*100)+"%.")
disp('Finish')