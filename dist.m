function [ val ] = dist( a,b )
%DIST Summary of this function goes here
%   Detailed explanation goes here
val = sqrt((a.x - b.x)^2 + (a.y - b.y)^2);

end

