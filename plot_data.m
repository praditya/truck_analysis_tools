close all; clear all; clc;
S = csvread_all();
tot = sum(~cellfun('isempty',{S.name}));
for i = 1:tot
   S(i).name = strrep(S(i).name, '_slash_', ':');
   S(i).name = strrep(S(i).name, '_', ' ');
   S(i).name = strrep(S(i).name, '.csv', '');
%    T = S(i).table;
%    figure();
%    title(S(i).name);
%    hold on
%    leg = [];
%    for k = 2:width(T)
%        try
%            plot(T.(1),T.(k))
%            leg = [leg, T.Properties.VariableNames(k)];
%        catch
%            continue
%        end
%    end
%    legend(leg)
end
S(1).zerotime = S(1).table.(1)(1);
save 'data.mat' 'S'
clear all;
return
%% GPS Data
load('data.mat')
close all;
rate = 5;
gps = novatel_gps(S,rate);
% for i = 1:skip:length(gps.time)
%     circle(gps.N(i),gps.E(i),gps.latstd(i),gps.longstd(i))
% end
% lowres = 1:skip:length(gps.time);
% plot(gps.N(lowres), gps.E(lowres),'k.')
% figure()
% quiver(gps.N(lowres),gps.E(lowres),gps.heading2(lowres,1).*gps.speed(lowres)',gps.heading2(lowres,2).*gps.speed(lowres)')
% quiver(gps.N(lowres),gps.E(lowres),gps.heading2(lowres,1),gps.heading2(lowres,2))
% figure()
% quiver(gps.N(lowres),gps.E(lowres),gps.veldir(lowres,1).*gps.speed(lowres)',gps.veldir(lowres,2).*gps.speed(lowres)')
% plot(gps.time,gps.latstd,gps.time,gps.longstd)
% plot(gps.time(lowres),gps.headingerror(lowres))
% plot(gps.time(lowres),gps.heading(lowres), gps.time(lowres),gps.veldir(lowres))
% pathwrite('test.kml',gps.long,gps.lat,gps.alt)
plot(gps.N,gps.E,'.')
figure()
quiver(gps.N,gps.E,gps.speedxy(:,1),gps.speedxy(:,2))
figure()
plot(gps.time,gps.latstd,gps.time,gps.longstd)
legend 'latstd' 'longstd'
axis([gps.time(1) gps.time(end) 0 5])
figure()
hold on
% circleplot(gps.N,gps.E,gps.latstd,gps.longstd)
pathwrite('test.kml',gps.lat,gps.long,gps.alt)
% polywrite('test.kml',gps.lat,gps.long,gps.alt,gps.latstd,gps.longstd)
%% mavros GPS Speed
load('data.mat')
data = finddata(S,':mavros:local position:velocity');
if(isempty(fieldnames(data)))
    return
end
% plot(data.(1), sqrt(data.(10).^2 + data.(11).^2))
% xlabel 'Time(s)'
% ylabel 'Speed (m/s)'

mavros_spd = timeseries(sqrt(data.(10).^2 + data.(11).^2),data.(1),'Name', 'Mavros Speed (m/s)');
%% vehicle speed report
% close all; clear all;
load('data.mat')
data = finddata(S,':pacmod:parsed tx:vehicle speed rpt');
if(isempty(fieldnames(data)))
    return
end

data.(2) = data.(2)*0.18;

plot(data.(1),data.(2))
xlabel 'Time(s)'
ylabel 'Speed (m/s)'
hold on
pacmod_spd = timeseries(data.(2),data.(1),'Name','Pacmod Speed (m/s)');
%% accel_rpt
% load('data.mat')
data = finddata(S,':pacmod:parsed tx:accel rpt');
if(isempty(fieldnames(data)))
    return
end

plot(data.(1),data.(10))
xlabel 'Time(s)'
hold on
accel_rpt = timeseries(data.(10),data.(1),'Name','Accelerator Report (%)');
%% steer_rpt
load('data.mat')
data = finddata(S,':pacmod:parsed tx:steer rpt');
if(isempty(fieldnames(data)))
    return
end

plot(data.(1),data.(9))
xlabel 'Time(s)'
hold on
steer_rpt = timeseries(data.(9),data.(1),'Name','Steering Angle (rad)');
%% cmd_vel
load('data.mat')
data = finddata(S,':cmd vel with limits');
if(isempty(fieldnames(data)))
    return
end

plot(data.(1),data.(4))
xlabel 'Time(s)'
hold on
cmd_vel = timeseries(data.(4),data.(1),'Name','Command Speed (m/s)');
%% accel_cmd
load('data.mat')
data = finddata(S,':pacmod:as rx:accel cmd');
if(isempty(fieldnames(data)))
    return
end

plot(data.(1),data.(2))
xlabel 'Time(s)'
hold on
accel_cmd = timeseries(data.(2),data.(1),'Name','Accelerator Command (%)');
%% req_accel
load('data.mat')
data = finddata(S,':req accel');
if(isempty(fieldnames(data)))
    return
end

plot(data.(1),data.(2))
xlabel 'Time(s)'
hold on
req_accel = timeseries(data.(2),data.(1),'Name','Required Acceleration (m/s^2)');
%% filtered accel
load('data.mat')
data = finddata(S,':filtered accel');
if(isempty(fieldnames(data)))
    return
end

plot(data.(1),data.(2))
xlabel 'Time(s)'
hold on
filtered_accel = timeseries(data.(2),data.(1),'Name','Filtered Acceleration (m/s^2)');
%% accel analysis
close all;
[req_accel filtered_accel] = synchronize(req_accel, filtered_accel,'union','KeepOriginalTimes',true);
% temp = timeseries([req_accel.Data filtered_accel.Data], req_accel.Time);
% [accel_rpt temp] = synchronize(accel_rpt, temp,'union','KeepOriginalTimes',true);
plot(accel_rpt)
hold on
plot((req_accel-filtered_accel)*0.4+0.15)
% plot(temp.Time,accel_rpt.Data, temp.Time, (temp.Data(:,1)-temp.Data(:,2))*0.4+0.15);
plot(accel_cmd)
legend('Pacmod Accel\_rpt','Required Accel','Pacmod Accel\_cmd')
xlabel 'Time(s)'
ylabel 'Accel (%)'
title ''

%% speed analysis
% close all;
plot(mavros_spd)
hold on
plot(cmd_vel)
[mavros_spd cmd_vel] = synchronize(mavros_spd, cmd_vel,'union','KeepOriginalTimes',true);
plot((cmd_vel-mavros_spd))
legend('GPS speed','Command Speed','Error')
xlabel 'Time(s)'
ylabel 'Speed (m/s)'
title ''
%% pacmod throttle response analysis
close all;
[ax h1 h2] = plotyy(mavros_spd.Time,mavros_spd.Data,accel_rpt.Time,accel_rpt.Data)
legend('GPS Speed', 'Pacmod Accel\_rpt')
axes(ax(1));
ylabel 'Speed (m/s)'
xlabel 'Time (s)'
axes(ax(2));
ylabel 'Accelerator (%)'