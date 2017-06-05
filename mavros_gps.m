function [ gps ] = mavros_gps( S )
%NOVATEL_GPS reads novatel GPS data & returns struct of useful data
%   Detailed explanation goes here
    B = finddata(S,':mavros:global position:global'); %bestpos
   
    gps = struct();
    if(isempty(fieldnames(B)))
        return
    end
    bp = timeseries([B.(11) B.(12) B.(13)],B.(1));
    data = bp.Data;
    time = bp.Time;
    
    gps.time = time;
    gps.lat = data(:,1);
    gps.long = data(:,2);
    gps.alt = data(:,3);
        
    [gps.N, gps.E, utmzone] = deg2utm(gps.lat,gps.long);
    
end