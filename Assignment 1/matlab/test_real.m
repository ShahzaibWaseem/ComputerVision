% Network defintion
layers = get_lenet();

% Loading data
files = dir(strcat("../real_images/", "*.JPG"));
files = {files.name};

layers{1}.batch_size = length(files);

x_test = zeros(784, layers{1}.batch_size);
y_test = zeros(1, layers{1}.batch_size);

for filenum = 1:numel(files)
	x = imbinarize(rgb2gray(imread(strcat("../real_images/", files{filenum}))));
	x = imresize(x, [28, 28]);
	x = imcomplement(im2double(x));
	x = reshape(x', [28*28, 1]);
	x_test(:, filenum) = x;

	y = split(files{filenum}, ".");
	y_test(:, filenum) = str2num(y{1});
end

% load the trained weights
load lenet.mat

% Testing the network
[output, P] = convnet_forward(params, layers, x_test);
[~, pred] = max(P);

% Result Output
pred - 1
y_test