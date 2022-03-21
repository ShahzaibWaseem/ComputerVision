% Q2.1.4
close all;
clear all;

pano_left = imread("../data/pano_left.jpg");
pano_right = imread("../data/pano_right.jpg");

[locs1, locs2] = matchPics(pano_left, pano_right);

[bestH2to1, inliers] = computeH_ransac(locs1, locs2)