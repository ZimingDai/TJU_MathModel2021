clear all;close all;clc;

%%SEIAR模型
fid = fopen('totalCase.txt');
B = textscan(fid,'%f %f');
Idata = [B{1} B{2}];
n = max(size(Idata));
for i = 1:n
    Idata(i,2) = Idata(i,2) / 21480000;
end

A = [0.06 0.0475 0.0238 1];
[t,h] = ode45(@(t,x)SEIAR(t,x,A),[0 600],[0.99999970875, 0, 0.000000233, 0.00000005825, 0]);  %[初始感染人口占比 初始健康人口占比 初始潜伏人口占比 初始治愈人口占比]
plot(t,h(:,1),'r');
hold on;
plot(t,h(:,2),'b');

plot(t,h(:,3),'m');
plot(t,h(:,4),'g');
plot(t,h(:,5),'black');
% plot(Idata(:,1),Idata(:,2),'c');
legend('易感者人口占比S','潜伏人口占比E','显性感染人口占比I','隐性感染人口占比A','康复者人口占比R');
title('SEIAR模型')