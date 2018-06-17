% fft data plot (IMU data)
function fftplot(data_rpt)


% N = time interval (in seconds) : Total Sampling time
% data_rpt = timeseries data

% Example : 
% fftplot(corrimudata);

close all;
%get struct from timeseries object
data_rpt_ar = get(data_rpt);
% v = get(pacmod_spd);
% v = v.Data;
x = data_rpt_ar.Data(:,1); %time domain signal (for imu data)
L = length(x);  % number of points (Length of signal)
% Lv = length(v);
% N = 80; % Number of seconds 
% fsample = L/N; % sampling frequency
fsample = 50;
t = (0:(L-1))/fsample; %time vector
% tv = (0:(Lv-1))/fsample;
% x = x*fsample;

xdft = fft(x);
xdft = xdft(1:L/2+1);
psdx = (1/(fsample*L)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:fsample/L:fsample/2;

figure;
plot(freq,10*log10(psdx))
grid on
title('Periodogram Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')

figure;
plot(t,x);
xlabel('time(in seconds)');
ylabel('Amplitude');
title('Time Domain Report');
% hold on;
% plot(tv,v);

figure;
x_f = fft(x);
plot(abs(x_f));
% plot(abs(x_f(100:end-100)));  % getting very high peaks at start and end..so avoiding those peaks
xlabel('frequency(in Hz)');
ylabel('Amplitude(f)');
title('Frequency Domain Report');

figure;
% Autoregressive power spectral density estimate — Burg’s method
x_f = pmcov(x,2,length(x));
plot((x_f));
xlabel('frequency(in Hz)');
ylabel('PSD DB/Hz');
title('Power Spectral Density Report');

end


