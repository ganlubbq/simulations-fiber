clc;
clear;
close all;

% Write functions to implement:
% de-rotate the constellation disgram back for visualization purpose

%% Load data
load ssf_signal_polarization_7.mat

%% Test function
param = derotate_constellation(param);

for k=(param.channel_number+1)/2%1:param.channel_number
    u = param.signal_received_constellation_derotate{k};
    figure;
    hold on
    plot(u(:, 1), u(:, 2), '.')
    v = param.cloud_centers_derotation{k};
    plot(v(:, 1), v(:, 2), 'x', 'linewidth', 2)
end