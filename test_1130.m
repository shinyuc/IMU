clear;close all; clc
tic
ytotal(:,1) = [3*ones(20,1);4*ones(20,1);5*ones(20,1);zeros(20,1);zeros(20,1)];
ytotal(:,2)= [zeros(60,1); ones(20,1);zeros(20,1)];
load('-mat','HAR_v1'); 
ypred = zeros(80,1);
test = zeros(100,101);
step_label = [];
fall_label = [];
for i = 4:4
    M = csvread(['C:\Users\Shiyu Cheng\Desktop\',num2str(i),'\NGIMU - 003CF4BA\sensors.csv'],1,1);
    M = M';
    [~,len] = size(M);
    
    if len < 4500
        M(:,len+1:4500) = M(:,len)*ones(1,4500-len);
    end
    M = M(1:6,1:4500);
    j = 1;
    step = 0;
    fall = 0;
    merge = -75;
    while (j+99) <= 4500
        window = M(:,j:(j+99));
        
        count = classify(net,window);
        res = double(string(count));
        
        test(i,(j-1)/5+1)=res;
            if res == 0
                j = j+25;

            elseif res== 1
                step = step + 1;
                disp('step')
                disp(j)
                step_label = [step_label, j];
                j = j+100;
            elseif res == 2
                fall = fall+1;
                disp('fall')
                disp(j)
                fall_label = [fall_label, j];
                j=j+150;
            end
    
            end
        
        
           
    
    ypred(i,1) = step;
    ypred(i,2) = fall;
end

% stepacc1 = sum(ypred(:,1)==ytotal(:,1))/numel(ytotal(:,1));
% disp("Step counter accuracy is "+num2str(stepacc1)+".")
% 
% stepacc2 = 1 - sum(abs(ypred(:,1)-ytotal(:,1)))/sum(ytotal(:,1));
% disp("Step counter accuracy is "+num2str(stepacc2)+".")
% 
% fallacc1 = sum(ypred(:,2)==ytotal(:,2))/numel(ytotal(:,2));
% disp("Fall detection accuracy is "+num2str(fallacc1)+".")
toc
% Step counter accuracy is 0.89.
% Step counter accuracy is 0.95417.
% Fall detection accuracy is 0.99.
% Elapsed time is 3.360820 seconds.
x = step_label;
y = fall_label;

t = 1:1:90;
ground = 0.5*ones(1,length(t));

figure(1)%CNN predict
subplot(3,1,2)
ylim([0 20])
plot(t,ground,'--')
[~,lenx] = size(x);
for i = 1: lenx
    rectangle('Position',[x(i)/50,0,2,0.5],'EdgeColor','b','LineWidth',1)
end
[~,leny] = size(y);
for i = 1: leny
    rectangle('Position',[y(i)/50,0,2,0.5],'EdgeColor','r','LineWidth',1)
end
set(gca,'ytick',[],'yticklabel',[])
xlabel({'Testing time (s)';'(b)'})
title('Recognized activity predicted by CNN-based algorithm')
hold on

subplot(3,1,1)
step_label_1 = [4 9.5 15 26.5 31 36 50.5 55 60 65];
fall_label_1 = [19 41.5 70];
x = step_label_1;
y = fall_label_1;

t = 1:1:90;
ground = 0.5*ones(1,length(t));

ylim([0 20])
plot(t,ground,'--')
[~,lenx] = size(x);
for i = 1: lenx
    rectangle('Position',[x(i),0,2,0.5],'EdgeColor','b','LineWidth',1)
end
[~,leny] = size(y);
for i = 1: leny
    rectangle('Position',[y(i),0,2,0.5],'EdgeColor','r','LineWidth',1)
end
set(gca,'ytick',[],'yticklabel',[])
xlabel({'Testing time (s)';'(a)'})
title('The real activity')

subplot(3,1,3)
step_label_2 = [5 11 16 20 28 32 37 42 51 56 61 66];
fall_label_2 = [71];
x = step_label_2;
y = fall_label_2;

t = 1:1:90;
ground = 0.5*ones(1,length(t));

ylim([0 20])
plot(t,ground,'--')
[~,lenx] = size(x);
for i = 1: lenx
    rectangle('Position',[x(i),0,2,0.5],'EdgeColor','b','LineWidth',1)
end
[~,leny] = size(y);
for i = 1: leny
    rectangle('Position',[y(i),0,2,0.5],'EdgeColor','r','LineWidth',1)
end
set(gca,'ytick',[],'yticklabel',[])
xlabel({'Testing time (s)';'(c)'})
title('Recognized activity predicted by peak-detection algorithm')