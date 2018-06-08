% fft data plot
function fftplot(data_rpt,N)

% N = time interval (in seconds) : Total Sampling time
% data_rpt = timeseries data

data_rpt_ar = get(data_rpt);

L = length(data_rpt_ar.Data);  % number of points (Length of signal)
% N = 80; % Number of seconds 
fsample = L/N; % sampling frequency
t = (0:(L-1))/fsample; %time vector
x = data_rpt_ar.Data; %time domain signal

figure;
plot(t,x);
xlabel('time(in seconds)');
ylabel('Acceleration %');
title('Time Domain Report');

figure;
x_f = fft(x);
% plot(abs(x_f));
plot(abs(x_f(100:end-100)));  % getting very high peaks at start and end..so avoiding those peaks
xlabel('frequency(in Hz)');
ylabel('Acceleration %');
title('Frequency Domain Report');

figure;
x_f = pburg(x,4);
plot((x_f));
xlabel('frequency(in Hz)');
ylabel('Acceleration %');
title('Power Spectral Density Report');

end


