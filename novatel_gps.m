function [ gps ] = novatel_gps( S, rate )
%NOVATEL_GPS reads novatel GPS data & returns struct of useful data
%   Detailed explanation goes here
    B = finddata(S,':novatel data:bestpos'); %bestpos
    H = finddata(S,':novatel data:heading');
    V = finddata(S,':novatel data:bestvel');
    R = finddata(S,':novatel data:headingrate');
    
    gps = struct();
    if(isempty(fieldnames(B))||isempty(fieldnames(H))||isempty(fieldnames(V))||isempty(fieldnames(R)))
        return
    end
    bp = timeseries([B.(17) B.(22) B.(18) B.(23) B.(19) B.(24)],B.(1));
    bv = timeseries([V.(19) V.(20)], V.(1));
    h = timeseries([H.(18) H.(21) H.(19) H.(22)],H.(1));
    [bp,bv] = synchronize(bp,bv,'union','KeepOriginalTimes',true);
    temp = timeseries([bp.Data bv.Data], bp.Time);
    [bp,h] = synchronize(temp,h,'union','KeepOriginalTimes',true);
    final = timeseries([bp.Data h.Data], bp.Time);
    
    if(rate)
        [data,time] = resample(final.Data,final.Time,rate,1,1);
    else
        data = final.Data;
        time = final.Time;
    end
    
    gps.time = time;
    gps.lat = data(:,1);
    gps.latstd = data(:,2);
    gps.long = data(:,3);
    gps.longstd = data(:,4);
    gps.alt = data(:,5);
    gps.altstd = data(:,6);
    gps.speed = data(:,7);
    gps.vheading = data(:,8);
    gps.heading = data(:,9);
    gps.headstd = data(:,10);
    gps.pitch = data(:,11);
    gps.pitchstd = data(:,12);
    
    [gps.N, gps.E, utmzone] = deg2utm(gps.lat,gps.long);
    gps.headingxy(:,1:2) = [sind(gps.heading) cosd(gps.heading)];
    gps.speedxy(:,1:2) = [sind(gps.vheading).*gps.speed cosd(gps.vheading).*gps.speed];
end