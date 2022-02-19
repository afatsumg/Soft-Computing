clc;clear
syms x

func = (x-1)^2*(x-2)*(x-3); %Cost function

%Step 1: initialize

x_low = 0;
x_up = 2;
deltaX_final = 10^-10;
tau =  0.38197;
epsilon = deltaX_final/(x_up-x_low);
N = -2.078*log(epsilon);
k = 1;

%Step 2

x1 = (1-tau)*x_low+ tau*x_up;
f1 = vpa(subs(func,x,x1));
x2 = (1-tau)*x_up+ tau*x_low;
f2 = vpa(subs(func,x,x2));

%Step 3
for i=1:100
    if(k<N)
       if(f1>f2)
          x_low = x1;
          x1 = x2;
          f1 = f2;
          x2 = tau*x_low + (1-tau)*x_up;
          f2 = vpa(subs(func,x,x2));
          x2_values(k) = x2;
          f2_values(k) = f2;
          k = k + 1;

       elseif(f1<f2)
          x_up = x2;
          x2 = x1;
          f2 = f1;
          x1 = tau*x_up + (1-tau)*x_low;
          f1 = vpa(subs(func,x,x1));
          k = k + 1;
          x1_values(k) = x1;
          f1_values(k) = f1;
       end
    end
i = i+1;
end

tiledlayout(2,1);
% Plot
if(f1<f2)
    ax1 = nexttile;
    plot(x1_values,'-o')
    xlabel('Iteration Number');
    ylabel('x');
    title('Change of the x versus iteration number')
    grid on
    
    ax2 = nexttile;
    plot(f1_values,'-o')
    xlabel('Iteration Number');
    ylabel('f(x)');
    title('Alternation of the objective function by the evolution of x')
    grid on
else
    ax1 = nexttile;
    plot(x2_values,'-o')
    xlabel('Iteration Number');
    ylabel('x');
    title('Change of the x versus iteration number')
    grid on
    
    ax2 = nexttile;
    plot(f2_values,'-o')
    xlabel('Iteration Number');
    ylabel('f(x)');
    title('Alternation of the objective function by the evolution of x')
    grid on
end