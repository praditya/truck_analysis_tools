close all; clear all; clc;
%% read from folder
try
    folder_name = uigetdir('../../June 6th 2018');
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
%% corrimudata %imu data earlier from novatel was is m/s^2 per sample
data = finddata(S,'_imu_data'); %Not sure if needed anymore
if(~isempty(fieldnames(data)))
    corrimudata = timeseries([data.(20) data.(21) data.(22)],data.(1),'Name','Acceleration');
end
clear data;
%% Novatel INSPVAX
gps = novatel_gps(S);
% if(isempty(fieldnames(gps)))
%     clear gps
% end

% %% navsat Odom
% data = finddata(S,'_navsat_odom'); % Not sure if needed anymore
% if(~isempty(fieldnames(data)))
%     navsat_odom = timeseries([data.(6) data.(7) data.(8) data.(49) data.(50) data.(51)],data.(1),'Name','Navsat Odom');
% end
% clear data;

%% imu_data
% data = finddata(S,'_imu_data');
data = finddata(S,'_vectornav_imu');
if(~isempty(fieldnames(data)))
    imu_data = timeseries([data.(14) data.(15) data.(16)],data.(1),'Name','Angular Speed (rad/s)');
end
clear data;

%% vehicle speed report
data = finddata(S,'_pacmod_parsed_tx_vehicle_speed_rpt');
if(~isempty(fieldnames(data)))
%     [times idx] = unique(data.(1),'stable');
%     dat = data.(8);
%     pacmod_spd = timeseries(dat(idx)*0.44704,times,'Name','Pacmod Speed (m/s)'); % 0.44704 is conversion fro mph to m/s
% %         pacmod_spd = timeseries(dat(idx),times,'Name','Pacmod Speed (m/s)');
%     temp = [];

    pacmod_spd = timeseries(data.(8),epoch2mat(data.(1)),'Name','Pacmod Speed (mph)');
% for k = 2:length(pacmod_spd.data(1:end))
%     temp(k) = trapz(pacmod_spd.time(1:k) - pacmod_spd.time(1),pacmod_spd.data(1:k));
% end
%     pacmod_distance = timeseries(temp',pacmod_spd.time,'Name', 'Pacmod Distance (m)');
 end
clear data temp dat idx k times;
%% accel_rpt 
data = finddata(S,'_pacmod_parsed_tx_accel_rpt');
if(~isempty(fieldnames(data)))
    accel_rpt = timeseries(data.(17),epoch2mat(data.(1)),'Name','Accelerator Report (%)');
end
clear data;
%% brake_rpt
data = finddata(S,'_pacmod_parsed_tx_brake_rpt');
if(~isempty(fieldnames(data)))
     brake_rpt = timeseries(data.(17),epoch2mat(data.(1)), 'Name', 'Brake Report Output (%)'); %If negative value, no braking. Value between 0 & -1
end
clear data;
%% enable
data = finddata(S,'_pacmod_as_tx_enable');
if(~isempty(fieldnames(data)))
    truefalse = [];
    for j = 1:length(data.(2))
        truefalse(j) = data.(2){j}=="True";
    end
    pacmod_enable = timeseries(truefalse',epoch2mat(data.(1)),'Name','Enable');
end
clear data truefalse;
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
    cmd_vel = timeseries([data.(4) data.(10)],epoch2mat(data.(1)),'Name','Command Speed (m/s)');
end
clear data;
%% cmd_vel
data = finddata(S,'_cmd_vel');
if(~isempty(fieldnames(data)))
    cmd_vel = timeseries([data.(3) data.(9)],epoch2mat(data.(1)),'Name','Command Speed (m/s)');
end

clear data;
%% cmd_brake
data = finddata(S,'_pacmod_parsed_tx_brake_rpt');
if(~isempty(fieldnames(data)))
    cmd_brake = timeseries(data.(16),epoch2mat(data.(1)),'Name','Brake Command (%)');
end 
clear data;
%% accel_cmd
data = finddata(S,'_pacmod_parsed_tx_accel_rpt');
if(~isempty(fieldnames(data)))
    accel_cmd = timeseries(data.(16),epoch2mat(data.(1)),'Name','Accelerator Command (%)');
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
    filtered_accel = timeseries(data.(2),epoch2mat(data.(1)),'Name','Filtered Acceleration (m/s^2)');
end
clear data;
%% end
% clear S;
issim = false;
save(strcat(folder_name,'data.mat'));



%Originally made by:

%Garrison Neel @neelg1193

%Modified by:

%Amir Darwesh @amirx96
