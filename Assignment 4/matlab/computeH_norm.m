function [H2to1] = computeH_norm(x, x_prime)
	%% Compute centroids of the points
	centroid1 = mean(x);
	centroid2 = mean(x_prime);

	%% Shift the origin of the points to the centroid
	x = x - centroid1;
	x_prime = x_prime - centroid2;

	%% Normalize the points so that the average distance from the origin is equal to sqrt(2).
	scx = sqrt(2) / mean(computeDist(x));
	x = x * scx;

	scx_prime = sqrt(2) / mean(computeDist(x_prime));
	x_prime	= x_prime * scx_prime;

	%% MathWorks
	%% Hnorm = [1/scx 0 -mxx/scx;0 1/scy -myy/scy;0 0 1];
	%% centriod(1) = x centriod; centroid(2) = y centroid
	%% similarity transform 1
	T1 = [scx 0 -centroid1(1) * scx; 0 scx -centroid1(2) * scx; 0 0 1];

	%% similarity transform 2
	T2 = [scx_prime 0 -centroid2(1) * scx_prime; 0 scx_prime -centroid2(2) * scx_prime; 0 0 1];

	%% Compute Homography
	H = computeH(x, x_prime);

	%% Denormalization
	%% \ is used for normalization in MATLAB
	H2to1 = T1 \ H * T2;
end

function [dist] = computeDist(points)
	x_c = points(:, 1); y_c = points(:, 2);
	dist = x_c .^ 2 + y_c .^ 2;
	dist = dist .^ (1/2);
end