%% Network defintion
layers = get_lenet();

%% Loading data
fullset = false;
[xtrain, ytrain, xvalidate, yvalidate, xtest, ytest] = load_mnist(fullset);

% load the trained weights
load lenet.mat

%% Testing the network
% Modify the code to get the confusion matrix
prediction = [];
actual = [];
for i=1:100:size(xtest, 2)
	[output, P] = convnet_forward(params, layers, xtest(:, i:i+99));
	[~, pred] = max(P);		% max value, argmax
	actual = [actual, ytest(:, i:i+99)];
	prediction = [prediction, pred];
end

confusion = confusionmat(actual, prediction);
disp(confusion);

confusionchart(confusion);
saveas(gcf, "../results/confusion.png");