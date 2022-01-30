layers = get_lenet();
load lenet.mat
% load data
% Change the following value to true to load the entire dataset.
fullset = false;
[xtrain, ytrain, xvalidate, yvalidate, xtest, ytest] = load_mnist(fullset);
xtrain = [xtrain, xvalidate];
ytrain = [ytrain, yvalidate];
m_train = size(xtrain, 2);
batch_size = 64;

layers{1}.batch_size = 1;
img = xtest(:, 1);
img = reshape(img, 28, 28);

output = convnet_forward(params, layers, xtest(:, 1));

% Fill in your code here to plot the features.
output_1 = reshape(output{1}.data, 28, 28);
conv = reshape(output{2}.data', 24, 24, []);
relu = reshape(output{3}.data', 24, 24, []);

f1 = figure();
sgtitle("Convolution");
for plot = 1:4*5
	subplot(4, 5, plot);
	imshow(conv(:, :, plot)');
end
saveas(f1, "../results/convolution.png");

f2 = figure();
sgtitle("ReLU");
for plot = 1:4*5
	subplot(4, 5, plot);
	imshow(relu(:, :, plot)');
end
saveas(f2, "../results/relu.png");