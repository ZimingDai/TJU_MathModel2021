function dy=SEIR(t,x,A)
alpha = A(1);        %潜伏期转阳率
beta = A(2);         %感染率
gamma1 = A(3);      %潜伏期治愈率
gamma2 = A(4);      %患者治愈率
dy=[alpha*x(3) - gamma2*x(1);
    -beta*x(1)*x(2);
    beta*x(1)*x(2) - (alpha+gamma1)*x(3);
    gamma1*x(3)+gamma2*x(1)];