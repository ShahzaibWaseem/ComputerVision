function [output] = conv_layer_forward(input, layer, param)
	% Conv layer forward
	% input: struct with input data
	% layer: convolution layer struct
	% param: weights for the convolution layer

	% output: struct with output data
	h_in = input.height;
	w_in = input.width;
	channel = input.channel;
	batch_size = input.batch_size;
	k = layer.k;
	pad = layer.pad;
	stride = layer.stride;
	num = layer.num;
	% resolve output shape
	h_out = (h_in + 2*pad - k) / stride + 1;
	w_out = (w_in + 2*pad - k) / stride + 1;

	assert(h_out == floor(h_out), 'h_out is not integer')
	assert(w_out == floor(w_out), 'w_out is not integer')
	input_n.height = h_in;
	input_n.width = w_in;
	input_n.channel = channel;

	%% Fill in the code
	% Iterate over the each image in the batch, compute response,
	% Fill in the output datastructure with data, and the shape. 

	output.height = h_out;
	output.width = w_out;
	output.channel = num;
	output.batch_size = batch_size;

	output.data = zeros([h_out, w_out, num, batch_size]);

	for batch = 1:batch_size
		image = reshape(input.data(:, batch), h_in, w_in, channel);
		image = padarray(image, [pad pad]); % Image Processing Toolbox required for this
		for filter = 1:num
			for w = 1:w_out
				for h = 1:h_out
					% gets the area on which convolution is to be done
					conv_window = image((h-1)*stride+1 : (h-1)*stride+k, (w-1)*stride+1 : (w-1)*stride+k, :);
					weight = reshape(param.w(:, filter), k, k, channel);
					bias = param.b(:, filter);

					% element wise multiplication and summing and adding the bias
					output.data(h, w, filter, batch) = sum(conv_window .* weight, "all") + bias;
				end % width
			end % height
		end % filter
	end % batch

	output.data = reshape(output.data, h_out * w_out * num, batch_size);
end