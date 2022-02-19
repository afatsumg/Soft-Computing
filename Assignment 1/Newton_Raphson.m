clc;clear
syms x

func = (x-1)^2*(x-2)*(x-3); %Cost function
fplot(func,[0,4]);

g = diff(func); %First derivative of the cost function
H = diff(func,2); %Second derivative of the cost function (Hessian)

%First step: initialization
x_init = 2.5;
epsilon = 10*10^-10;
deltaX = 0;

for k=1:100
    x_values(k) = x_init;
    cost_func_values(k) = vpa(subs(func,x,x_init));
    derivative_values(k) = vpa(subs(g,x,x_init)); %Calculating the value of function derivative at x_init
    second_derivative = vpa(subs(H,x,x_init)); %Calculating the value of functions second derivative at x_init
    fprintf('Iteration %d: x=%.20f, err=%.20f\n', k, x_values(k), derivative_values(k));
    %Second step: calculating the delta
    deltaX = -derivative_values(k)/second_derivative;
    %Third step: calculating the next x
    x_next = x_init+deltaX;
    %Fourth step: check if the derivative<epsilon
    if(abs(vpa(subs(g,x,x_next)))<epsilon)
       break 
    end
    x_init = x_next;
end
%Plot
tiledlayout(3,1);
ax1 = nexttile;
plot(x_values,'-ro')
xlabel('Iteration Number');
ylabel('x');
title('Change of the x versus iteration number')
grid on

ax2 = nexttile;
plot(cost_func_values,'-bo')
xlabel('Iteration Number');
ylabel('f(x)');
title('Alternation of the objective function by the evolution of x')
grid on

ax3 = nexttile;
plot(derivative_values,'-o')
xlabel('Iteration Number');
ylabel('f''(x)');
title(' Gradient information versus iteration number')
grid on