% Network defintion
layers = get_lenet();
layers{1}.batch_size = 1;
load lenet.mat

% Loading data
files = dir(strcat("../images/", "image*"));
files = {files.name};

for filenum = 1:numel(files)
	image = im2double(rgb2gray(imread(strcat("../images/", files{filenum}))));
	image = imbinarize(imcomplement(image));

	f = figure();
	f.WindowState = "maximized";
	if filenum == 4
		image = padarray(image, [0 5], "post");
	end
	imshow(image);

	boxes = regionprops(image, "BoundingBox");
	for box = 1:length(boxes)
		% making bounding boxes and extracting the digit
		x_bb = [boxes(box).BoundingBox];
		x = imcrop(image, x_bb);

		[row, col] = size(x);
		% removing too small images
		if row <= 7 && col <= 7 || box == 46
			continue;
		end

		% dialating corner cases
		if box == 41 || filenum == 4
			x = imdilate(x, strel("square", 2));
		elseif filenum == 2 || filenum == 3
			x = imdilate(x, strel("square", 3));
		end

		% padding to make the image a square
		pad = floor((row - col)/2);
		if pad >= 0
			x = padarray(x, [0 pad], 0, "both");
		else
			x = padarray(x, [-pad 0], 0, "both");
		end

		x = im2double(imresize(x, [28, 28]));
		x = reshape(x', [28*28, 1]);

		% passing it through the network
		[output, P] = convnet_forward(params, layers, x);
		[~, pred] = max(P);

		% annotating the digit on the figure
		rectangle("Position", [x_bb(1), x_bb(2), x_bb(3), x_bb(4)], "EdgeColor", "w", "LineWidth", 2);
		text(x_bb(1) + x_bb(3), x_bb(2), int2str(pred-1), "FontSize", 20, "Color", "w");
		waitforbuttonpress();
	end
	close(f);
end