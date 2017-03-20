function circle(x,y,r1,r2)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
% ang=0:0.01:2*pi; 
xp=r1*[1 0 -1 0 1];
yp=r2*[0 1 0 -1 0];
hold on;
plot(x+xp,y+yp, '-b');
end
