function [ val ] = online( A,B, pt )
%ONLINE Summary of this function goes here
%   Detailed explanation goes here
%only checking X value becaue point is assumed to already be on the line

% val = (abs(A.x) <= abs(pt.x) && abs(pt.x) <= abs(B.x) && sign(pt.x) == sign(A.x));
dx = B.x-A.x;
dp = pt.x-A.x;
val = (abs(dx) >= abs(dp));

end

