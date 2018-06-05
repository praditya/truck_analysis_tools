%%plot GPS data
% figure()
if exist('wpts')
    plot(gps.N - wpts.N(1),gps.E - wpts.E(1))
else
    plot(gps.N,gps.E)
end
daspect([1 1 1])
% figure()
% quiver(gps.N,gps.E,gps.Nspeed,gps.Espeed)
% figure()
% plot(gps.time,gps.latstd,gps.time,gps.longstd)
% legend 'latstd' 'longstd'
% axis([gps.time(1) gps.time(end) 0 5])
% figure()
% hold on
% circleplot(gps.N,gps.E,gps.latstd,gps.longstd)
% pathwrite('test.kml',gps.lat,gps.long,gps.alt)
% figure()
% rate = 1./diff(gps.time);
% xfilt = filter(.02/.5, [1 .02/.5-1], diff(gps.speed));
% plot(gps.time(1:end-1),diff(gps.speed).*rate)
% diff(gps.speed)
% figure()
% plot(navsat_odom.Data(:,1), navsat_odom.Data(:,2))