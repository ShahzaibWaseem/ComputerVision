function dispM = get_disparity(im1, im2, maxDisp, windowSize)
	% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
	%	im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.
	mask = ones(windowSize, windowSize);
	im1 = im2double(im1); im2 = im2double(im2);
	dispM = zeros(size(im1));
	minDisp = ones(size(im1)) * Inf;

	for d = 1:maxDisp
		im2_translated = imtranslate(im2, [d, 0]);
		disp = conv2((im1 - im2_translated) .^ 2, mask, "same");
		dispM(disp < minDisp) = d;
		if (disp < minDisp)
			minDisp = disp;
		end
	end
end