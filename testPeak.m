%M = csvread([num2str(i),'.csv'],1,1);
clear; close all;clc
% M_1 = csvread('C:\Users\Shiyu Cheng\Desktop\4\NGIMU - 003CF4BA\sensors.csv',1,0);
i = 70;
M_1 = csvread(['E:\documents\matlab\IMU\test_data\test',num2str(i),'\NGIMU - 003CF4BA\sensors.csv'],1,0);
time = M_1(:,1);
gyrox = M_1(:,2); gyroy = M_1(:,3); gyroz = M_1(:,4);
accx = M_1(:,5); accy = M_1(:,6); accz = M_1(:,7);

% figure(1)
% plot(time, gyrox,time, gyroy,time, gyroz,...
%     time, accx,time, accy,time, accz)

figure(1)
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

% figure(2)
% subplot(6,1,1)
% plot(time, gyrox)
% title("Gyrox")
% subplot(6,1,2)
% plot(time, gyroy)
% title("Gyroy")
% subplot(6,1,3)
% plot(time, gyroz)
% title("Gyroz")
% subplot(6,1,4)
% plot(time, accx)
% title("Accx")
% subplot(6,1,5)
% plot(time, accy)
% title("Accy")
% subplot(6,1,6)
% plot(time, accz)
% title("Accz")
