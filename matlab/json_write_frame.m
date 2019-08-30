function json_write_frame(fileID_data, joints_per_frame, no_of_joints, cols)

    for j = 1 : no_of_joints        
        for c = 1 : cols
            fprintf(fileID_data,[num2str(joints_per_frame(j,c)), ' ']);
        end        
        fprintf(fileID_data,'\n');
    end    
end