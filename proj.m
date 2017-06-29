function [ val ] = proj( a, b )
%PROJ Summary of this function goes here
%   Detailed explanation goes here
scale = dot(a,b)/(a.x^2 + a.y^2);
if (scale < 0)
    scale = 0;
else
    if scale > 1
        scale = 1;
    end
end
val.x = scale*a.x;
val.y = scale*a.y;

end

