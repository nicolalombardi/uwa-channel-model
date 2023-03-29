function [pos] = move_3d_random(input_pos, dist_m)
    theta_deg = rand() * 360;
    phi_deg = rand() * 360;

    theta_rad = theta_deg * pi / 180;
    phi_rad = phi_deg * pi / 180;

    dx = dist_m * sin(-phi_rad - theta_rad);
    dy = dist_m * cos(phi_rad + theta_rad);
    dz = dist_m * cos(theta_rad);

    pos = [input_pos(1) + dx, input_pos(2) + dy, input_pos(3) + dz];
end