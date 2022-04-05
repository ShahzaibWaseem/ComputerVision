function depthM = get_depth(dispM, K1, K2, R1, R2, t1, t2)
	% GET_DEPTH creates a depth map from a disparity map (DISPM).
	% t1n = -R1n * c1;
	% t2n = -R2n * c2;

	c1 = - inv(R1) * t1;
	c2 = - inv(R2) * t2;
	b = norm(c1 - c2);

	f = K1(1, 1);

	depthM = b * f ./ dispM;
	depthM(isnan(depthM)) = 0;
end