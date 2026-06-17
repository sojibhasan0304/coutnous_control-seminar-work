% Task 6: Algebraic frequency response table and Nyquist plot
% G(jw) = Re(G(jw)) + j Im(G(jw))
%
% Re(G(jw)) = (1 + 8w^2)/(1 + 21w^2 + 4w^4)
% Im(G(jw)) = (-3w - 4w^3)/(1 + 21w^2 + 4w^4)

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

den = 1 + 21*w.^2 + 4*w.^4;
ReG = (1 + 8*w.^2)./den;
ImG = (-3*w - 4*w.^3)./den;

T = table(w, ReG, ImG, 'VariableNames', ...
    {'omega_rad_per_s', 'Real_Gjw', 'Imag_Gjw'});

disp('Task 6: Algebraic frequency response table');
disp(T);

% Save table as CSV
writetable(T, fullfile(figDir, 'task6_algebraic_frequency_table.csv'));

% Nyquist plot by formula
w_dense = logspace(-3, 3, 2000);
den_dense = 1 + 21*w_dense.^2 + 4*w_dense.^4;
Re_dense = (1 + 8*w_dense.^2)./den_dense;
Im_dense = (-3*w_dense - 4*w_dense.^3)./den_dense;

figure;
plot(Re_dense, Im_dense, 'LineWidth', 1.5); hold on;
plot(Re_dense, -Im_dense, '--', 'LineWidth', 1.2);
plot(1, 0, 'o', 'MarkerFaceColor', 'auto');
plot(0, 0, 'o', 'MarkerFaceColor', 'auto');
grid on;
xlabel('Real');
ylabel('Imaginary');
title('Task 6: Nyquist Plot');
legend('Positive frequency', 'Negative frequency', 'Location', 'best');
axis equal;

% Save figure
saveas(gcf, fullfile(figDir, 'nyquist_plot.png'));

% MATLAB built-in Nyquist plot, optional
figure;
nyquist(G);
grid on;
title('Task 6: Nyquist Plot using MATLAB nyquist()');
saveas(gcf, fullfile(figDir, 'nyquist_plot_matlab_builtin.png'));
