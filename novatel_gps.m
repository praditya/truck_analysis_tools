function [ gps ] = novatel_gps(S)
%NOVATEL_GPS reads novatel GPS data & returns struct of useful data
%   Detailed explanation goes here
    inspvax = finddata(S,':novatel data:inspvax'); %bestpos
%     H = finddata(S,':novatel data:heading');
%     V = finddata(S,':novatel data:bestvel');
%     R = finddata(S,':novatel data:headingrate');
    
    gps = struct();
    if(isempty(fieldnames(inspvax)))
        return
    end
    Data = timeseries([inspvax.(17) inspvax.(18) inspvax.(19) inspvax.(21) inspvax.(22) inspvax.(23) inspvax.(24) inspvax.(25) inspvax.(26)], inspvax.(1));
    data = Data.data;
    time = Data.time;
    
    gps.time = time;
    gps.lat = data(:,1);
    gps.long = data(:,2);
    gps.alt = data(:,3);
    gps.Nspeed = data(:,4);
    gps.Espeed = data(:,5);
    gps.Uspeed = data(:,6);
    gps.roll = data(:,7);
    gps.pitch = data(:,8);
    gps.azimuth = data(:,9);
    
    [gps.N, gps.E, utmzone] = deg2utm(gps.lat,gps.long);
    gps.speed = sqrt(gps.Nspeed.^2+gps.Espeed.^2 + gps.Uspeed.^2);
%     gps.headingxy(:,1:2) = [sind(gps.heading) cosd(gps.heading)];
%     gps.speedxy(:,1:2) = [sind(gps.vheading).*gps.speed cosd(gps.vheading).*gps.speed];
end