function [pts2] = epipolarCorrespondence(im1, im2, F, pts1)
	% epipolarCorrespondence:
	%	Args:
	%		im1:	Image 1
	%		im2:	Image 2
	%		F:		Fundamental Matrix from im1 to im2
	%		pts1:	coordinates of points in image 1
	%	Returns:
	%		pts2:	coordinates of points in image 2
	window_size = 17;
	h = floor(window_size/2);
	sigma = 5;
	loop_size = 3;

	im1 = rgb2gray(double(im1));
	im2 = rgb2gray(double(im2));

	pts2 = zeros(size(pts1));
	pts1 = [pts1, ones(size(pts1, 1), 1)];

	epi_lines = F * pts1';
	epi_lines = (epi_lines / -epi_lines(2))';

	kernel = fspecial("gaussian", [window_size, window_size], sigma);
	projections = round(cross(epi_lines, [-epi_lines(:, 2), epi_lines(:, 1), epi_lines(:, 2) .* pts1(:, 1) - epi_lines(:, 1) .* pts1(:, 2)]));

	for N=1:size(pts1, 1)
		least_error = Inf;
		best_x2 = 0; best_y2 = 0;

		x1 = pts1(1); y1 = pts1(2);
		window_im1 = im1(y1-h:y1+h, x1-h:x1+h);

		x = projections(N, 1); y = projections(N, 2);
		for x_i=x-loop_size:x+loop_size
			for y_i=y-loop_size:y+loop_size
				window_im2 = im2(y_i-h:y_i+h, x_i-h:x_i+h);
				% euclidean distance: sqrt[sum[(x - x_p)^2]]
				error = sqrt(sum(kernel .* (window_im1 - window_im2) .^ 2, "all"));
				if (error <= least_error)
					least_error = error;
					best_x2 = x_i; best_y2 = y_i;
				end
			end
		end
		pts2(N, :) = [best_x2 best_y2];
	end
end