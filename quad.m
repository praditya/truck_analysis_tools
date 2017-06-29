function [ y ] = quad( a,b,c )
%QUAD Summary of this function goes here
%   Detailed explanation goes here
det = sqrt(4*a*c-b^2);
y = [(b+det)/(2*a) (b-det)/(2*a)];

end

