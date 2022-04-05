close all;
clear all;
% A test script using templeCoords.mat

% 1. Load the two images and the point correspondences from someCorresp.mat
image1 = imread("../data/im1.png");
image2 = imread("../data/im2.png");

load("../data/someCorresp.mat");

% 2. Run eightpoint to compute the fundamental matrix F
F = eightpoint(pts1, pts2, M);

% 3. Load the points in image 1 contained in templeCoords.mat and run your epipolarCorrespondences on them to get the corresponding points in image
load("../data/templeCoords.mat");
pts2 = epipolarCorrespondence(image1, image2, F, pts1);

% 4. Load intrinsics.mat and compute the essential matrix E.
intrinsic = load("../data/intrinsics.mat");
E = essentialMatrix(F, intrinsic.K1, intrinsic.K2);

% 5. Compute the first camera projection matrix P1 and use camera2.m to compute the four candidates for P2
P1 = intrinsic.K1 * [eye(3), zeros(3, 1)];
P2 = camera2(E);

% 6. Run your triangulate function using the four sets of camera matrix candidates, the points from templeCoords.mat and their computed correspondences.
% 7. Figure out the correct P2 and the corresponding 3D points.
%	Hint: You'll get 4 projection matrix candidates for camera2 from the essential matrix.
%	The correct configuration is the one for which most of the 3D points are in front of both cameras (positive depth).
bestP2 = zeros(3, 4);
bestPts3D = zeros(size(pts1, 1), 3);
maxInFront = 0;

for i = 1:size(P2, 3)
	P2(:, :, i) = intrinsic.K2 * P2(:, :, i);
	pts3D = triangulate(P1, pts1, P2(:, :, i), pts2);

	inFront = sum(pts3D(:, 3) > 0);
	if inFront > maxInFront
		maxInFront = inFront;
		bestP2 = P2(:, :, i);
		bestPts3D = pts3D;
	end
end

proj1 = (P1 * [bestPts3D ones(size(bestPts3D, 1), 1)]')';
proj1 = proj1(:, 1:2) ./ proj1(:, 3);

proj2 = (bestP2 * [bestPts3D ones(size(bestPts3D, 1), 1)]')';
proj2 = proj2(:, 1:2) ./ proj2(:, 3);

reproj_1 = sqrt(sum((pts1 - proj1) .^ 2, "all")) / size(pts1, 1);
reproj_2 = sqrt(sum((pts2 - proj2) .^ 2, "all")) / size(pts2, 1);

reproj_1
reproj_2

% 8. Use matlab's plot3 function to plot these point correspondences on screen. Please type "axis equal" after "plot3" to scale axes to the same unit.
plot3(bestPts3D(:, 1), bestPts3D(:, 2), bestPts3D(:, 3), "b.");
axis equal;
rotate3d on;

% 9. Save your computed rotation matrix (R1, R2) and translation (t1, t2) to the file ../data/extrinsics.mat. These extrinsic parameters will be used in the next section.
% save extrinsic parameters for dense reconstruction
R1 = P1(:, 1:3);
t1 = P1(:, 4);
R2 = bestP2(:, 1:3);
t2 = bestP2(:, 4);
save("../data/extrinsics.mat", "R1", "t1", "R2", "t2");