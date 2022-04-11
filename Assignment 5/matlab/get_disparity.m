function dispM = get_disparity(im1, im2, maxDisp, windowSize)
	% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
	%	im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.
	mask = ones(windowSize, windowSize);
	im1 = im2double(im1); im2 = im2double(im2);
	dispM = zeros(size(im1)); minDisp = ones(size(im1)) * maxDisp;
	
	for shift = 1:maxDisp
		im2_shifted = circshift(im2, shift, 2);
		disp = conv2((im1 - im2_shifted) .^ 2, mask, "same");
		dispM(disp < minDisp) = shift;
		minDisp = min(minDisp, disp);
		% if (disp < minDisp)
		% 	minDisp = disp;
		% end
	end
end