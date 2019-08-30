function [joint_vector, missing_value] = json_joints_from_struct_to_mat(joint_as_table, fr, cols)

    % 'x', 'y', 'z', 'depthX', 'depthY', 'colorX', 'colorY',
    % 'orientationW', 'orientationX', 'orientationY',
    % 'orientationZ', 'trackingState'
    
    missing_value = false;
    
    %%
    joint_vector_table = joint_as_table(fr,:);
    col_headers = joint_vector_table.Properties.VariableNames;
    
    joint_vector = repmat(NaN, 1, cols);
    % joint_vector_table
    joint_vector(1) = joint_vector_table.cameraX;
    joint_vector(2) = joint_vector_table.cameraY;
    joint_vector(3) = joint_vector_table.cameraZ;
    
    % depthX (4)
    % depthY (5)
    % colorX (6)
    % colorY (7)
    
    % TODO! Check these units    
    found = strfind(col_headers, 'AbsQuat_X');
    if ~isempty(cat(1, found{:}))
        joint_vector(8) = joint_vector_table.AbsQuat_W;
        joint_vector(9) = joint_vector_table.AbsQuat_X;
        joint_vector(10) = joint_vector_table.AbsQuat_Y;
        joint_vector(11) = joint_vector_table.AbsQuat_Z;
    else
        % TODO! Fix upstream, these are empty recordings, or empty folders
        % in the original Kimore dataset
        joint_vector(8) = joint_vector_table.AbsQuat_4;
        joint_vector(9) = joint_vector_table.AbsQuat_1;
        joint_vector(10) = joint_vector_table.AbsQuat_2;
        joint_vector(11) = joint_vector_table.AbsQuat_3;
    end
        
    joint_vector(12) = round(joint_vector_table.confidenceState);
    

end