function [output] = pooling_layer_forward(input, layer)
	h_in = input.height;
	w_in = input.width;
	channel = input.channel;
	batch_size = input.batch_size;
	k = layer.k;    % kernel size
	pad = layer.pad;
	stride = layer.stride;

	h_out = (h_in + 2*pad - k) / stride + 1;
	w_out = (w_in + 2*pad - k) / stride + 1;

	output.height = h_out;
	output.width = w_out;
	output.channel = channel;
	output.batch_size = batch_size;

	% Replace the following line with your implementation.
	output.data = zeros([h_out, w_out, channel, batch_size]);
	for batch = 1:batch_size
		image = reshape(input.data(:, batch), h_in, w_in, channel);
		image = padarray(image, [pad pad]); % Image Processing Toolbox required for this
		for c = 1:channel
			for w = 1:w_out
				for h = 1:h_out
					pool_window = image((h-1)*stride+1 : (h-1)*stride+k, (w-1)*stride+1 : (w-1)*stride+k, c);
					output.data(h, w, c, batch) = max(pool_window, [], "all");
				end % width
			end % height
		end % channel
	end % batch

	output.data = reshape(output.data, h_out * w_out * channel, batch_size);
end