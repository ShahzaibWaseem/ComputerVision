%% Your solution to Q2.1.5 goes here!
%% Read the image and convert to grayscale, if necessary
image = imread("../data/cv_cover.jpg");
if size(image, 3) ~= 1
	image = rgb2gray(image);
end

%% Compute the features and descriptors
brief_match_list = []; surf_match_list = [];

for i = 0:36
	%% Rotate image
	rotated_image = imrotate(image, 10*i);

	%% Compute features and descriptors (for SURF)
	surf_features1 = detectSURFFeatures(image);
	surf_features2 = detectSURFFeatures(rotated_image);

	[surf_desc1, surf_locs1] = extractFeatures(image, surf_features1, "Method", "SURF");
	[surf_desc2, surf_locs2] = extractFeatures(rotated_image, surf_features2, "Method", "SURF");

	surf_matched_features = matchFeatures(surf_desc1, surf_desc2, "MaxRatio", 0.8, "MatchThreshold", 10.0);
	surf_locs1 = surf_locs1(surf_matched_features(:, 1), :);
	surf_locs2 = surf_locs2(surf_matched_features(:, 2), :);

	%% Match features (for BRIEF)
	[brief_locs1, brief_locs2] = matchPics(image, rotated_image);

	%% Update histogram
	brief_match_list = [brief_match_list, size(brief_locs1, 1)];
	surf_match_list = [surf_match_list, size(surf_locs1, 1)];

	if i == 4 || i == 9 || i == 18
		fig = figure; ax = axes;
		showMatchedFeatures(image, rotated_image, brief_locs1, brief_locs2, "montage", "Parent", ax);
		legend(ax, "Matched points 1", "Matched points 2");
		title(ax, sprintf("Matched (FAST) features points using BRIEF descriptor (rotated %d degrees)", i*10));
		frame = getframe(fig);
		imwrite(frame2im(frame), sprintf("../results/brief_rot_%d.png", i*10));

		fig = figure; ax = axes;
		showMatchedFeatures(image, rotated_image, surf_locs1, surf_locs2, "montage", "Parent", ax);
		legend(ax, "Matched points 1", "Matched points 2");
		title(ax, sprintf("Matched (FAST) features points using SURF descriptor (rotated %d degrees)", i*10));
		frame = getframe(fig);
		imwrite(frame2im(frame), sprintf("../results/surf_rot_%d.png", i*10));
	end
end

%% Display histogram (BRIEF)
fig = figure; ax = axes;
histogram(brief_match_list, "NumBins", 50, "BinLimits", [0, 600]);
title(ax, "Histogram for BRIEF features between image and rotated image");
ylabel(ax, "Degrees Rotated");
xlabel(ax, "Number of Matched Features");
frame = getframe(fig);
imwrite(frame2im(frame), "../results/hist_brief.png");

%% Display histogram (SURF)
fig = figure; ax = axes;
histogram(surf_match_list, "NumBins", 50, "BinLimits", [0, 600]);
title(ax, "Histogram for SURF features between image and rotated image");
ylabel(ax, "Degrees Rotated");
xlabel(ax, "Number of Matched Features");
frame = getframe(fig);
imwrite(frame2im(frame), "../results/hist_surf.png");

%% Display histogram (BRIEF)
fig = figure; ax = axes;
bar(0:10:360, brief_match_list);
title(ax, "Histogram for BRIEF features between image and rotated image");
xlabel(ax, "Degrees Rotated");
ylabel(ax, "Number of Matched Features");
frame = getframe(fig);
imwrite(frame2im(frame), "../results/bar_brief.png");

%% Display histogram (SURF)
fig = figure; ax = axes;
bar(0:10:360, surf_match_list);
title(ax, "Histogram for SURF features between image and rotated image");
xlabel(ax, "Degrees Rotated");
ylabel(ax, "Number of Matched Features");
frame = getframe(fig);
imwrite(frame2im(frame), "../results/bar_surf.png");