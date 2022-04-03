close all;
clear all;

image1 = imread("../data/im1.png");
image2 = imread("../data/im2.png");

correspondence = load("../data/someCorresp.mat");
[pts1, pts2, M] = correspondence;

F = eightpoint(pts1, pts2, M);

displayEpipolarF(image1, image2, F);