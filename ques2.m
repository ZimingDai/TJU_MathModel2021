clear all;close all;clc;


file = fopen('fluidPeople.txt');
ques2_matrix = textscan(file,'%n %n');
data = [ques2_matrix{1} ques2_matrix{2}];
n = max(size(data));
finaldata = [];
finaldata(1,1) = 1;
finaldata(1,2) = 0;
for i = 2:n
    finaldata(i,1) = i;
    finaldata(i,2) = data(i,2) - data(i-1,2);
end

GRdata = [];
for i = 1:6
    GRdata(i,1) = i;
    GRdata(i,2) = 0;
end
for i = 7:n
    GRdata(i,1) = i;
    total1 = 0;
    total2 = 0;
    for j = i-2:i
        total1 = total1 + finaldata(j,2);
    end
    for k = i-6:i
        total2 =total2 + finaldata(k,2);
    end
    GRdata(i,2) = log10(total1/3)/log10(total2/3);
end
showGRdata = GRdata(36:n,:);
scatter(showGRdata(:,1),showGRdata(:,2));
title('佛罗里达病例增长情况');
xlabel('time');
ylabel('Growth Rate Ratio')
