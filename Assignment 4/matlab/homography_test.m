% Q4.1 - 4.4
close all;
clear all;

pano_left = imread("../data/pano_left.jpg");
pano_right = imread("../data/pano_right.jpg");

[locs1, locs2] = matchPics(pano_left, pano_right);

idy = randi([1, size(pano_left, 1)], 1, 10);		% 10 random points
idx = randi([1, size(pano_left, 2)], 1, 10);

rand_locs1 = [idx; idy]';
locs1_appended = horzcat(rand_locs1, ones(size(rand_locs1, 1), 1))';

[H2to1] = computeH(locs1, locs2);

locs2_gen = (H2to1 * locs1_appended)';
locs2_gen = locs2_gen(:, 1:2) ./ locs2_gen(:, 3)

%% Visualize the point-pairs.
fig = figure; ax = axes;
showMatchedFeatures(pano_left, pano_right, rand_locs1, locs2_gen, "montage", "Parent", ax);
legend(ax, "Matched points 1", "Matched points 2");
title(ax, "Planar Homography");
frame = getframe(fig);
imwrite(frame2im(frame), "../results/homography.png");

[H2to1] = computeH_norm(locs1, locs2);

locs2_gen = (H2to1 * locs1_appended)';
locs2_gen = locs2_gen(:, 1:2) ./ locs2_gen(:, 3)

%% Visualize the point-pairs.
fig = figure; ax = axes;
showMatchedFeatures(pano_left, pano_right, rand_locs1, locs2_gen, "montage", "Parent", ax);
legend(ax, "Matched points 1", "Matched points 2");
title(ax, "Normalized Planar Homography");
frame = getframe(fig);
imwrite(frame2im(frame), "../results/homography_norm.png");