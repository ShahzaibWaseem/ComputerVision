close all;
clear all;

image1 = imread("../data/im1.png");
image2 = imread("../data/im2.png");

corresp = load("../data/someCorresp.mat");

F = eightpoint(corresp.pts1, corresp.pts2, corresp.M);

displayEpipolarF(image1, image2, F);