clc;clear;
data=readtable('Kitap1.csv');

ages=data{:,1};
weights=data{:,2};
save('mymat.mat','ages','weights') 
%initial_MSE = 0;
 
dim = size(ages);
for i=1:dim(1)
    guess(i) = 233.846*(1-exp(-0.006042*ages(i)));
    MSE_err(i) = weights(i) - guess(i); 
end
MSE = mean(MSE_err.^2);
%% Neural Network Part
x = ages';
t = weights';

% Choose a Training Function
trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.

% Create a Fitting Network
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize,trainFcn);

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y)

% View the Network
%view(net)
plot(ages,weights,'x')
grid on
hold on
plot(ages,guess)
hold on
plot(x,y)
legend('Real Data','Nonlinear Fit','NN Fit')
