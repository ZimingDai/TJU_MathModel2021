function dy=SEIAR(t,x,A)
lambda1 = A(1);        %显性感染者传播率
lambda2 = A(2);         %潜伏者传播率
gamma = A(3);      %康复系数
const = A(4);      % 1
dy=[-lambda1*(x(3)+0.652*x(4))*x(1)-lambda2*x(2)*x(1);
    lambda1*(x(3)+0.652*x(4))*x(1)+lambda2*x(2)*x(1)-(1/14)*x(2)*const;
    0.2*(1/14)*x(2)*const - gamma*x(3);
    0.8*(1/14)*x(2)*const - gamma*x(4);
    gamma*(x(4)+x(3))];