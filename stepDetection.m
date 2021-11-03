clear;clc;close all
% 20 steps per minute
% fall at 20 seconds and 40 seconds
n = 4;
threshold = 0.45;
switch n
    case 1
        M = csvread('sensors20carpet.csv', 1, 0);s = 20;
    case 2
        M = csvread('sensors20wood.csv', 1, 0);s = 20;
    case 3
        M = csvread('sensors30carpet.csv', 1, 0);s = 30;
    case 4
        M = csvread('sensors30wood.csv', 1, 0);s = 30;
        M = csvread('C:\Users\Shiyu Cheng\Desktop\stepDetection\1\NGIMU - 003CF4BA\sensors.csv', 1, 0);s = 30
end

if s == 20
    window_size = 120;
elseif s == 30
    window_size = 90;
end


time = M(:,1);
gyrox = M(:,2); gyroy = M(:,3); gyroz = M(:,4);
accx = M(:,5); accy = M(:,6); accz = M(:,7);

figure(1)
plot(time, gyrox,time, gyroy,time, gyroz,...
    time, accx,time, accy,time, accz)

figure(2)
subplot(3,2,1)
plot(time, gyrox)
title("Gyrox")
subplot(3,2,3)
plot(time, gyroy)
title("Gyroy")
subplot(3,2,5)
plot(time, gyroz)
title("Gyroz")
subplot(3,2,2)
plot(time, accx)
title("Accx")
subplot(3,2,4)
plot(time, accy)
title("Accy")
subplot(3,2,6)
plot(time, accz)
title("Accz")

X = accx.^2+accy.^2+accz.^2+gyrox.^2+gyroy.^2+gyroz.^2;
figure(3)
plot(time, X)
grid on
set(gca,'XTick',0:3:63);
set(gca, 'XMinorGrid','on');
title("acc and gyro")

Y = accx.^2+accy.^2+accz.^2;
figure(4)
plot(time, Y)
grid on
set(gca,'XTick',0:3:63);
set(gca, 'XMinorGrid','on');
title("acc only")
start = 61;

i = 1;
peak_i = 1;
[dim,~] = size(Y);

while i+window_size <=dim
    window = Y(i:i+window_size - 1);
    [peaki,samplei] = max(window);
    peak(peak_i) = peaki;
    
    sample(peak_i) = samplei;
    
    i = i+window_size;
%     if peak_i >=2
%         window_size = floor(window_size + sample(peak_i)-sample(peak_i-1));
%     end
    
    peak_i = peak_i + 1;
end   
window = Y(i:end);
[peaki,~] = max(window);
peak(peak_i) = peaki;
figure(5)
plot(peak)
size(peak)
step = 0;
for i = 1: length(peak)-1
    if abs(peak(i+1)-peak(i)) <= threshold
        step = step+1;
    end
end
disp("Step is:")
disp(step)







step_1 = 0;
for i = 1:length(peak)-1
    if peak(i) >= 1.13
        step_1 = step_1+1;
    end
end
disp("Step_1 is:")
disp(step_1)

Z = gyrox.^2+gyroy.^2+gyroz.^2;
figure(6)
plot(time, X)
grid on
set(gca,'XTick',0:3:63);
set(gca, 'XMinorGrid','on'); 
title("gyro only")

M = (gyrox/10).^2+(gyroy/20).^2+(gyroz/10).^2 ...
+(accx/0.5).^2+(accy/1.5).^2+(accz/0.5).^2;
figure(7)
plot(time, M)
grid on
set(gca,'XTick',0:3:63);
set(gca, 'XMinorGrid','on'); 
title("acc gyro normalize")
number = 0;
for i = 1:size(M)
    if M(i) >=1.5
        number = number + 1;
    end
end
disp(number)
        