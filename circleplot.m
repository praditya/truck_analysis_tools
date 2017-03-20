function [  ] = circleplot( x,y,r1,r2 )
%CIRCLEPLOT Summary of this function goes here
%   Detailed explanation goes here
    for i = 1:length(x)  
        circle(x(i),y(i),r1(i),r2(i))
        
    end

end

