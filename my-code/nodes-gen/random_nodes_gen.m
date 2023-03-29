function [nodes_pos] = random_nodes_gen(num_nodes, max_range_m, min_depth_m, max_depth_m)
    nodes_pos = [
        rand([num_nodes 2]).*max_range_m, min_depth_m + rand([num_nodes 1]).*(max_depth_m-min_depth_m)
    ];    
end