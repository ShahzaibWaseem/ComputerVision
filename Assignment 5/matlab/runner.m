close all;
clear all;

image1 = imread("../data/im1.png");
image2 = imread("../data/im2.png");

corresp = load("../data/someCorresp.mat");
intrinsic = load("../data/intrinsics.mat");

% Testing eightpoint algorithm
F = eightpoint(corresp.pts1, corresp.pts2, corresp.M);
displayEpipolarF(image1, image2, F);

% Testing epipolarCorrespondence task
pts2 = epipolarCorrespondence(image1, image2, F, corresp.pts1);
[coords_im1, coords_im2] = epipolarMatchGUI(image1, image2, F);

% Testing the essential matrix calculation
E = essentialMatrix(F, intrinsic.K1, intrinsic.K2);