function [locs1, locs2] = matchPics(I1, I2)
	%% MATCHPICS Extract features, obtain their descriptors, and match them!
	%% Convert images to grayscale, if necessary
	if size(I1, 3) ~= 1
		I1 = rgb2gray(I1);
	end
	if size(I2, 3) ~= 1
		I2 = rgb2gray(I2);
	end

	%% Detect features in both images
	features1 = detectFASTFeatures(I1);
	features2 = detectFASTFeatures(I2);

	%% Obtain descriptors for the computed feature locations
	[desc1, locs1] = computeBrief(I1, features1.Location);
	[desc2, locs2] = computeBrief(I2, features2.Location);

	%% Match features using the descriptors
	%% MaxRatio default value 0.6 (increase the value to get more hits).
	matched_features = matchFeatures(desc1, desc2, "MaxRatio", 0.8, "MatchThreshold", 100.0);
	locs1 = locs1(matched_features(:, 1), :);
	locs2 = locs2(matched_features(:, 2), :);
end