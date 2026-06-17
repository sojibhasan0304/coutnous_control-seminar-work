% Task 3: Impulse response
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

% Display system information
disp('Transfer function G(s):');
G
disp('Poles:');
disp(pole(G));
disp('Zeros:');
disp(zero(G));
disp('Static gain:');
disp(dcgain(G));

% Impulse response
t = 0:0.01:50;
[h, t] = impulse(G, t);

figure;
plot(t, h, 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('h(t)');
title('Task 3: Impulse Response');

% Save figure
saveas(gcf, fullfile(figDir, 'impulse_response.png'));
