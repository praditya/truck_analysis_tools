try
    temp_folder_name = uigetdir('../../Rosbag');
catch
    return
end
wpts.data = csvread(strcat(temp_folder_name,'/waypoints'));
[wpts.N, wpts.E, utmzone] = deg2utm(wpts.data(:,1),wpts.data(:,2));
clear utmzone temp_folder_name