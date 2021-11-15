%M = csvread([num2str(i),'.csv'],1,1);

M_1 = csvread('16.csv',1,0);
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
