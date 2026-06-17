% Tasks 8, 9, and 16: Controller simulations
%
% Plant:
% G(s) = (2s + 1)/(2s^2 + 5s + 1)
%
% The script displays u(t), e(t), and y(t) for:
% Task 8  - polynomial/PI controller used in the report
% Task 9  - simple PI controller
% Task 16 - state-feedback controller with integral action

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

% Simulation time
t = 0:0.01:50;

% Step reference r(t) = 1
r = ones(size(t));

% Step load disturbance.
% Here disturbance starts at t = 10 s so the reference response and
% disturbance rejection can both be seen clearly.
d = double(t >= 10);

%% Helper transfer functions for 1DoF feedback with plant-input disturbance
% Plant equation with disturbance:
% y = G(s)*(u + d)
% u = C(s)*(r - y)
%
% Therefore:
% y/r = C*G/(1 + C*G)
% y/d = G/(1 + C*G)
% e/r = 1/(1 + C*G)
% e/d = -G/(1 + C*G)
% u/r = C/(1 + C*G)
% u/d = -C*G/(1 + C*G)

%% Task 8: Polynomial algebraic method controller
% Controller written in the report:
% C8(s) = (6.5s + 19.25)/s
C8 = (6.5*s + 19.25)/s;

[y8, e8, u8] = simulate_1dof_with_disturbance(G, C8, r, d, t);

disp('Task 8 controller C8(s):');
C8
disp('Task 8 closed-loop poles:');
disp(pole(feedback(C8*G, 1)));

plot_responses(t, u8, e8, y8, ...
    'Task 8: Polynomial/PI Controller Responses', ...
    fullfile(figDir, 'task8_control_responses.png'));

%% Task 9: Simple PI controller
% Chosen values:
% Kp = 5, Ki = 10
Kp = 5;
Ki = 10;
C9 = Kp + Ki/s;

[y9, e9, u9] = simulate_1dof_with_disturbance(G, C9, r, d, t);

disp('Task 9 controller C9(s):');
C9
disp('Task 9 closed-loop poles:');
disp(pole(feedback(C9*G, 1)));

plot_responses(t, u9, e9, y9, ...
    'Task 9: PI Controller Responses', ...
    fullfile(figDir, 'task9_control_responses.png'));

%% Task 10: Stability verification for Tasks 8 and 9
poles8 = pole(feedback(C8*G, 1));
poles9 = pole(feedback(C9*G, 1));

fprintf('\nTask 10 stability check:\n');
if all(real(poles8) < 0)
    fprintf('Task 8 closed-loop system is asymptotically stable.\n');
else
    fprintf('Task 8 closed-loop system is NOT asymptotically stable.\n');
end

if all(real(poles9) < 0)
    fprintf('Task 9 closed-loop system is asymptotically stable.\n');
else
    fprintf('Task 9 closed-loop system is NOT asymptotically stable.\n');
end

%% Task 16: State-feedback controller with integral action
% Convert plant to state-space
sys_ss = ss(G);
A = sys_ss.A;
B = sys_ss.B;
Cmat = sys_ss.C;
Dmat = sys_ss.D;

n = size(A, 1);

% Augmented model with integrator:
% x_i_dot = r - y
Aaug = [A, zeros(n,1);
       -Cmat, 0];

Baug = [B;
       -Dmat];

Br = [zeros(n,1);
      1];

% Desired poles from assignment/report:
% -a0, -a1, -0.5(a0+a1) = -1, -5, -3
desired_poles = [-1 -5 -3];

% State feedback gain:
% u = -Kaug*[x; xi]
Kaug = place(Aaug, Baug, desired_poles);

Acl = Aaug - Baug*Kaug;

% Outputs: u(t), e(t), y(t)
C_u = -Kaug;
D_u = 0;

C_e = [-Cmat, 0];
D_e = 1;

C_y = [Cmat, 0];
D_y = 0;

sys_task16 = ss(Acl, Br, [C_u; C_e; C_y], [D_u; D_e; D_y]);

resp16 = step(sys_task16, t);
u16 = resp16(:,1);
e16 = resp16(:,2);
y16 = resp16(:,3);

disp('Task 16 augmented state-feedback gain Kaug:');
disp(Kaug);
disp('Task 16 closed-loop poles:');
disp(eig(Acl));

plot_responses(t, u16, e16, y16, ...
    'Task 16: State-Feedback Controller Responses', ...
    fullfile(figDir, 'task16_state_feedback_responses.png'));

%% Local functions
function [y, e, u] = simulate_1dof_with_disturbance(G, C, r, d, t)
    T_r_to_y = feedback(C*G, 1);
    T_d_to_y = feedback(G, C);

    T_r_to_e = feedback(1, C*G);
    T_d_to_e = -feedback(G, C);

    T_r_to_u = feedback(C, G);
    T_d_to_u = -feedback(C*G, 1);

    y = lsim(T_r_to_y, r, t) + lsim(T_d_to_y, d, t);
    e = lsim(T_r_to_e, r, t) + lsim(T_d_to_e, d, t);
    u = lsim(T_r_to_u, r, t) + lsim(T_d_to_u, d, t);
end

function plot_responses(t, u, e, y, figTitle, savePath)
    figure;

    subplot(3,1,1);
    plot(t, u, 'LineWidth', 1.5);
    grid on;
    xlabel('Time (s)');
    ylabel('u(t)');
    title([figTitle ' - Control Input']);

    subplot(3,1,2);
    plot(t, e, 'LineWidth', 1.5);
    grid on;
    xlabel('Time (s)');
    ylabel('e(t)');
    title([figTitle ' - Error']);

    subplot(3,1,3);
    plot(t, y, 'LineWidth', 1.5);
    grid on;
    xlabel('Time (s)');
    ylabel('y(t)');
    title([figTitle ' - Output']);

    saveas(gcf, savePath);
end
