f = figure('visible', 'off');
%% GPS Data
try
novatel_plots
hold off
end
%%plot wpts (if loaded)
try
    hold on
    plot(wpts.N,wpts.E)
    daspect([1 1 1])
end
%% throttle_plot
try
plot(accel_cmd,'.-')
hold on
plot(accel_rpt,'.-')
xlabel 'Time(s)'
ylabel 'Throttle'
legend('Command', 'Pacmod Rpt')
title ''
hold off

print('-djpeg', strcat(folder_name,'throttle_plot.jpg'))
end

%% throttle analysis
% try
% [req_accel filtered_accel] = synchronize(req_accel, filtered_accel,'union','KeepOriginalTimes',true);
% % temp = timeseries([req_accel.Data filtered_accel.Data], req_accel.Time);
% % [accel_rpt temp] = synchronize(accel_rpt, temp,'union','KeepOriginalTimes',true);
% plot(accel_rpt)
% hold on
% % plot((req_accel-filtered_accel)*0.4+0.15)
% % plot(temp.Time,accel_rpt.Data, temp.Time, (temp.Data(:,1)-temp.Data(:,2))*0.4+0.15);
% plot(accel_cmd)
% legend('Pacmod Accel\_rpt','Required Accel','Pacmod Accel\_cmd')
% xlabel 'Time(s)'
% ylabel 'Accel (%)'
% title ''
% hold off
% 
% print('-djpeg', strcat(folder_name,'throttle_analysis.jpg'))
% end

%% accel analysis
try
[req_accel filtered_accel] = synchronize(req_accel, filtered_accel,'union','KeepOriginalTimes',true);
plot(req_accel)
hold on
plot(filtered_accel)
legend('Required Accel' ,'Actual Accel')
xlabel 'Time(s)'
ylabel 'Acceleration (m/s^2)'
title ''
hold off

print('-djpeg', strcat(folder_name,'accel_analysis.jpg'))
end

%% speed analysis
try
plot(mavros_spd)
hold on
plot(cmd_vel)
[mavros_spd cmd_vel] = synchronize(mavros_spd, cmd_vel,'union','KeepOriginalTimes',true);
% plot((cmd_vel-mavros_spd))
legend('GPS speed','Command Speed')
xlabel 'Time(s)'
ylabel 'Speed (m/s)'
title ''
hold off

print('-djpeg', strcat(folder_name,'speed_analysis.jpg'))
end
%% pacmod throttle response analysis
% try
% [ax h1 h2] = plotyy(mavros_spd.Time,mavros_spd.Data,accel_rpt.Time,accel_rpt.Data);
% legend('GPS Speed', 'Pacmod Accel\_rpt')
% axes(ax(1));
% ylabel 'Speed (m/s)'
% xlabel 'Time (s)'
% axes(ax(2));
% ylabel 'Accelerator (%)'
% clear h1 h2 ax
% 
% print('-djpeg', strcat(folder_name,'pacmod_throttle_analysis.jpg'))
% end
%% delay
% delay
%% corrimudata
try
time = corrimudata.time;
rate = [0;1./diff(time)];
hold on
plot(corrimudata.time,corrimudata.data(:,2).*50)
xfilt = filter(.02/.25, [1 .02/.25-1], corrimudata.data(:,2).*50);
% plot(xfilt)
plot(corrimudata.time,xfilt)
min(xfilt)
end
%% curvature analysis
try
  figure()
    hold on
    plot(cmd_vel.time,cmd_vel.data(:,1))
    plot(gps.time,gps.speed)
    figure()
    hold on
    plot(imu_data.time(:,1),-imu_data.data(:,3))
    plot(cmd_vel.time,cmd_vel.data(:,2))
    r = cmd_vel.data(:,1)./cmd_vel.data(:,2);
    [ts1, ts2] = synchronize(timeseries(gps.speed,gps.time),imu_data,'Uniform','Interval',0.05);
    rad = ts1.data./ts2.data(:,3);
    %%
    figure()     
    hold on
    plot(cmd_vel.time,r)
    plot(ts1.time, -rad)
    wb = 2.565;
    SR = 24;
    radius = wb./tan(steer_rpt.data(:,1)./SR);
    plot(steer_rpt.time,radius)
    ylim([-20 20])
    xlim([0 steer_rpt.time(end)])
end
%% end 
close(f)
clear f