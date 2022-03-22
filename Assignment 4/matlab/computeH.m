function [H2to1] = computeH(x, x_prime)
	%% COMPUTEH Computes the homography between two sets of points
	y = x(:, 2);
	x = x(:, 1);
	y_p = x_prime(:, 2);
	x_p = x_prime(:, 1);

	A = zeros(2 * size(x, 1), 9);

	for i = 1:size(x)
		A(2*i-1:2*i, :) = [[-x_p(i), -y_p(i), -1, 0, 0, 0, x_p(i) * x(i), x(i) * y_p(i), x(i)]; ...
						   [0, 0, 0, -x_p(i), -y_p(i), -1, y(i) * x_p(i), y(i) * y_p(i), y(i)]];
	end
	% Singular Vector (or eigenvector) with lowest corresponding Singular Value (or eigenvalue) is the solution
	[~, ~, V] = svd(A);

	% MATLAB has the lowest singular vector at the end
	H2to1 = V(:, end);
	H2to1 = reshape(H2to1, [3, 3])';
end