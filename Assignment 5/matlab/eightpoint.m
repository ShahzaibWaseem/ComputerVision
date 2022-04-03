function F = eightpoint(pts1, pts2, M)
	% eightpoint:
	%	pts1 - Nx2 matrix of (x,y) coordinates
	%	pts2 - Nx2 matrix of (x,y) coordinates
	%	M	 - max (imwidth, imheight)

	% Q2.1 - Todo:
	%	Implement the eightpoint algorithm
	%	Generate a matrix F from correspondence "../data/some_corresp.mat"

	% 0. Normalize points
	pts1 = pts1 / M;
	pts2 = pts2 / M;

	x = pts1(:, 1);
	y = pts1(:, 2);
	x_p = pts2(:, 1);
	y_p = pts2(:, 2);

	% 1. Construct the M x 9 matrix A
	A = [x_p.*x, x_p.*y, x_p, y_p.*x, y_p.*y, y_p, x, y, ones(size(pts1, 1), 1)];

	% 2. Find the SVD of A
	[~, ~, V] = svd(A);

	% 3. Entries of F are the elements of column of V corresponding to the least singular value
	F = reshape(V(:, 9), [3, 3]);

	% 4. Enforce rank 2 constraint on F
	[U, Sig, V] = svd(F);
	Sig(3, 3) = 0;
	F = U * Sig * V';

	F = refineF(F, pts1, pts2);

	% 5. Un-normalize F
	T = [1/M 0 0; 0 1/M 0; 0 0 1];		% scale
	F = T' * F * T;
end