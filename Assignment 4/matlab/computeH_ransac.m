function [bestH2to1, inliers] = computeH_ransac(locs1, locs2)
	% COMPUTEH_RANSAC A method to compute the best fitting homography given a
	% list of matching points.
	% Q4.5

	% parameters and intermediate variables
	max_count = 0;
	threshold = 1;
	iterations = 1000;

	n_points = size(locs1, 1);
	locs2_temp = horzcat(locs2, ones(n_points, 1));

	% initalize
	bestH2to1 = zeros([3, 3]); inliers = zeros([n_points, 1]);
	bestlocs = [];

	for iter = 1:iterations
		idx = randperm(size(locs1, 1), 4);		% 4 points required
		H2to1 = computeH_norm(locs1(idx, :), locs2(idx, :));
		locs2_gen = (H2to1 * locs2_temp')';
		locs2_gen = locs2_gen(:, 1:2) ./ locs2_gen(:, 3);
		dist = sqrt(sum((locs2_gen-locs1) .^ 2, 2));

		if sum(dist < threshold) > max_count
			bestH2to1 = H2to1;
			inliers = dist < threshold;
			max_count = sum(inliers);
			bestlocs = idx;
		end
	end

	%% Visualize the best point-pairs.
	pano_left = imread("../data/pano_left.jpg");
	pano_right = imread("../data/pano_right.jpg");
	fig = figure; ax = axes;
	showMatchedFeatures(pano_left, pano_right, locs1(bestlocs, :), locs2(bestlocs, :), "montage", "Parent", ax);
	legend(ax, "Matched points 1", "Matched points 2");
	title(ax, "Point-Pairs that produce the most number of inliers (RANSAC).");
	frame = getframe(fig);
	imwrite(frame2im(frame), "../results/ransac.png");
end