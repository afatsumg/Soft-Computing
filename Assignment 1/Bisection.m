clc;clear
syms x

func = (x-1)^2*(x-2)*(x-3); %Cost function

g = diff(func); %First derivative of the cost function
H = diff(func,2);
%First step: initialization
epsilon = 10^-4;
alpha_a = 1.8;
alpha_b = 3;

for k=1:100
    alpha_k = alpha_a + (alpha_b-alpha_a)/2;
    
    alpha_values(k) = alpha_k;
    alpha_derivative_values(k) = vpa(subs(g,x,alpha_k));
    alpha_gradient_values(k) = vpa(subs(H,x,alpha_k));
    
    if(vpa(subs(g,x,alpha_k)) == 0)
        break
    elseif(alpha_b-alpha_a < epsilon)
        break
    elseif(vpa(subs(g,x,alpha_k))*vpa(subs(g,x,alpha_a))>0)
        alpha_a = alpha_k;
    else
        alpha_b = alpha_k;
    end
end
%Plot
tiledlayout(3,1);
ax1 = nexttile;
plot(alpha_values,'-ro')
xlabel('Iteration Number');
ylabel('x');
title('Change of the x versus iteration number')
grid on

ax2 = nexttile;
plot(alpha_derivative_values,'-bo')
xlabel('Iteration Number');
ylabel('f(x)');
title('Alternation of the objective function by the evolution of x')
grid on

ax3 = nexttile;
plot(alpha_gradient_values,'-o')
xlabel('Iteration Number');
ylabel('f''(x)');
title(' Gradient information versus iteration number')
grid on