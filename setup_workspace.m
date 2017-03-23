close all; clear all; clc;
%% read from folder
try
    folder_name = uigetdir('..\Rosbag');
catch
    return
end
if(~exist(strcat(folder_name,'\data.mat')))
    S = csvread_all(folder_name);
    folder_name = strcat(folder_name,'\');
else
    load(strcat(folder_name,'\data.mat'))
    return
end

%% GPS Data
rate = 5; %hz 
gps = novatel_gps(S,rate);
clear rate;
if(isempty(fieldnames(gps)))
    clear gps
end
%% mavros GPS Speed
data = finddata(S,':mavros:local position:velocity');
if(~isempty(fieldnames(data)))
    mavros_spd = timeseries(sqrt(data.(10).^2 + data.(11).^2),data.(1),'Name', 'Mavros Speed (m/s)');
end
clear data;
%% vehicle speed report
data = finddata(S,':pacmod:parsed tx:vehicle speed rpt');
if(~isempty(fieldnames(data)))
    pacmod_spd = timeseries(data.(2)*0.18,data.(1),'Name','Pacmod Speed (m/s)');
end
clear data;
%% accel_rpt
data = finddata(S,':pacmod:parsed tx:accel rpt');
if(~isempty(fieldnames(data)))
    accel_rpt = timeseries(data.(10),data.(1),'Name','Accelerator Report (%)');
end
clear data;
%% steer_rpt
data = finddata(S,':pacmod:parsed tx:steer rpt');
if(~isempty(fieldnames(data)))
    steer_rpt = timeseries(data.(9),data.(1),'Name','Steering Angle (rad)');
end
clear data;
%% cmd_vel
data = finddata(S,':cmd vel with limits');
if(~isempty(fieldnames(data)))
    cmd_vel = timeseries(data.(4),data.(1),'Name','Command Speed (m/s)');
end
clear data;
%% accel_cmd
data = finddata(S,':pacmod:as rx:accel cmd');
if(~isempty(fieldnames(data)))
    accel_cmd = timeseries(data.(2),data.(1),'Name','Accelerator Command (%)');
end
clear data;
%% req_accel
data = finddata(S,':req accel');
if(~isempty(fieldnames(data)))
    req_accel = timeseries(data.(2),data.(1),'Name','Required Acceleration (m/s^2)');
end
clear data;
%% filtered accel
data = finddata(S,':filtered accel');
if(~isempty(fieldnames(data)))
    filtered_accel = timeseries(data.(2),data.(1),'Name','Filtered Acceleration (m/s^2)');
end
clear data;
%% end
clear S;
save(strcat(folder_name,'data.mat'));
plot_data
