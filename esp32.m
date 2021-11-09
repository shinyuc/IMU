clc; close all
% window size 2 seconds
% sliding step 0.5 second
lenwindow = 2;
lenstep = 0.5;
sampel_rate = 50;
numwindow = 60;
cellnum = ((12 - lenwindow)/lenstep + 1)*numwindow;
xtotal = cell(cellnum,1);
result = zeros(60,1);
for i = 1:60
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
    step = 0;
    for test = 2:11
        if avg_sum(test) - avg_sum(test-1)>5 && avg_sum(test) - avg_sum(test+1)>5
            step = step+1;
        end
    end
    %disp(step)
    result(i,1) = step;            
end
    ground = [3*ones(30,1);4*ones(30,1)];
    wrong = 0;
for i = 1:60
    if result(i)~=ground(i)
        wrong = wrong+1;
    end
end
percent = 1- wrong/60;
disp(percent)