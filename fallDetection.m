clear;clc;close all
% 20 steps per minute
% fall at 20 seconds and 40 seconds
window_size = 90;
M = csvread('C:\Users\Shiyu Cheng\Desktop\fallDetection\1\NGIMU - 003CF4BA\sensors.csv', 1, 0);
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

Y = accx.^2+accy.^2+accz.^2;
figure(4)
plot(time, Y)
grid on
set(gca,'XTick',0:3:63);
set(gca, 'XMinorGrid','on');

Z = gyrox.^2+gyroy.^2+gyroz.^2;
figure(5)
plot(time, Z)
% grid on
% set(gca,'XTick',0:3:63);
% set(gca, 'XMinorGrid','on');
M = (gyrox/10).^2+(gyroy/20).^2+(gyroz/10).^2 ...
+(accx/0.5).^2+(accy/1.5).^2+(accz/0.5).^2;
figure(7)
plot(time, M)
grid on
set(gca,'XTick',0:3:63);
set(gca, 'XMinorGrid','on'); 
title("acc gyro normalize")

start = 61;

i = 1;
peak_i = 1;
[dim,~] = size(Y);

while i+window_size <=dim
    window = M(i:i+window_size - 1);
    [peaki,~] = max(window);
    if peaki >= 6
        peak(peak_i) = peaki;
        peak_i = peak_i + 1;
    end
    
   
    i = i+window_size;

    
    
end   
window = Y(i:end);
[peaki,~] = max(window);
if peaki >= 6
        peak(peak_i) = peaki;   
end
figure(5)
plot(peak)
size(peak)
step = 0;