function P = estimate_pose(x, X)
	% ESTIMATE_POSE computes the pose matrix (camera matrix) P given 2D and 3D
	% points.
	%	Args:
	%		x: 2D points with shape [2, N]
	%		X: 3D points with shape [3, N]
	y = x(2, :);
	x = x(1, :);
	Z = X(3, :);
	Y = X(2, :);
	X = X(1, :);

	A = zeros(2 * size(x, 2), 12);
	for i = 1:size(x)
		A(2*i-1:2*i, :) = [[-X(i), -Y(i), -Z(i), -1, 0, 0, 0, 0, X(i) * x(i), Y(i) * x(i), Z(i) * x(i), x(i)]; ...
						   [0, 0, 0, 0, -X(i), -Y(i), -Z(i), -1, X(i) * y(i), Y(i) * y(i), Z(i) * y(i), y(i)]];
	end
	% Singular Vector (or eigenvector) with lowest corresponding Singular Value (or eigenvalue) is the solution
	[~, ~, V] = svd(A);

	% MATLAB has the lowest singular vector at the end
	P = V(:, end);
	P = reshape(P, [4, 3])';
end