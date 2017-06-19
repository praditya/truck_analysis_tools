%%plot GPS data
plot(gps.N,gps.E,'.')
% figure()
% quiver(gps.N,gps.E,gps.speedxy(:,1),gps.speedxy(:,2))
% figure()
% plot(gps.time,gps.latstd,gps.time,gps.longstd)
% legend 'latstd' 'longstd'
% axis([gps.time(1) gps.time(end) 0 5])
% figure()
% hold on
% circleplot(gps.N,gps.E,gps.latstd,gps.longstd)
pathwrite('loop1.kml',gps.lat,gps.long,gps.alt)