% Task 4: Step response
% System:
% 2y''(t) + 5y'(t) + y(t) = 2u'(t) + u(t)
% G(s) = (2s + 1)/(2s^2 + 5s + 1)

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

% Plant parameters
a2 = 2; a1 = 5; a0 = 1;
b1 = 2; b0 = 1;

s = tf('s');
G = (b1*s + b0)/(a2*s^2 + a1*s + a0);

% Step response
t = 0:0.01:50;
[y, t] = step(G, t);

figure;
plot(t, y, 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('y(t)');
title('Task 4: Step Response');

% Save figure
saveas(gcf, fullfile(figDir, 'step_response.png'));

% Optional: display final value
fprintf('Final value of step response = %.4f\n', y(end));
