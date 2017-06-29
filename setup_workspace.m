close all; clear all; clc;
%% read from folder
try
    folder_name = uigetdir('../../Rosbag');
catch
    return
end
if(~exist(strcat(folder_name,'/data.mat')))
    S = csvread_all(folder_name);
    folder_name = strcat(folder_name,'/');
else
    load(strcat(folder_name,'/data.mat'))
%     return
end

%% zed_odom
data = finddata(S,'_zed_odom');
if(~isempty(fieldnames(data)))
    zed_odom = timeseries([data.(12) data.(13) data.(14)],data.(1),'Name','Zed Odometry');
end
clear data;
%% corrimudata
data = finddata(S,'_novatel_data_corrimudata');
if(~isempty(fieldnames(data)))
    corrimudata = timeseries([data.(19) data.(20) data.(20)],data.(1),'Name','Acceleration');
end
clear data;
%% Novatel INSPVAX
gps = novatel_gps(S);
% if(isempty(fieldnames(gps)))
%     clear gps
% end
%% navsat Odom
data = finddata(S,'_navsat_odom');
if(~isempty(fieldnames(data)))
    navsat_odom = timeseries([data.(6) data.(7) data.(8) data.(49) data.(50) data.(51)],data.(1),'Name','Navsat Odom');
end
clear data;
%% imu_data
data = finddata(S,'_imu_data');
if(~isempty(fieldnames(data)))
    imu_data = timeseries([data.(18) data.(19) data.(20)],data.(1),'Name','Angular Speed (rad/s)');
end
clear data;
%%
% %% GPS Data
% rate = 5; %hz 
% gps = novatel_gps(S,rate);
% clear rate;
% if(isempty(fieldnames(gps)))
%     clear gps
% end
%% mavros GPS Speed
data = finddata(S,'_mavros_local_position_velocity');
if(~isempty(fieldnames(data)))
    mavros_spd = timeseries(sqrt(data.(10).^2 + data.(11).^2),data.(1),'Name', 'Mavros Speed (m/s)');
end
clear data;
%% mavros GPS Position
% gps = mavros_gps(S);
% clear data;
%% vehicle speed report
data = finddata(S,'_pacmod_parsed_tx_vehicle_speed_rpt');
if(~isempty(fieldnames(data)))
    pacmod_spd = timeseries(data.(2),data.(1),'Name','Pacmod Speed (m/s)');
end
clear data;
%% accel_rpt
data = finddata(S,'_pacmod_parsed_tx_accel_rpt');
if(~isempty(fieldnames(data)))
    accel_rpt = timeseries(data.(7),data.(1),'Name','Accelerator Report (%)');
end
clear data;
%% steer_rpt
data = finddata(S,'_pacmod_parsed_tx_steer_rpt');
if(~isempty(fieldnames(data)))
    steer_rpt = timeseries([data.(6) data.(5)+3.0110],data.(1),'Name','Steering Angle (rad)');
    for j = 1:length(steer_rpt.data(:,1))
       if(steer_rpt.data(j,1) > 30)
           steer_rpt.data(j,1) = steer_rpt.data(j,1) - 65.5;
       end
       if(steer_rpt.data(j,2) > 30)
           steer_rpt.data(j,2) = steer_rpt.data(j,2) - 65.5;
       end
    end
end
clear data;
%% cmd_vel_with_limits
data = finddata(S,'_cmd_vel_with_limits');
if(~isempty(fieldnames(data)))
    cmd_vel = timeseries([data.(2) data.(7)],data.(1),'Name','Command Speed (m/s)');
end
clear data;
%% cmd_vel
data = finddata(S,'_cmd_vel');
if(~isempty(fieldnames(data)))
    cmd_vel = timeseries([data.(2) data.(7)],data.(1),'Name','Command Speed (m/s)');
end
clear data;
%% accel_cmd
data = finddata(S,'_pacmod_as_rx_accel_cmd');
if(~isempty(fieldnames(data)))
    accel_cmd = timeseries(data.(2),data.(1),'Name','Accelerator Command (%)');
end
clear data;
%% req_accel
data = finddata(S,'_req_accel');
if(~isempty(fieldnames(data)))
    req_accel = timeseries(data.(2),data.(1),'Name','Required Acceleration (m/s^2)');
end
clear data;
%% filtered accel
data = finddata(S,'_filtered_accel');
if(~isempty(fieldnames(data)))
    filtered_accel = timeseries(data.(2),data.(1),'Name','Filtered Acceleration (m/s^2)');
end
clear data;
%% end
% clear S;
save(strcat(folder_name,'data.mat'));
% plot_data
