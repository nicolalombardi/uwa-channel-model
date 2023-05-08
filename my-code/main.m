json_str = fileread('config.json');

config = jsondecode(json_str);

% Base bellhop settings
save_raw_imp_resp = config.MAT_SAVE_RAW_IMP_RESP;
ssp = [];
water_depth_m = config.MAT_WATER_DEPTH_M;
center_freq_hz = config.MAT_CENTER_FREQ_HZ;
bandwidth_hz = config.MAT_BANDWIDTH_HZ;
max_hill_height_m = config.MAT_MAX_HILL_HEIGHT_M;
rng_seed = config.MAT_RNG_SEED;


% Simulation settings
sim_duration_ms = config.SHR_SIM_DURATION_MS;
sim_time_step_ms = config.SHR_SIM_TIME_STEP_MS;
sim_drift_speed_m_s = config.MAT_SIM_DRIFT_SPEED_M_S;

% Starting nodes position
nodes_num = config.SHR_SIM_NODES_NUM;
nodes_range = config.MAT_SIM_NODES_RANGE_M;
nodes_min_depth = config.MAT_MIN_DEPTH_M;
nodes_max_depth = config.MAT_MAX_DEPTH_M;

nodes_pos = random_nodes_gen(nodes_num, nodes_range, nodes_min_depth, nodes_max_depth);


scatter3(nodes_pos(:, 1), nodes_pos(:, 2), nodes_pos(:, 3))
text(nodes_pos(:, 1), nodes_pos(:, 2), nodes_pos(:, 3), string(1:nodes_num))

% Create output folder for current simulation
out_folder_name = strcat('output_', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));

if ~exist(out_folder_name, 'dir')
    mkdir(out_folder_name);
else
    disp('output folder already exists, exiting...');
    return;
end


%% Run simulations
for time = 0:sim_time_step_ms:sim_duration_ms
    disp(['Simulating at time ' num2str(time) 'ms']);
    

    % Loop through nodes and move them a bit
    for idx = 1:nodes_num
        nodes_pos(idx, :) = move_3d_random(nodes_pos(idx, :), sim_drift_speed_m_s / (sim_time_step_ms/1000));
    end

    % Output nodes positions in a file
    nodes_pos_file = strcat(out_folder_name, '/t_',num2str(time), '_nodes_pos.csv');
    fid = fopen(nodes_pos_file, 'w');
    fprintf(fid, 'INDEX,XPOS,YPOS,DEPTH\n');
    fclose(fid);
    % Create column vector of node indices
    nodes_ind_column = (1:nodes_num)';
    % Append the node positions and indices to the CSV file
    dlmwrite(nodes_pos_file, [nodes_ind_column, nodes_pos], '-append', 'delimiter', ',');

    % set output file name to reflect simulation time
    output_file = strcat(out_folder_name, '/t_',num2str(time), '_channel_data.csv');

    custom_create_3d_channel_lut(nodes_pos, output_file, save_raw_imp_resp, ssp, water_depth_m, center_freq_hz, bandwidth_hz, max_hill_height_m, rng)
    % create_3d_channel_lut(nodes_pos, nodes_pos, output_file, save_raw_imp_resp, ssp, water_depth_m, center_freq_hz, bandwidth_hz, max_hill_height_m)

end

disp('done');


