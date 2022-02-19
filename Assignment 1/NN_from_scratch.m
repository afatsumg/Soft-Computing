%X -> ages y -> weights
%% Preprocess Data and define hyperparameters
clc;clear;
data=readtable('Kitap1.csv'); %Read data from csv file
train = normalize_data(data.Var1);
test = normalize_data(data.Var2);
alldata = [train,test];
data = array2table(alldata);
% Shuffle data and divide(train: 70%, test: 30%)
cv = cvpartition(size(data,1),'HoldOut',0.3);
idx = cv.test;
% Separate to training and test data
dataTrain = data(~idx,:);
dataTest  = data(idx,:);

data_length = size(data);

X_train = dataTrain(:,1);
y_train = dataTrain(:,2);

X_test = dataTest(:,1);
y_test = dataTest(:,2);

train_length = size(X_train);
max_iteration = 1000;
input_layer = 1;
hidden_layer = 5;
output_layer = 1;
learning_rate = 1;
max_epoch = 100;
epoch = 1;
%% Initialization

for i = 1:train_length(2) 
    for j = 1:hidden_layer
        w1(i,j) = 0.1*randn; %Hidden Layer Initialization
        b1(i,j) = 0.05*randn;
    end
end
W1 = [transpose(b1),transpose(w1)];
for i = 1:hidden_layer
    for j = 1:output_layer
        w2(i,j) = 0.1*randn; %Output Layer Initialization
        b2(j) = 0.05*randn;
    end
end
W2 = [b2;w2];

%% Train
while(epoch ~= max_epoch)
    for i=1:length(X_train.alldata1)
        x = [1;X_train.alldata1(i,:)]; %Add bias term to input layer

        for j = 1:hidden_layer
            v1(j) =W1(j,:)*x;
            y1(j) = sigmo(v1(j));
        end

        a = [1,y1]; %Add bias term to hidden layer

        for j = 1:output_layer
            r = W2(:,j);
            v2(j) = transpose(r)*transpose(a);
            y2(j) = relu(v2(j));
        end
        instant_error = (y_train.alldata2(i,:) - y2);
        train_error(i,:) = (y_train.alldata2(i,:) - y2);
        %Backpropogation
        for k = 1:hidden_layer + 1
            for j = 1:output_layer
                dO(k,j) = learning_rate*a(k)*derivative_sigmoid(v2)*instant_error; %update for output layer
            end
        end

        for k = 1:length(x) %Input layer
            for j = 1:hidden_layer
                dW(j,k) = learning_rate*x(k)*derivative_sigmoid(v1(j))*derivative_relu(v2)*instant_error*W2(j); %Hidden Layer Initialization
            end
        end
        W1 = W1 + dW;
        W2 = W2 + dO;
    end     
    RMS_val(epoch) = mse(train_error,1);
    fprintf('Epoch %d: ,err=%.20f\n', epoch, RMS_val(epoch));
    epoch = epoch + 1;
end
%% Test
for i=1:length(X_test.alldata1)
        x = [1;X_test.alldata1(i,:)]; %Add bias term to input layer

        for j = 1:hidden_layer
            v1(j) =W1(j,:)*x;
            y1(j) = sigmo(v1(j));
        end

        a = [1,y1]; %Add bias term to hidden layer

        for j = 1:output_layer
            r = W2(:,j);
            v2(j) = transpose(r)*transpose(a);
            y2(j) = relu(v2(j));
        end
        instant_error = (y_test.alldata2(i,:) - y2);
        test_error(i,:) = (y_test.alldata2(i,:) - y2);
end

test_err = mse(test_error,1);
fprintf('test err=%.20f\n', test_err);

function z = sigmo(x)
z = 1./(1+exp(-x));
end

function z = derivative_sigmoid(x)
z = exp(-x)/((1+exp(-x))^2);
end

function z = relu(x)
if x<=0
    z = 0;
else
    z = x;
end
end

function z = derivative_relu(x)
if x<=0
    z = 0;
else
    z = 1;
end
end

function z = normalize_data(x)
z = (x - min(x))/(max(x) - min(x));
end