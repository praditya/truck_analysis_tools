try
    temp_folder_name = uigetdir('../../');
catch
    return
end
wpts.data = csvread(strcat(temp_folder_name,'/waypoints'));
[wpts.N, wpts.E, utmzone] = deg2utm(wpts.data(:,1),wpts.data(:,2));
wpts.lat = wpts.data(:,1);
wpts.long = wpts.data(:,2);
kmlcreate(strcat(temp_folder_name,'/path.kml'),wpts.lat,wpts.long,zeros(length(wpts.long),1));
clear utmzone temp_folder_name