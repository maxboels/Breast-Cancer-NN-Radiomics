% Solve a Pattern Recognition Problem with a Neural Network
% Script generated by Neural Pattern Recognition app
% Created 13-Mar-2020 23:06:38
% This script assumes these variables are defined:
% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
% Scaled conjugate gradient backpropagation.
% Create a Pattern Recognition Network
%   cancerInputs - input data.
%   cancerTargets - target data.
clear all
[x,t] = cancer_dataset;

NODES = [2 8 32];
EPOCHS = [4 8 16 32 64];
N = 30;
% % trainPercentErrors = zeros(1, N);
% trainAvgError = zeros(length(NODES), length(EPOCHS));
% % testPercentErrors = zeros(1, N);
% testAvgError = zeros(length(NODES), length(EPOCHS));
% trainStdev = zeros(length(NODES), length(EPOCHS));
% testStdev = zeros(length(NODES), length(EPOCHS));

for node = 1:length(NODES)
  for epoch = 1:length(EPOCHS)
    for n = 1:N
    hiddenLayerSize = NODES(node);
    trainFcn = 'trainscg';
    net = patternnet(hiddenLayerSize, trainFcn);
    net.trainParam.epochs = EPOCHS(epoch);
    net.input.processFcns = {'removeconstantrows','mapminmax'};

    % Setup Division of Data for Training, Validation, Testing
    % For a list of all data division functions type: help nndivision
    net.divideFcn = 'dividerand';  % Divide data randomly
    net.divideMode = 'sample';  % Divide up every sample
    net.divideParam.trainRatio = 50/100;
    net.divideParam.valRatio = 0/100;
    net.divideParam.testRatio = 50/100;

    % Choose a Performance Function
    % For a list of all performance functions type: help nnperformance
    net.performFcn = 'crossentropy';  % Cross-Entropy

    % Choose Plot Functions
    % For a list of all plot functions type: help nnplot
    net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
                    'plotconfusion', 'plotroc'};

    % Train the Network
    [net,tr] = train(net,x,t);

    % Test the Network
    y = net(x); %y is the classification result of the input x (2d vector)
    e = gsubtract(t,y);
    performance = perform(net,t,y)
    tind = vec2ind(t); %tind is the target class.
    yind = vec2ind(y); %yind is the predicted class.

    % target truth splitted into train and test sets based on index.
    t_train = tind(tr.trainInd);
    t_test = tind(tr.testInd);
    % output predict splitted into train and test sets based on index.
    y_train = yind(tr.trainInd);
    y_test = yind(tr.testInd);

    % training and test Errors
    trainPercentErrors(n) = sum(t_train ~= y_train)/numel(t_train);
    testPercentErrors(n) = sum(t_test ~= y_test)/numel(t_test);
    end
    % train and test error and std
    trainAvgError(node, epoch) = mean(trainPercentErrors);
    trainStdev(node, epoch) = std(trainPercentErrors);
    testAvgError(node, epoch) = mean(testPercentErrors);
    testStdev(node, epoch) = std(testPercentErrors);
  end
end

hold off
figure()
for n = 1:length(NODES)
    plot(EPOCHS, trainAvgError(n,:));
    hold on
end
legend('2 nodes', '8 nodes', '32 nodes')
title('Training Error Rate, Epochs, Nodes')
xlabel('Epochs')
ylabel('Average Error (%)')
hold off

% test error
figure()
for n = 1:length(NODES)
    plot(EPOCHS, testAvgError(n,:));
    hold on
end
legend('2 nodes', '8 nodes', '32 nodes')
title('Testing Error Rate, Epochs, Nodes')
xlabel('Epochs')
ylabel('Average Error (%)')
hold off

% train error
figure()
for n = 1:length(NODES)
    plot(EPOCHS, trainStdev(n,:));
    hold on
end
legend('2 nodes', '8 nodes', '32 nodes')
title('Training Std Rate, Epochs, Nodes')
xlabel('Epochs')
ylabel('Average Std')
hold off

% Test std
hold off
figure()
for n = 1:length(NODES)
    plot(EPOCHS, testStdev(n,:));
    hold on
end
legend('2 nodes', '8 nodes', '32 nodes')
title('Test Std Rate, Epochs, Nodes')
xlabel('Epochs')
ylabel('Average Std')
hold off










% Recalculate Training, Validation and Test Performance
trainTargets = t .* tr.trainMask{1};
%valTargets = t .* tr.valMask{1};
testTargets = t .* tr.testMask{1};
%Print performances:
trainPerformance = perform(net,trainTargets,y)
%valPerformance = perform(net,valTargets,y)
testPerformance = perform(net,testTargets,y)

% View the Network
view(net)

% Plots
% Uncomment these lines to enable various plots.
% figure, plotperform(tr)
% figure, plottrainstate(tr)
% figure, ploterrhist(e)
% figure, plotconfusion(t,y)
% figure, plotroc(t,y)

% Deployment
% Change the (false) values to (true) to enable the following code blocks.
% See the help for each generation function for more information.
if (false)
    % Generate MATLAB function for neural network for application
    % deployment in MATLAB scripts or with MATLAB Compiler and Builder
    % tools, or simply to examine the calculations your trained neural
    % network performs.
    genFunction(net,'myNeuralNetworkFunction');
    y = myNeuralNetworkFunction(x);
end
if (false)
    % Generate a matrix-only MATLAB function for neural network code
    % generation with MATLAB Coder tools.
    genFunction(net,'myNeuralNetworkFunction','MatrixOnly','yes');
    y = myNeuralNetworkFunction(x);
end
if (false)
    % Generate a Simulink diagram for simulation or deployment with.
    % Simulink Coder tools.
    gensim(net);
end