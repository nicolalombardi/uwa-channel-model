% Base bellhop settings
save_raw_imp_resp = false;
ssp = [];
water_depth_m = 2000;
center_freq_hz = 24e3;
bandwidth_hz = 7.2e3;
max_hill_height_m = 10;
rng_seed = 12345;


% Simulation settings
sim_duration_s = 2;
% sim_duration_s = 60 * 60;
sim_time_step_s = 1;
sim_drift_speed_m_s = 0.2;

% Starting nodes position
nodes_num = 5;
nodes_range = 5000;
nodes_min_depth = 20;
nodes_max_depth = 460;

nodes_pos = random_nodes_gen(nodes_num, nodes_range, nodes_min_depth, nodes_max_depth);


scatter3(nodes_pos(:, 1), nodes_pos(:, 2), nodes_pos(:, 3))
text(nodes_pos(:, 1), nodes_pos(:, 2), nodes_pos(:, 3), string(1:nodes_num))


%% Run simulations
for time = 0:sim_time_step_s:sim_duration_s
    disp(['Simulating at time ' num2str(time) 's']);
    

    % Loop through nodes and move them a bit
    for idx = 1:nodes_num
        nodes_pos(idx, :) = move_3d_random(nodes_pos(idx, :), sim_drift_speed_m_s / sim_time_step_s);
    end

    % Output nodes positions in a file
    nodes_pos_file = strcat('output/t_',num2str(time), '_nodes_pos.csv');
    fid = fopen(nodes_pos_file, 'w');
    fprintf(fid, 'INDEX,XPOS,YPOS,DEPTH\n');
    fclose(fid);
    % Create column vector of node indices
    nodes_ind_column = (1:nodes_num)';
    % Append the node positions and indices to the CSV file
    dlmwrite(nodes_pos_file, [nodes_ind_column, nodes_pos], '-append', 'delimiter', ',');

    % set output file name to reflect simulation time
    output_file = strcat('output/t_',num2str(time), '_channel_data.csv');

    custom_create_3d_channel_lut(nodes_pos, output_file, save_raw_imp_resp, ssp, water_depth_m, center_freq_hz, bandwidth_hz, max_hill_height_m, rng)
    % create_3d_channel_lut(nodes_pos, nodes_pos, output_file, save_raw_imp_resp, ssp, water_depth_m, center_freq_hz, bandwidth_hz, max_hill_height_m)

end


