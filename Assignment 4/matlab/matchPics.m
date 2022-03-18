function [locs1, locs2] = matchPics(I1, I2)
	% MATCHPICS Extract features, obtain their descriptors, and match them!
	img1 = I1; img2 = I2;

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
	matchedFeatures = matchFeatures(desc1, desc2, "MatchThreshold", 10.0);
	locs1 = locs1(matchedFeatures(:,1),:);
	locs2 = locs2(matchedFeatures(:,2),:);

	%% Displaying matched features
	fig = figure; ax = axes;
	showMatchedFeatures(img1, img2, locs1, locs2, "montage", "Parent", ax);
	legend(ax, "Matched points 1", "Matched points 2");
	title(ax, "Matched (FAST) features points using BREIF descriptor.");
	frame = getframe(fig);
	imwrite(frame2im(frame), "../results/matchPics.png");
end