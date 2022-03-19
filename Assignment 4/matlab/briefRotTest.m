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

	%% Match features (for BRIEF)
	[brief_locs1, brief_locs2] = matchPics(image, rotated_image);

	%% Update histogram
	brief_match_list = [brief_match_list, size(brief_locs1, 1)];
	surf_match_list = [surf_match_list, size(surf_locs1, 1)];
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