function [K, R, t] = estimate_params(P)
	% ESTIMATE_PARAMS computes the intrinsic K, rotation R and translation t from
	% given camera matrix P.
	epsilon = 1e-4;
	[~, ~, V] = svd(P);

	% MATLAB has the lowest singular vector at the end
	c = V(:, end) / V(end, end);

	% https://math.stackexchange.com/questions/1640695/rq-decomposition
	
	permutation = flip(diag([1 1 1]), 2);
	A = permutation * P(:, 1:3);

	[Q, R] = qr(A');

	Q = permutation * Q';
	R = permutation * R' * permutation;

	% https://ksimek.github.io/2012/08/14/decompose/
	T = diag(sign(diag(R)));

	K = R * T;
	R = T * Q;

	if (abs(det(R) + 1) < epsilon)
		R = -R;
	end

	t = -R * c(1:3);
end