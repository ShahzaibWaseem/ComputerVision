% Q4.1 - 4.4
close all;
clear all;

pano_left = imread("../data/pano_left.jpg");
pano_right = imread("../data/pano_right.jpg");

[locs1, locs2] = matchPics(pano_left, pano_right);

% using first 10 of these random points for homography testing
idx = randperm(size(locs1, 1));

[H2to1] = computeH(locs1(1:10, :), locs2(1:10, :));

locs1_appended = horzcat(locs1(11:20, :), ones(size(locs1(11:20, :), 1), 1))';

locs2_gen = (H2to1 * locs1_appended)';
locs2_gen = locs2_gen(:, 1:2) ./ locs2_gen(:, 3);

%% Visualize the point-pairs.
fig = figure; ax = axes;
showMatchedFeatures(pano_left, pano_right, locs1(11:20, :), locs2_gen, "montage", "Parent", ax);
legend(ax, "Matched points 1", "Matched points 2");
title(ax, "Planar Homography");
frame = getframe(fig);
imwrite(frame2im(frame), "../results/homography.png");

[H2to1] = computeH_norm(locs1(1:10, :), locs2(1:10, :));

locs2_gen = (H2to1 * locs1_appended)';
locs2_gen = locs2_gen(:, 1:2) ./ locs2_gen(:, 3);

%% Visualize the point-pairs.
fig = figure; ax = axes;
showMatchedFeatures(pano_left, pano_right, locs1(11:20, :), locs2_gen, "montage", "Parent", ax);
legend(ax, "Matched points 1", "Matched points 2");
title(ax, "Normalized Planar Homography");
frame = getframe(fig);
imwrite(frame2im(frame), "../results/homography_norm.png");