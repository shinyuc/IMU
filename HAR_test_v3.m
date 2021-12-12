% this is the final version
clear;close all; clc

ytotal(:,1) = [3*ones(20,1);4*ones(20,1);5*ones(20,1);zeros(20,1)];
ytotal(:,2)= [zeros(60,1); ones(20,1)];
load('-mat','HAR_v1');
ypred = zeros(100,1);
global test
test = [];
global sample
global pred_label_1 pred_label_2
pred_label_1 = zeros(80,6);
pred_label_2 = zeros(80,6);
act_time = csvread('label_2.csv');

for i = 1:80
    M = csvread(['E:\documents\matlab\IMU\test_data\test',num2str(i),'\NGIMU - 003CF4BA\sensors.csv'],1,1);
    M = M';
    [~,len] = size(M);
    sample = i;
    if len < 600
        M(:,len+1:600) = M(:,len)*ones(1,600-len);
    end
    M = M(1:6,1:600);
    
    csvfile = M;
    [step, fall] = IMU(csvfile, net);
    ypred(i,1) = step;
    ypred(i,2) = fall;
end

TP_s = 0;
FN_s = 0;
FP_s = 0;
matrix_1 = zeros(80,3);
matrix_2 = zeros(80,3);

for i = 1:80
    % step detection
    num_pred_1 = ypred(i,1);
    num_actual_1= ytotal(i,1);
    act_time_buffer = act_time(i,1:num_actual_1);
    % 50% threshold 2/3 seconds difference
    TP = 0; FN = 0; FP = 0;
    for j = 1:num_pred_1
        pre_time = pred_label_1(i,j) ;
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
        pre_time = pred_label_2(i,j) ;
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
function [step, fall] = IMU(csvfile, net)
global test pred_label_1 pred_label_2 sample

j = 1;
step = 0;
fall = 0;
count1 = 0;
count2 = 0;
test1 = zeros(21,1)';
label_times_1 = [];
label_times_2 = [];
while (j+99) <= 600
    window = csvfile(:,j:(j+99));
    
    count = classify(net,window);
    res = double(string(count));
    test1((j-1)/25+1)=res;
    
    if res ~= 0
        if res == 1
            count1 = count1 + 1;
        elseif res == 2
            count2 = count2 + 1;
        end
    else
        if count1 >=count2 && ( count1 >0 || count2 >0)
            step = step+1;
        elseif count1 < count2 && ( count1 >0 || count2 >0)
            fall = fall+1;
        end
        if count1 ~=0 || count2~= 0
            
            label_time = (j-1)/50-(count1+count2)*0.5;
            
            if count1 >= count2
                label_times_1 = [label_times_1 label_time];
            else
                label_times_2 = [label_times_2 label_time];
            end
            
        end
        count1 = 0; count2 =  0;
    end
    j = j+25;
end

if count1 >=count2 && ( count1 >0 || count2 >0)
    step = step+1;
elseif count1 < count2 && ( count1 >0 || count2 >0)
    fall = fall+1;
end


if count1 ~=0 || count2~= 0
    
    label_time = (j-1)/50-(count1+count2)*0.5;
    
    if count1 >= count2
        label_times_1 = [label_times_1 label_time];
    else
        label_times_2 = [label_times_2 label_time];
    end
end
if length(label_times_1) <6
    pred_label_1(sample,1:length(label_times_1)) = label_times_1;
end
if length(label_times_2) <6
    pred_label_2(sample,1:length(label_times_2)) = label_times_2;
end
% disp(test1)
% test = [test;test1];

end
