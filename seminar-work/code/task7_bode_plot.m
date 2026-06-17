% Task 7: Goniometric/exponential frequency response table and Bode plots
%
% |G(jw)| = sqrt(1 + 4w^2)/sqrt(1 + 21w^2 + 4w^4)
% phase = atan2(2w,1) - atan2(5w,1 - 2w^2)

clear; clc; close all;

% Create figures folder automatically
thisFile = mfilename('fullpath');
if isempty(thisFile)
    baseDir = pwd;
else
    baseDir = fileparts(thisFile);
end
figDir = fullfile(baseDir, '..', 'figures');
if ~exist(figDir, 'dir')
    mkdir(figDir);
end

% Plant
s = tf('s');
G = (2*s + 1)/(2*s^2 + 5*s + 1);

% At least 10 frequency values
w = [0 0.5 1 2 3 5 10 20 50 100]';

Magnitude = sqrt(1 + 4*w.^2)./sqrt(1 + 21*w.^2 + 4*w.^4);
Magnitude_dB = 20*log10(Magnitude);

phase_rad = atan2(2*w, 1) - atan2(5*w, 1 - 2*w.^2);
phase_deg = rad2deg(unwrap(phase_rad));

T = table(w, Magnitude, Magnitude_dB, phase_deg, 'VariableNames', ...
    {'omega_rad_per_s', 'Magnitude_abs', 'Magnitude_dB', 'Phase_deg'});

disp('Task 7: Goniometric frequency response table');
disp(T);

% Save table as CSV
writetable(T, fullfile(figDir, 'task7_goniometric_frequency_table.csv'));

% Bode plots using MATLAB
figure;
bode(G);
grid on;
title('Task 7: Bode Plot');
saveas(gcf, fullfile(figDir, 'bode_plot.png'));

% Manual Bode plots for report style
w_dense = logspace(-3, 3, 2000);
mag_dense = squeeze(abs(freqresp(G, w_dense)));
phase_dense = squeeze(angle(freqresp(G, w_dense)));
phase_dense_deg = rad2deg(unwrap(phase_dense));
mag_dense_db = 20*log10(mag_dense);

figure;
subplot(2,1,1);
semilogx(w_dense, mag_dense_db, 'LineWidth', 1.5);
grid on;
xlabel('Frequency \omega (rad/s)');
ylabel('Magnitude (dB)');
title('Task 7: Bode Magnitude Plot');

subplot(2,1,2);
semilogx(w_dense, phase_dense_deg, 'LineWidth', 1.5);
grid on;
xlabel('Frequency \omega (rad/s)');
ylabel('Phase (degrees)');
title('Task 7: Bode Phase Plot');

saveas(gcf, fullfile(figDir, 'bode_plot_manual.png'));
