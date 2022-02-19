clear;clc;close all

paper_density = 100;
Ts = 0.01;
t = 0:Ts:30;
I(1) = 0;

%Controller Parameters
alpha_p = 1; alpha_i = 0.5; alpha_d = 0.5;
delta_p = 0.1; delta_i = 0.4; delta_d = 0.3;

d1 = 15; d2 = 1; d3 = 10; K = 1.1;

%Initial Values
u(1) = 0; y(1) = 0;
w1(1) = 0.005; w2(1) = 0.005; w3(1) = 0.005;
e_tr(1) = 0;

r(1:7.5/Ts) = 1;
r(7.5/Ts+1 : 15/Ts) = 2;
r(15/Ts+1 : 22.5/Ts) = 0.5;
r(22.5/Ts+1:30/Ts+1) = -0.5;
y(1) = 0;

%Iterate
for i=1:3000
    
    %Calculate error
    e_tr(i) = r(i) - y(i);
    
    %Calculate the PID parameters
    P(i) = e_tr(i);
    
    if(i<2) 
        D(i) = e_tr(i);
    else
        D(i) = e_tr(i) - e_tr(i-1);
    end
    
    I(i) = integrate(e_tr);
    
    %Calculate results of f
    x_p(i) = f(P(i),alpha_p,delta_p);
    x_i(i) = f(I(i),alpha_i,delta_i);
    x_d(i) = f(D(i),alpha_d,delta_d);
    
    %Calculate the Control Signal
    Kp(i) = K*w1(i)/(w1(i)+w2(i)+w3(i));
    Ki(i) = K*w2(i)/(w1(i)+w2(i)+w3(i));
    Kd(i) = K*w3(i)/(w1(i)+w2(i)+w3(i));
    
    u(i) = Kp(i)*x_p(i)+Ki(i)*x_i(i)+Kd(i)*x_d(i);
    
    %Get the output of the system
    
    if(i<2)
        if (paper_density == 80)
           y(i+1) = 0.8187*y(i);
        elseif (paper_density == 100)
           y(i+1) = 0.7787*y(i);
        elseif (paper_density == 120)
           y(i+1) = 0.7165*y(i);
        end
    else
        if (paper_density == 80)
           y(i+1) = 0.8187*y(i) + 0.2719*u(i-1);
        elseif (paper_density == 100)
           y(i+1) = 0.7787*y(i) + 0.4484*u(i-1);
        elseif (paper_density == 120)
           y(i+1) = 0.7165*y(i) + 0.7087*u(i-1);
        end
    end

    %Update the controller parameters
    w1(i+1) = w1(i) + d1*e_tr(i)*u(i)*x_p(i);
    w2(i+1) = w2(i) + d2*e_tr(i)*u(i)*x_i(i);
    w3(i+1) = w3(i) + d3*e_tr(i)*u(i)*x_d(i);
end

figure
plot(t,y);
hold on;
plot(t,r);
legend('Output Signal','Reference Signal')
title('Output Signal and Reference Signal');
grid on;
saveas(gcf,'outvsref.png')

figure
plot(t(2:1:3001),u);
hold on;
plot(t,r);
title('Control Signal and the Reference');
legend('Control Signal','Reference');
grid on;
saveas(gcf,'contsigvsref.png')

figure
plot(t,w1);
hold on;
plot(t,w2);
hold on;
plot(t,w3);
hold off;
title('Alternation of w1, w2, w3');
legend('w1','w2','w3');
grid on;
saveas(gcf,'w1w2w3.png')

figure
plot(t(2:1:3001),Kp);
hold on;
plot(t(2:1:3001),Ki);
hold on;
plot(t(2:1:3001),Kd);
hold off;
title('Kp, Ki, Kd Parameters');
legend('Kp','Ki','Kd');
grid on;
saveas(gcf,'pid.png')

function [result] = f(x,a,d)

    if (abs(x) > d)
        result = sign(x)*(abs(x))^a;
    elseif (abs(x) <= d)
        result = x*d^(a-1);
    else
        result = 0;
    end
    
end

function [I] = integrate(e)
    I = 0;
    if (length(e) < 2)
        I = e(1);
    else
        for i=1:length(e) %iterate over all elements
            I = I + e(i);
        end
    end
end
