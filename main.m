clear all;close all;clc;

A = [0.063 0.0356 0.0238 1];
[t,h] = ode45(@(t,x)SEIAR(t,x,A),[0 1000],[0.99999970875, 0, 0.000000233, 0.00000005825, 0]);  %[初始感染人口占比 初始健康人口占比 初始潜伏人口占比 初始治愈人口占比]

data = [t h];
data = data(1:80,:);

% SEIAR 模型
fid = fopen('totalCase.txt');
B = textscan(fid,'%f %f');
Idata = [B{1} B{2}];
n = max(size(Idata));
for i = 1:n
    Idata(i,2) = Idata(i,2) / 21480000;
end
T=min(Idata(:,1)):0.1:max(Idata(:,1));
I = spline(Idata(:,1),Idata(:,1),T)';
S = spline(data(:,1),data(:,2),T)';
A = spline(data(:,1),data(:,5),T)';
E = spline(data(:,1),data(:,3),T)';
R = spline(data(:,1),data(:,6),T)';
plot(T,I,'r.');
% 
dI = diff(I)*10;
dI = [dI;dI(end)];
dS = diff(S)*10;
dS = [dS;dS(end)];
dE = diff(E)*10;
dE = [dE;dE(end)];
dA = diff(A)*10;
dA = [dA;dA(end)];
dR = diff(R)*10;
dR = [dR;dR(end)];



X = [-(I+0.652.*A).*S -E.*S zeros(length(I),2);
     (I+0.652.*A).*S E.*S zeros(length(I),1) -(1/14).*E;
     zeros(length(I),2) -I 0.2.*(1/14).*E;
     zeros(length(I),2) -A 0.8.*(1/14).*E;
     zeros(length(I),2) (A+I) zeros(length(I),1)];
    
 Y = [dS;dE;dI;dA;dR];
 
 K = inv(X'*X) *X'*Y;
 
[t,h] = ode45(@(t,x)SEIAR(t,x,K),[0 300],[0.99999970875, 0, 0.000000233, 0.00000005825, 0]);
plot(t,h(:,1),'r');
hold on;
plot(t,h(:,2),'b');
plot(t,h(:,3),'m');
plot(t,h(:,4),'g');
% 
