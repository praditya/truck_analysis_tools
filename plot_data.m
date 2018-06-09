f = figure('visible', 'off');
%% GPS Data
try
novatel_plots
hold off
end
%% plot wpts (if loaded)
try
    hold on
    plot(wpts.N - wpts.N(1),wpts.E - wpts.E(1),'.')
    daspect([1 1 1])
    ylabel 'N (m)'
    xlabel 'E (m)'
    legend  'Logged Path' 'Waypoint Path'
    print('-depsd', strcat(folder_name,'path_plot.eps'))
    hold off
end
%% veh_speed analysis
plot(pacmod_spd)
hold on
plot(pacmod_enable);
plot(brake_rpt);
%plot(cmd_brake);
plot(accel_rpt);
legend('Speed [mph]', 'Auto Enabled', 'Brake %', 'Throttle %');
datetick('x','MM:SS')
xlabel('MM:SS')
hold off
%% slope calcs
try
   X = [ones(length(slope),1) slope(:,1)];
   slp = X\slope(:,2);
end
%% throttle_plot
try
plot(accel_cmd,'b')
hold on
plot(accel_rpt,'r')

xlabel 'Time(s)'
ylabel 'Throttle'
legend('Command', 'Pacmod Rpt')
title ''
datetick('x','MM:SS')
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

print('-depsc', strcat(folder_name,'accel_analysis.eps'))
end

%% speed analysis
try
plot(gps.time,gps.speed)
hold on
plot(cmd_vel.time, cmd_vel.data(:,1))
% plot((cmd_vel-mavros_spd))
legend('GPS speed','Command Speed')
xlabel 'Time(s)'
ylabel 'Speed (m/s)'
% xlim([0 12])
ylim([0 10])
title ''
hold off

print('-depsc', strcat(folder_name,'speed_analysis.eps'))
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
% plot(corrimudata.time,corrimudata.data(:,2).*50)
Fs = 50;
% x = sqrt(corrimudata.data(:,1).^2*50+corrimudata.data(:,2).^2*50+corrimudata.data(:,3).^2*50);
x = corrimudata.data(1:100,1)*50;
N = length(x);
xdft = fft(x);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(x):Fs/2;

plot(freq,10*log10(psdx))
grid on
title('Periodogram Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')
% figure
hold on
xfilt = filter(.02/.25, [1 .02/.25-1], corrimudata.data(:,2).*50);
% plot(xfilt)
% plot(corrimudata.time,xfilt)
min(xfilt);
%     ylabel 'Acceleration (m/s^2)'
%     xlabel 'Time (s)'
%     legend  'Imu Raw' 'Filtered Acceleration'
hold off
% print('-djpeg', strcat(folder_name,'filter_test.jpg'))
end
%% curvature analysis
try
%     figure()
    plot(imu_data.time(:,1),imu_data.data(:,3))
    hold on
    plot(cmd_vel.time,cmd_vel.data(:,2))
    r = cmd_vel.data(:,1)./cmd_vel.data(:,2);
    [ts1, ts2] = synchronize(timeseries(gps.speed,gps.time),imu_data,'Uniform','Interval',0.05);
    rad = ts1.data./ts2.data(:,3);
    ylabel 'Angular Rate (rad/s)'
    xlabel 'Time (s)'
    legend  'IMU Data' 'Command Data'
    hold off
    print('-djpeg', strcat(folder_name,'Angular_analyis.jpg'))
    %%
%     figure()
    plot(ts1.time, -1./rad)
    hold on
    plot(cmd_vel.time,1./r)    
    wb = 2.565;
    SR = 24;
    radius = wb./tan(steer_rpt.data(:,1)./SR);
    %plot(steer_rpt.time,radius)
%     ylim([-20 20])
    xlim([0 steer_rpt.time(end)])
    ylabel 'Curvature (m^-^1)'
    xlabel 'Time (s)'
    legend  'IMU Data' 'Command Data' %'Pacmod Steering Data'
    hold off
    print('-djpeg', strcat(folder_name,'radius_compare.jpg'))
end
%% create KML of path
try
   kmlcreate(strcat(folder_name,'/Path.kml'),gps.lat,gps.long,gps.alt);
catch
    disp 'kmlcreate failed'
end
   disp('done');
%% end
close(f)
clear f
