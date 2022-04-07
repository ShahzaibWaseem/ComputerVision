close all;
clear all;

% 1. Load an image, a CAD model cad, 2D points x and 3D points X from PnP.mat.
load("../data/PnP.mat", "X", "cad", "image", "x");

size(X)
size(x)
size(cad)
size(image)

% 2. Run estimate_pose and estimate_params to estimate camera matrix P, intrinsic matrix K, rotation matrix R, and translation t.
P = estimate_pose(x, X);
[K, R, t] = estimate_params(P);

% 3. Use your estimated camera matrix P to project the given 3D points X onto the image.
projection = P * [X; ones(1, size(X, 2))];
projection = projection(1:2, :) ./ projection(end, :);

% 4. Plot the given 2D points x and the projected 3D points on screen.
figure; imshow(image,[]); hold on;
plot(x(1, :), x(2, :), ".k");
plot(projection(1, :), projection(2, :), "ob", "MarkerSize", 10);
hold off;

% 5. Draw the CAD model rotated by your estimated rotation R on screen.
rot_cad = cad;
rot_cad.vertices = cad.vertices * R';
figure;
trimesh(cad.faces, rot_cad.vertices(:,1), rot_cad.vertices(:,2), rot_cad.vertices(:,3));

% 6. Project the CAD's all vertices onto the image and draw the projected CAD model overlapping with the 2D image.
projection = [cad.vertices ones(size(cad.vertices, 1), 1)] * P';
projection = projection(:, 1:2) ./ projection(:, end);

figure; ax = axes;
imshow(image);
patch(ax, "Faces", rot_cad.faces, "Vertices", projection, "FaceColor", "Red", "FaceAlpha", 0.3, "EdgeColor", "None");