clear; close all; clc
load step_label.mat
load fall_label.mat
x = step_label;
y = fall_label;


figure(1)
subplot(2,1,1)
ylim([0 20])
plot(t,ground,'--')
[~,lenx] = size(x);
label_1 = [5 10 15 26.5 31 36 50.5 55.5 60 65];
label_2 = [18.5 40 69];
t = 1:1:90;
ground = 0.5*ones(1,length(t));
for i = 1: lenx
    rectangle('Position',[label_1(i),0,2,0.5],'EdgeColor','b','LineWidth',1)
end
[~,leny] = size(y);

for i = 1: leny
    rectangle('Position',[label_2(i),0,2,0.5],'EdgeColor','r','LineWidth',1)
end
set(gca,'ytick',[],'yticklabel',[])

% 
t = 1:1:90;
ground = 0.5*ones(1,length(t));
figure(1)
subplot(2,1,2)
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
%


