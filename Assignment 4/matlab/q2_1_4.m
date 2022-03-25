% Q4.1 - 4.4
close all;
clear all;

cv_cover = imread("../data/cv_cover.jpg");
cv_desk = imread("../data/cv_desk.png");

[locs1, locs2] = matchPics(cv_cover, cv_desk);

%% Displaying matched features
fig = figure; ax = axes;
showMatchedFeatures(cv_cover, cv_desk, locs1, locs2, "montage", "Parent", ax);
legend(ax, "Matched points 1", "Matched points 2");
title(ax, "Matched (FAST) features points using BRIEF descriptor.");
frame = getframe(fig);
imwrite(frame2im(frame), "../results/matchPics.png");